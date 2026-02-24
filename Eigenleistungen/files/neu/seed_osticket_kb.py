#!/usr/bin/env python3
"""
Idempotent osTicket Knowledgebase seeder with runtime schema discovery.

Default mode is --apply (non-interactive), with optional --dry-run.
"""

from __future__ import annotations

import argparse
import json
import logging
import os
import re
import sys
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, Iterable, List, Optional, Sequence, Tuple


LOG = logging.getLogger("seed_osticket_kb")


def _import_db_driver():
    try:
        import pymysql  # type: ignore

        return "pymysql", pymysql
    except Exception:
        pass

    try:
        import MySQLdb  # type: ignore
        import MySQLdb.cursors  # type: ignore

        return "mysqldb", MySQLdb
    except Exception:
        pass

    raise RuntimeError(
        "No MySQL driver available. Install PyMySQL (`pip install pymysql`) "
        "or mysqlclient (`pip install mysqlclient`)."
    )


DB_DRIVER_NAME, DB_DRIVER = _import_db_driver()


@dataclass
class ColumnMeta:
    name: str
    data_type: str
    column_type: str
    is_nullable: bool
    default: Optional[str]
    extra: str


@dataclass
class TableMeta:
    name: str
    columns: List[ColumnMeta]
    pk: List[str]
    unique_keys: List[List[str]]

    @property
    def colmap(self) -> Dict[str, ColumnMeta]:
        return {c.name: c for c in self.columns}

    @property
    def colnames(self) -> List[str]:
        return [c.name for c in self.columns]


@dataclass
class SchemaDiscovery:
    prefix: str
    faq_table: TableMeta
    category_table: TableMeta
    faq_topic_table: Optional[TableMeta]
    help_topic_table: Optional[TableMeta]
    config_tables: List[TableMeta]


@dataclass
class Summary:
    categories_created: int = 0
    categories_updated: int = 0
    categories_skipped: int = 0
    faqs_created: int = 0
    faqs_updated: int = 0
    faqs_skipped: int = 0
    topics_created: int = 0
    topics_updated: int = 0
    topics_skipped: int = 0
    mappings_created: int = 0
    mappings_skipped: int = 0
    config_updates: int = 0
    warnings: int = 0
    errors: int = 0

    def as_dict(self) -> Dict[str, int]:
        return self.__dict__.copy()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Seed osTicket KB demo data with dynamic schema discovery."
    )
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--apply", action="store_true", help="Apply changes (default).")
    mode.add_argument("--dry-run", action="store_true", help="Simulate and rollback.")
    parser.add_argument("--root", help="osTicket root directory override.")
    parser.add_argument("--config", help="Path to osTicket config file override.")
    parser.add_argument(
        "--dataset",
        default=str(Path(__file__).with_name("kb_demo.json")),
        help="Path to JSON dataset (default: ./kb_demo.json)",
    )
    parser.add_argument(
        "--log-level",
        default="info",
        choices=["debug", "info", "warn", "error"],
        help="Log level (default: info)",
    )
    parser.set_defaults(apply=True)
    args = parser.parse_args()
    if args.dry_run:
        args.apply = False
    return args


def setup_logging(level: str) -> None:
    level_map = {
        "debug": logging.DEBUG,
        "info": logging.INFO,
        "warn": logging.WARNING,
        "error": logging.ERROR,
    }
    logging.basicConfig(
        level=level_map[level],
        format="[%(levelname)s] %(message)s",
    )


def find_osticket_root(explicit_root: Optional[str], explicit_config: Optional[str]) -> Tuple[Path, Path]:
    if explicit_config:
        config_path = Path(explicit_config).expanduser().resolve()
        if not config_path.is_file():
            raise FileNotFoundError(f"Config file not found: {config_path}")
        root = config_path.parent.parent
        return root, config_path

    if explicit_root:
        root = Path(explicit_root).expanduser().resolve()
        if not root.is_dir():
            raise FileNotFoundError(f"osTicket root not found: {root}")
        for rel in ("include/ost-config.php", "include/settings.php"):
            candidate = root / rel
            if candidate.is_file():
                return root, candidate
        raise FileNotFoundError(f"No osTicket config found under root: {root}")

    start = Path.cwd().resolve()
    candidates = [start] + list(start.parents)
    for base in candidates:
        for rel in ("include/ost-config.php", "include/settings.php"):
            candidate = base / rel
            if candidate.is_file():
                return base, candidate

    raise FileNotFoundError(
        "Could not locate osTicket root. Use --root or --config."
    )


def parse_php_defines(config_path: Path) -> Dict[str, str]:
    text = config_path.read_text(encoding="utf-8", errors="ignore")
    pattern = re.compile(
        r"define\(\s*['\"]([A-Z0-9_]+)['\"]\s*,\s*(.*?)\s*\)\s*;",
        re.DOTALL,
    )
    values: Dict[str, str] = {}
    for key, raw in pattern.findall(text):
        raw = raw.strip()
        if len(raw) >= 2 and raw[0] in ("'", '"') and raw[-1] == raw[0]:
            val = raw[1:-1]
            val = val.replace(r"\'", "'").replace(r"\"", '"').replace(r"\\", "\\")
            values[key] = val
            continue
        # Bare token, e.g. TRUE/FALSE/number
        values[key] = raw
    return values


def db_connect(host: str, name: str, user: str, password: str):
    if DB_DRIVER_NAME == "pymysql":
        return DB_DRIVER.connect(
            host=host,
            user=user,
            password=password,
            database=name,
            charset="utf8mb4",
            autocommit=False,
            cursorclass=DB_DRIVER.cursors.DictCursor,
        )
    return DB_DRIVER.connect(
        host=host,
        user=user,
        passwd=password,
        db=name,
        charset="utf8mb4",
        use_unicode=True,
        autocommit=False,
        cursorclass=DB_DRIVER.cursors.DictCursor,
    )


def fetchall(conn, sql: str, params: Sequence[Any] = ()) -> List[Dict[str, Any]]:
    with conn.cursor() as cur:
        cur.execute(sql, params)
        rows = cur.fetchall()
        if isinstance(rows, tuple):
            rows = list(rows)
        return list(rows)


def fetchone(conn, sql: str, params: Sequence[Any] = ()) -> Optional[Dict[str, Any]]:
    rows = fetchall(conn, sql, params)
    return rows[0] if rows else None


def execute(conn, sql: str, params: Sequence[Any] = ()) -> int:
    with conn.cursor() as cur:
        return cur.execute(sql, params)


def now_str() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S")


def quote_ident(name: str) -> str:
    if not re.match(r"^[A-Za-z0-9_]+$", name):
        raise ValueError(f"Unsafe identifier: {name}")
    return f"`{name}`"


def infer_prefix(table_names: Iterable[str]) -> str:
    endings = [
        "faq",
        "faq_category",
        "faq_topic",
        "help_topic",
        "config",
        "ticket",
    ]
    counts: Dict[str, int] = {}
    for table in table_names:
        for ending in endings:
            if table.endswith(ending):
                prefix = table[: -len(ending)]
                counts[prefix] = counts.get(prefix, 0) + 1
    if not counts:
        return ""
    return sorted(counts.items(), key=lambda x: (-x[1], len(x[0])))[0][0]


def get_table_names(conn, db_name: str) -> List[str]:
    rows = fetchall(
        conn,
        """
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema=%s
        ORDER BY table_name
        """,
        (db_name,),
    )
    return [r["table_name"] for r in rows]


def get_table_meta(conn, db_name: str, table: str) -> TableMeta:
    col_rows = fetchall(
        conn,
        """
        SELECT column_name, data_type, column_type, is_nullable, column_default, extra
        FROM information_schema.columns
        WHERE table_schema=%s AND table_name=%s
        ORDER BY ordinal_position
        """,
        (db_name, table),
    )
    columns = [
        ColumnMeta(
            name=r["column_name"],
            data_type=(r["data_type"] or "").lower(),
            column_type=(r["column_type"] or "").lower(),
            is_nullable=(r["is_nullable"] == "YES"),
            default=r["column_default"],
            extra=(r["extra"] or "").lower(),
        )
        for r in col_rows
    ]

    key_rows = fetchall(
        conn,
        """
        SELECT tc.constraint_type, tc.constraint_name, kcu.column_name, kcu.ordinal_position
        FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu
          ON tc.constraint_name=kcu.constraint_name
         AND tc.table_schema=kcu.table_schema
         AND tc.table_name=kcu.table_name
        WHERE tc.table_schema=%s
          AND tc.table_name=%s
          AND tc.constraint_type IN ('PRIMARY KEY', 'UNIQUE')
        ORDER BY tc.constraint_name, kcu.ordinal_position
        """,
        (db_name, table),
    )

    grouped: Dict[str, Tuple[str, List[str]]] = {}
    for row in key_rows:
        ctype = row["constraint_type"]
        cname = row["constraint_name"]
        grouped.setdefault(cname, (ctype, []))[1].append(row["column_name"])

    pk: List[str] = []
    unique_keys: List[List[str]] = []
    for _name, (ctype, cols) in grouped.items():
        if ctype == "PRIMARY KEY":
            pk = cols
        elif ctype == "UNIQUE":
            unique_keys.append(cols)

    return TableMeta(name=table, columns=columns, pk=pk, unique_keys=unique_keys)


def first_existing(columns: Iterable[str], candidates: Sequence[str]) -> Optional[str]:
    colset = set(columns)
    for cand in candidates:
        if cand in colset:
            return cand
    return None


def find_flag_column(columns: Iterable[str]) -> Optional[str]:
    candidates = [
        "ispublic",
        "is_public",
        "ispublished",
        "is_published",
        "published",
        "visibility",
        "listing_type",
    ]
    col = first_existing(columns, candidates)
    if col:
        return col
    for name in columns:
        lname = name.lower()
        if "public" in lname or "publish" in lname or "visible" in lname:
            return name
    return None


def discover_schema(conn, db_name: str, configured_prefix: Optional[str]) -> SchemaDiscovery:
    table_names = get_table_names(conn, db_name)
    prefix = configured_prefix or infer_prefix(table_names)

    if not prefix:
        LOG.warning("Could not infer table prefix. Using empty prefix fallback.")

    all_meta = {t: get_table_meta(conn, db_name, t) for t in table_names}

    def candidate_tables() -> List[str]:
        if prefix:
            prefixed = [t for t in table_names if t.startswith(prefix)]
            if prefixed:
                return prefixed
        return table_names

    pool = candidate_tables()

    def score_faq(meta: TableMeta) -> int:
        cols = set(meta.colnames)
        score = 0
        if "question" in cols:
            score += 3
        if "answer" in cols:
            score += 3
        if "faq_id" in cols:
            score += 2
        if "category_id" in cols:
            score += 1
        if "ispublished" in cols or "published" in cols:
            score += 1
        if "faq" in meta.name:
            score += 1
        return score

    def score_category(meta: TableMeta) -> int:
        cols = set(meta.colnames)
        score = 0
        if "name" in cols:
            score += 3
        if "category_id" in cols:
            score += 2
        if find_flag_column(cols):
            score += 1
        if "category" in meta.name:
            score += 2
        if "faq" in meta.name:
            score += 1
        return score

    faq_candidates = sorted(
        [all_meta[t] for t in pool if score_faq(all_meta[t]) >= 6],
        key=lambda m: (-score_faq(m), m.name),
    )
    if not faq_candidates:
        raise RuntimeError("Could not identify FAQ table via discovery.")
    faq_table = faq_candidates[0]

    cat_candidates = sorted(
        [all_meta[t] for t in pool if score_category(all_meta[t]) >= 5],
        key=lambda m: (-score_category(m), m.name),
    )
    if not cat_candidates:
        raise RuntimeError("Could not identify FAQ category table via discovery.")
    category_table = cat_candidates[0]

    faq_topic_table = None
    for t in pool:
        cols = set(all_meta[t].colnames)
        if "faq_id" in cols and "topic_id" in cols:
            faq_topic_table = all_meta[t]
            break

    def score_help_topic(meta: TableMeta) -> int:
        cols = set(meta.colnames)
        if "topic_id" not in cols:
            return -999
        if not ("topic" in cols or "name" in cols or "topic_name" in cols):
            return -999
        score = 0
        lname = meta.name.lower()
        if "help_topic" in lname:
            score += 10
        elif lname.endswith("topic"):
            score += 4
        elif "topic" in lname:
            score += 2
        if "topic_pid" in cols:
            score += 2
        if "ispublic" in cols:
            score += 1
        if "email" in lname:
            score -= 6
        return score

    help_topic_candidates = sorted(
        [all_meta[t] for t in pool if score_help_topic(all_meta[t]) > 0],
        key=lambda m: (-score_help_topic(m), m.name),
    )
    help_topic_table = help_topic_candidates[0] if help_topic_candidates else None

    config_tables: List[TableMeta] = []
    for t in pool:
        cols = set(all_meta[t].colnames)
        key_col = first_existing(cols, ("key", "setting_key", "config_key", "name"))
        value_col = first_existing(cols, ("value", "setting_value", "config_value", "val"))
        if key_col and value_col:
            config_tables.append(all_meta[t])

    LOG.info("Discovered FAQ table: %s", faq_table.name)
    LOG.info("Discovered Category table: %s", category_table.name)
    if faq_topic_table:
        LOG.info("Discovered FAQ->Topic mapping table: %s", faq_topic_table.name)
    else:
        LOG.warning("No FAQ->Topic mapping table discovered.")
    if help_topic_table:
        LOG.info("Discovered Help Topic table: %s", help_topic_table.name)
    else:
        LOG.warning("No Help Topic table discovered.")

    return SchemaDiscovery(
        prefix=prefix,
        faq_table=faq_table,
        category_table=category_table,
        faq_topic_table=faq_topic_table,
        help_topic_table=help_topic_table,
        config_tables=config_tables,
    )


def default_value_for_column(col: ColumnMeta) -> Any:
    ctype = col.column_type
    if "datetime" in ctype or ctype.startswith("timestamp") or ctype.startswith("date"):
        return now_str()
    if any(t in ctype for t in ("tinyint", "smallint", "mediumint", "int", "bigint")):
        return 0
    if any(t in ctype for t in ("decimal", "float", "double", "real")):
        return 0
    if "char" in ctype or "text" in ctype or "enum" in ctype or "set" in ctype:
        return ""
    if "blob" in ctype or "binary" in ctype:
        return b""
    return ""


def normalize_visibility(value: str) -> int:
    return 1 if (value or "").strip().lower() == "public" else 0


def build_insert_values(meta: TableMeta, explicit: Dict[str, Any]) -> Dict[str, Any]:
    values = dict(explicit)
    for col in meta.columns:
        if col.name in values:
            continue
        if "auto_increment" in col.extra:
            continue
        if col.default is not None:
            continue
        if col.is_nullable:
            continue
        values[col.name] = default_value_for_column(col)
    return values


def insert_row(conn, table: TableMeta, values: Dict[str, Any]) -> int:
    cols = [c for c in table.colnames if c in values]
    placeholders = ", ".join(["%s"] * len(cols))
    sql = (
        f"INSERT INTO {quote_ident(table.name)} "
        f"({', '.join(quote_ident(c) for c in cols)}) "
        f"VALUES ({placeholders})"
    )
    params = [values[c] for c in cols]
    with conn.cursor() as cur:
        cur.execute(sql, params)
        return int(cur.lastrowid or 0)


def update_row_by_pk(conn, table: TableMeta, pk_values: Dict[str, Any], updates: Dict[str, Any]) -> int:
    cols = [c for c in updates.keys() if c in table.colnames and c not in table.pk]
    if not cols:
        return 0
    set_clause = ", ".join([f"{quote_ident(c)}=%s" for c in cols])
    where_clause = " AND ".join([f"{quote_ident(c)}=%s" for c in table.pk])
    sql = f"UPDATE {quote_ident(table.name)} SET {set_clause} WHERE {where_clause}"
    params = [updates[c] for c in cols] + [pk_values[c] for c in table.pk]
    return execute(conn, sql, params)


def select_one_by_columns(conn, table: TableMeta, values: Dict[str, Any]) -> Optional[Dict[str, Any]]:
    if not values:
        return None
    cols = [c for c in values.keys() if c in table.colnames]
    where_clause = " AND ".join([f"{quote_ident(c)}=%s" for c in cols])
    sql = f"SELECT * FROM {quote_ident(table.name)} WHERE {where_clause} LIMIT 1"
    params = [values[c] for c in cols]
    return fetchone(conn, sql, params)


def ensure_kb_enabled_best_effort(conn, discovery: SchemaDiscovery, summary: Summary, apply: bool) -> None:
    best: Optional[Tuple[int, TableMeta, Dict[str, Any], str, str]] = None

    for table in discovery.config_tables:
        cols = set(table.colnames)
        key_col = first_existing(cols, ("key", "setting_key", "config_key", "name"))
        val_col = first_existing(cols, ("value", "setting_value", "config_value", "val"))
        ns_col = first_existing(cols, ("namespace", "section", "group"))
        if not key_col or not val_col:
            continue

        sql = f"SELECT * FROM {quote_ident(table.name)} LIMIT 1000"
        for row in fetchall(conn, sql):
            key = str(row.get(key_col, "")).lower()
            namespace = str(row.get(ns_col, "")).lower() if ns_col else ""
            target = f"{namespace}.{key}"

            score = 0
            if key == "enable_kb":
                score += 100
            if "kb" in key and "enable" in key:
                score += 60
            if "knowledge" in key and "enable" in key:
                score += 50
            if "faq" in key and "enable" in key:
                score += 40
            if "kb" in namespace and "core" in namespace:
                score += 20
            if key in ("knowledgebase", "client_kb"):
                score += 30

            if score <= 0:
                continue

            if not best or score > best[0]:
                best = (score, table, row, key_col, val_col)

    if not best:
        summary.warnings += 1
        LOG.warning("No matching KB enable setting key found. Continuing.")
        return

    _score, table, row, _key_col, val_col = best
    current_val = str(row.get(val_col, "")).strip().lower()
    if current_val in ("1", "true", "yes", "on"):
        LOG.info("KB setting already enabled in %s.", table.name)
        return

    if not table.pk:
        summary.warnings += 1
        LOG.warning("Config row discovered but no PK in %s. Skipping update.", table.name)
        return

    pk_values = {k: row[k] for k in table.pk}
    if apply:
        update_row_by_pk(conn, table, pk_values, {val_col: "1"})
    summary.config_updates += 1
    LOG.info("KB setting enabled in %s (%s=1).", table.name, val_col)


def upsert_category(
    conn,
    table: TableMeta,
    category_name: str,
    visibility_flag: int,
    summary: Summary,
    apply: bool,
) -> int:
    cols = set(table.colnames)
    id_col = first_existing(cols, ("category_id", "id")) or (table.pk[0] if table.pk else None)
    name_col = first_existing(cols, ("name", "category", "title"))
    if not id_col or not name_col:
        raise RuntimeError(f"Category table {table.name} missing id/name columns.")

    desc_col = first_existing(cols, ("description", "desc", "notes"))
    public_col = find_flag_column(cols)
    created_col = first_existing(cols, ("created", "created_at"))
    updated_col = first_existing(cols, ("updated", "updated_at"))
    parent_col = first_existing(cols, ("category_pid", "parent_id", "pid"))

    existing = select_one_by_columns(conn, table, {name_col: category_name})
    if existing:
        updates: Dict[str, Any] = {}
        if desc_col:
            updates[desc_col] = f"Demo category for {category_name}"
        if public_col:
            updates[public_col] = visibility_flag
        if updated_col:
            updates[updated_col] = now_str()

        changed = 0
        if apply and updates:
            changed = update_row_by_pk(conn, table, {k: existing[k] for k in table.pk}, updates)
        if updates and (changed or not apply):
            summary.categories_updated += 1
        else:
            summary.categories_skipped += 1
        return int(existing[id_col])

    explicit: Dict[str, Any] = {
        name_col: category_name,
    }
    if desc_col:
        explicit[desc_col] = f"Demo category for {category_name}"
    if public_col:
        explicit[public_col] = visibility_flag
    if parent_col:
        explicit[parent_col] = 0
    if created_col:
        explicit[created_col] = now_str()
    if updated_col:
        explicit[updated_col] = now_str()

    values = build_insert_values(table, explicit)
    if apply:
        new_id = insert_row(conn, table, values)
    else:
        new_id = 0
    summary.categories_created += 1

    if new_id:
        return new_id
    row = select_one_by_columns(conn, table, {name_col: category_name})
    if row:
        return int(row[id_col])
    raise RuntimeError(f"Failed to resolve category id for {category_name}")


def ensure_help_topic(
    conn,
    table: Optional[TableMeta],
    topic_name: str,
    summary: Summary,
    apply: bool,
) -> Optional[int]:
    if not table or not topic_name:
        return None

    cols = set(table.colnames)
    id_col = first_existing(cols, ("topic_id", "id")) or (table.pk[0] if table.pk else None)
    topic_col = first_existing(cols, ("topic", "topic_name", "name", "title"))
    if not id_col or not topic_col:
        return None

    public_col = find_flag_column(cols)
    created_col = first_existing(cols, ("created", "created_at"))
    updated_col = first_existing(cols, ("updated", "updated_at"))
    parent_col = first_existing(cols, ("topic_pid", "parent_id", "pid"))

    existing = select_one_by_columns(conn, table, {topic_col: topic_name})
    if existing:
        updates: Dict[str, Any] = {}
        if public_col:
            updates[public_col] = 1
        if updated_col:
            updates[updated_col] = now_str()
        changed = 0
        if apply and updates:
            changed = update_row_by_pk(conn, table, {k: existing[k] for k in table.pk}, updates)
        if updates and (changed or not apply):
            summary.topics_updated += 1
        else:
            summary.topics_skipped += 1
        return int(existing[id_col])

    explicit: Dict[str, Any] = {topic_col: topic_name}
    if public_col:
        explicit[public_col] = 1
    if parent_col:
        explicit[parent_col] = 0
    if created_col:
        explicit[created_col] = now_str()
    if updated_col:
        explicit[updated_col] = now_str()

    values = build_insert_values(table, explicit)
    if apply:
        topic_id = insert_row(conn, table, values)
    else:
        topic_id = 0
    summary.topics_created += 1

    if topic_id:
        return topic_id
    row = select_one_by_columns(conn, table, {topic_col: topic_name})
    if row:
        return int(row[id_col])
    return None


def choose_faq_unique_lookup(table: TableMeta, question_col: str, category_col: Optional[str]) -> List[str]:
    # Prefer discovered unique key that includes question.
    for uniq in table.unique_keys:
        if question_col in uniq:
            return uniq
    if category_col:
        return [question_col, category_col]
    return [question_col]


def upsert_faq(
    conn,
    table: TableMeta,
    item: Dict[str, Any],
    category_id: int,
    visibility_flag: int,
    summary: Summary,
    apply: bool,
) -> int:
    cols = set(table.colnames)
    id_col = first_existing(cols, ("faq_id", "id")) or (table.pk[0] if table.pk else None)
    question_col = first_existing(cols, ("question", "title", "subject"))
    answer_col = first_existing(cols, ("answer", "response", "body", "content"))
    if not id_col or not question_col or not answer_col:
        raise RuntimeError(f"FAQ table {table.name} missing id/question/answer columns.")

    category_col = first_existing(cols, ("category_id", "cat_id", "faq_category_id"))
    keywords_col = first_existing(cols, ("keywords", "tags", "taglist"))
    published_col = find_flag_column(cols)
    notes_col = first_existing(cols, ("notes",))
    created_col = first_existing(cols, ("created", "created_at"))
    updated_col = first_existing(cols, ("updated", "updated_at"))

    lookup_cols = choose_faq_unique_lookup(table, question_col, category_col)
    lookup_values: Dict[str, Any] = {}
    for lc in lookup_cols:
        if lc == question_col:
            lookup_values[lc] = item["question"]
        elif category_col and lc == category_col:
            lookup_values[lc] = category_id
    if question_col not in lookup_values:
        lookup_values[question_col] = item["question"]
    if category_col and category_col in lookup_cols and category_col not in lookup_values:
        lookup_values[category_col] = category_id

    existing = select_one_by_columns(conn, table, lookup_values)
    if existing:
        updates: Dict[str, Any] = {
            answer_col: item["answer_html"],
        }
        if category_col:
            updates[category_col] = category_id
        if keywords_col:
            updates[keywords_col] = item.get("keywords", "")
        if published_col:
            updates[published_col] = visibility_flag
        if notes_col:
            updates[notes_col] = "Managed by seed_osticket_kb.py"
        if updated_col:
            updates[updated_col] = now_str()

        changed = 0
        if apply:
            changed = update_row_by_pk(conn, table, {k: existing[k] for k in table.pk}, updates)
        if changed or not apply:
            summary.faqs_updated += 1
        else:
            summary.faqs_skipped += 1
        return int(existing[id_col])

    explicit: Dict[str, Any] = {
        question_col: item["question"],
        answer_col: item["answer_html"],
    }
    if category_col:
        explicit[category_col] = category_id
    if keywords_col:
        explicit[keywords_col] = item.get("keywords", "")
    if published_col:
        explicit[published_col] = visibility_flag
    if notes_col:
        explicit[notes_col] = "Managed by seed_osticket_kb.py"
    if created_col:
        explicit[created_col] = now_str()
    if updated_col:
        explicit[updated_col] = now_str()

    values = build_insert_values(table, explicit)
    if apply:
        faq_id = insert_row(conn, table, values)
    else:
        faq_id = 0
    summary.faqs_created += 1

    if faq_id:
        return faq_id
    row = select_one_by_columns(conn, table, {question_col: item["question"]})
    if row:
        return int(row[id_col])
    raise RuntimeError(f"Failed to resolve faq id for question: {item['question']}")


def upsert_faq_topic_mapping(
    conn,
    map_table: Optional[TableMeta],
    faq_id: int,
    topic_id: Optional[int],
    summary: Summary,
    apply: bool,
) -> None:
    if not map_table or not topic_id:
        summary.mappings_skipped += 1
        return

    cols = set(map_table.colnames)
    faq_col = first_existing(cols, ("faq_id",))
    topic_col = first_existing(cols, ("topic_id",))
    if not faq_col or not topic_col:
        summary.mappings_skipped += 1
        return

    existing = select_one_by_columns(conn, map_table, {faq_col: faq_id, topic_col: topic_id})
    if existing:
        summary.mappings_skipped += 1
        return

    explicit = {faq_col: faq_id, topic_col: topic_id}
    values = build_insert_values(map_table, explicit)
    if apply:
        insert_row(conn, map_table, values)
    summary.mappings_created += 1


def load_dataset(path: Path) -> List[Dict[str, Any]]:
    data = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(data, list):
        raise ValueError("Dataset root must be a JSON array.")
    required = {"category", "question", "keywords", "answer_html", "help_topic", "visibility"}
    for idx, item in enumerate(data):
        if not isinstance(item, dict):
            raise ValueError(f"Dataset item #{idx+1} is not an object.")
        missing = sorted(required - set(item.keys()))
        if missing:
            raise ValueError(f"Dataset item #{idx+1} missing fields: {', '.join(missing)}")
    return data


def run(args: argparse.Namespace) -> int:
    summary = Summary()
    root, config_path = find_osticket_root(args.root, args.config)
    config = parse_php_defines(config_path)

    db_host = config.get("DBHOST")
    db_name = config.get("DBNAME")
    db_user = config.get("DBUSER")
    db_pass = config.get("DBPASS", "")
    db_prefix = config.get("TABLE_PREFIX") or config.get("DBPREFIX")
    if not all([db_host, db_name, db_user]):
        raise RuntimeError("Missing DB credentials in osTicket config.")

    dataset_path = Path(args.dataset).expanduser().resolve()
    if not dataset_path.is_file():
        raise FileNotFoundError(f"Dataset not found: {dataset_path}")
    dataset = load_dataset(dataset_path)

    LOG.info("osTicket root: %s", root)
    LOG.info("Config file: %s", config_path)
    LOG.info("Dataset: %s (%d entries)", dataset_path, len(dataset))
    LOG.info(
        "DB connection: host=%s db=%s user=%s prefix=%s driver=%s",
        db_host,
        db_name,
        db_user,
        db_prefix or "(discover)",
        DB_DRIVER_NAME,
    )
    LOG.info("Mode: %s", "APPLY" if args.apply else "DRY-RUN")

    conn = db_connect(db_host, db_name, db_user, db_pass)
    try:
        discovery = discover_schema(conn, db_name, db_prefix)
        if not db_prefix:
            db_prefix = discovery.prefix
            LOG.info("Detected table prefix: %s", db_prefix or "(empty)")

        ensure_kb_enabled_best_effort(conn, discovery, summary, args.apply)

        for item in dataset:
            visibility_flag = normalize_visibility(item.get("visibility", "public"))
            category_id = upsert_category(
                conn,
                discovery.category_table,
                item["category"],
                visibility_flag,
                summary,
                args.apply,
            )
            topic_id = ensure_help_topic(
                conn,
                discovery.help_topic_table,
                item.get("help_topic", ""),
                summary,
                args.apply,
            )
            faq_id = upsert_faq(
                conn,
                discovery.faq_table,
                item,
                category_id,
                visibility_flag,
                summary,
                args.apply,
            )
            upsert_faq_topic_mapping(
                conn,
                discovery.faq_topic_table,
                faq_id,
                topic_id,
                summary,
                args.apply,
            )

        if args.apply:
            conn.commit()
            LOG.info("Transaction committed.")
        else:
            conn.rollback()
            LOG.info("Dry-run complete. Transaction rolled back.")

    except Exception as exc:
        summary.errors += 1
        conn.rollback()
        LOG.error("Seeder failed: %s", exc)
        raise
    finally:
        conn.close()

    LOG.info("Summary: %s", json.dumps(summary.as_dict(), ensure_ascii=False))
    return 0


def main() -> int:
    args = parse_args()
    setup_logging(args.log_level)
    try:
        return run(args)
    except Exception as exc:
        LOG.error("Fatal error: %s", exc)
        return 1


if __name__ == "__main__":
    sys.exit(main())
