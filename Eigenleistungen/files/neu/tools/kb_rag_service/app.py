#!/usr/bin/env python3
"""
Local KB RAG service for osTicket.

- Reads FAQs/categories/topics directly from osTicket MySQL
- Builds a LlamaIndex VectorStoreIndex with Ollama embeddings
- Exposes HTTP API for plugin retrieval
"""

from __future__ import annotations

import logging
import os
import re
import threading
import time
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, List, Optional, Sequence, Tuple

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field

from llama_index.core import Document, VectorStoreIndex
from llama_index.core.schema import TextNode
from llama_index.embeddings.ollama import OllamaEmbedding


LOG = logging.getLogger("osticket-kb-rag")
logging.basicConfig(level=logging.INFO, format="[%(asctime)s] %(levelname)s %(message)s")


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
        "No MySQL driver found. Install PyMySQL (`pip install pymysql`) "
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

    @property
    def colnames(self) -> List[str]:
        return [c.name for c in self.columns]


@dataclass
class Layout:
    prefix: str
    faq: TableMeta
    category: Optional[TableMeta]
    faq_topic: Optional[TableMeta]
    help_topic: Optional[TableMeta]
    faq_id_col: str
    faq_question_col: str
    faq_answer_col: str
    faq_keywords_col: Optional[str]
    faq_category_id_col: Optional[str]
    faq_updated_col: Optional[str]
    cat_id_col: Optional[str]
    cat_name_col: Optional[str]
    cat_public_col: Optional[str]
    cat_updated_col: Optional[str]
    map_faq_col: Optional[str]
    map_topic_col: Optional[str]
    topic_id_col: Optional[str]
    topic_name_col: Optional[str]
    topic_updated_col: Optional[str]


class QueryRequest(BaseModel):
    subject: str = ""
    latest_message: str = ""
    top_k: Optional[int] = Field(default=None, ge=1, le=50)


class QueryResult(BaseModel):
    faq_id: int
    category_id: Optional[int] = None
    source_type: Optional[str] = None
    question: str
    answer_snippet: str
    score: float
    category: Optional[str] = None
    topic: Optional[str] = None
    category_url: Optional[str] = None
    faq_url: Optional[str] = None
    reference_url: Optional[str] = None


class QueryResponse(BaseModel):
    results: List[QueryResult]


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
            val = raw[1:-1].replace(r"\'", "'").replace(r"\"", '"').replace(r"\\", "\\")
            values[key] = val
        else:
            values[key] = raw
    return values


def find_osticket_config() -> Path:
    explicit = os.getenv("OSTICKET_CONFIG")
    if explicit:
        cfg = Path(explicit).expanduser().resolve()
        if cfg.is_file():
            return cfg
        raise FileNotFoundError(f"OSTICKET_CONFIG not found: {cfg}")

    root = Path(os.getenv("OSTICKET_ROOT", "/var/www/osticket")).expanduser().resolve()
    for rel in ("include/ost-config.php", "include/settings.php"):
        candidate = root / rel
        if candidate.is_file():
            return candidate
    raise FileNotFoundError(
        f"Could not find osTicket config under {root}. Set OSTICKET_CONFIG or OSTICKET_ROOT."
    )


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


def first_existing(columns: Sequence[str], candidates: Sequence[str]) -> Optional[str]:
    colset = set(columns)
    for cand in candidates:
        if cand in colset:
            return cand
    return None


def find_flag_column(columns: Sequence[str]) -> Optional[str]:
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


def infer_prefix(table_names: Sequence[str]) -> str:
    endings = ["faq", "faq_category", "faq_topic", "help_topic", "config", "ticket"]
    counts: Dict[str, int] = {}
    for table in table_names:
        for ending in endings:
            if table.endswith(ending):
                prefix = table[: -len(ending)]
                counts[prefix] = counts.get(prefix, 0) + 1
    if not counts:
        return ""
    return sorted(counts.items(), key=lambda x: (-x[1], len(x[0])))[0][0]


def get_table_meta(conn, db_name: str, table_name: str) -> TableMeta:
    col_rows = fetchall(
        conn,
        """
        SELECT column_name, data_type, column_type, is_nullable, column_default, extra
        FROM information_schema.columns
        WHERE table_schema=%s AND table_name=%s
        ORDER BY ordinal_position
        """,
        (db_name, table_name),
    )
    columns = [
        ColumnMeta(
            name=row["column_name"],
            data_type=(row["data_type"] or "").lower(),
            column_type=(row["column_type"] or "").lower(),
            is_nullable=(row["is_nullable"] == "YES"),
            default=row["column_default"],
            extra=(row["extra"] or "").lower(),
        )
        for row in col_rows
    ]
    pk_rows = fetchall(
        conn,
        """
        SELECT kcu.column_name
        FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu
          ON tc.constraint_name=kcu.constraint_name
         AND tc.table_schema=kcu.table_schema
         AND tc.table_name=kcu.table_name
        WHERE tc.table_schema=%s
          AND tc.table_name=%s
          AND tc.constraint_type='PRIMARY KEY'
        ORDER BY kcu.ordinal_position
        """,
        (db_name, table_name),
    )
    return TableMeta(name=table_name, columns=columns, pk=[r["column_name"] for r in pk_rows])


def discover_layout(conn, db_name: str, configured_prefix: Optional[str]) -> Layout:
    table_rows = fetchall(
        conn,
        """
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema=%s
        ORDER BY table_name
        """,
        (db_name,),
    )
    table_names = [r["table_name"] for r in table_rows]
    prefix = configured_prefix or infer_prefix(table_names)
    pool = [t for t in table_names if t.startswith(prefix)] if prefix else table_names
    if not pool:
        pool = table_names

    metas = {t: get_table_meta(conn, db_name, t) for t in pool}

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
        if "faq" in meta.name:
            score += 1
        return score

    faq_candidates = sorted(
        [m for m in metas.values() if score_faq(m) >= 6],
        key=lambda m: (-score_faq(m), m.name),
    )
    if not faq_candidates:
        raise RuntimeError("Could not discover FAQ table.")
    faq = faq_candidates[0]

    category = None
    for m in metas.values():
        cols = set(m.colnames)
        if "name" in cols and "category_id" in cols and "category" in m.name:
            category = m
            break

    faq_topic = None
    for m in metas.values():
        cols = set(m.colnames)
        if "faq_id" in cols and "topic_id" in cols:
            faq_topic = m
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
        [m for m in metas.values() if score_help_topic(m) > 0],
        key=lambda m: (-score_help_topic(m), m.name),
    )
    help_topic = help_topic_candidates[0] if help_topic_candidates else None

    faq_id_col = first_existing(faq.colnames, ("faq_id", "id")) or (faq.pk[0] if faq.pk else "")
    faq_question_col = first_existing(faq.colnames, ("question", "title", "subject")) or ""
    faq_answer_col = first_existing(faq.colnames, ("answer", "response", "body", "content")) or ""
    if not faq_id_col or not faq_question_col or not faq_answer_col:
        raise RuntimeError("FAQ layout discovery missing id/question/answer columns.")

    faq_keywords_col = first_existing(faq.colnames, ("keywords", "tags", "taglist"))
    faq_category_id_col = first_existing(faq.colnames, ("category_id", "cat_id"))
    faq_updated_col = first_existing(faq.colnames, ("updated", "updated_at"))

    cat_id_col = first_existing(category.colnames, ("category_id", "id")) if category else None
    cat_name_col = first_existing(category.colnames, ("name", "title")) if category else None
    cat_public_col = find_flag_column(category.colnames) if category else None
    cat_updated_col = first_existing(category.colnames, ("updated", "updated_at")) if category else None

    map_faq_col = first_existing(faq_topic.colnames, ("faq_id",)) if faq_topic else None
    map_topic_col = first_existing(faq_topic.colnames, ("topic_id",)) if faq_topic else None

    topic_id_col = first_existing(help_topic.colnames, ("topic_id", "id")) if help_topic else None
    topic_name_col = (
        first_existing(help_topic.colnames, ("topic", "topic_name", "name", "title"))
        if help_topic
        else None
    )
    topic_updated_col = (
        first_existing(help_topic.colnames, ("updated", "updated_at")) if help_topic else None
    )

    return Layout(
        prefix=prefix,
        faq=faq,
        category=category,
        faq_topic=faq_topic,
        help_topic=help_topic,
        faq_id_col=faq_id_col,
        faq_question_col=faq_question_col,
        faq_answer_col=faq_answer_col,
        faq_keywords_col=faq_keywords_col,
        faq_category_id_col=faq_category_id_col,
        faq_updated_col=faq_updated_col,
        cat_id_col=cat_id_col,
        cat_name_col=cat_name_col,
        cat_public_col=cat_public_col,
        cat_updated_col=cat_updated_col,
        map_faq_col=map_faq_col,
        map_topic_col=map_topic_col,
        topic_id_col=topic_id_col,
        topic_name_col=topic_name_col,
        topic_updated_col=topic_updated_col,
    )


class KBIndexManager:
    def __init__(self) -> None:
        self.lock = threading.RLock()
        self.rebuild_lock = threading.Lock()
        self.index: Optional[VectorStoreIndex] = None
        self.layout: Optional[Layout] = None
        self.last_signature: Optional[str] = None
        self.last_build_at: Optional[str] = None
        self.last_error: Optional[str] = None
        self.doc_count: int = 0
        self.initial_build_complete: bool = False
        self.stop_event = threading.Event()
        self.refresh_thread: Optional[threading.Thread] = None

        self.config_path = find_osticket_config()
        cfg = parse_php_defines(self.config_path)
        self.db_host = cfg.get("DBHOST") or "localhost"
        self.db_name = cfg.get("DBNAME") or ""
        self.db_user = cfg.get("DBUSER") or ""
        self.db_pass = cfg.get("DBPASS", "")
        self.db_prefix = cfg.get("TABLE_PREFIX") or cfg.get("DBPREFIX") or ""
        if not all([self.db_name, self.db_user]):
            raise RuntimeError("Missing DB credentials in osTicket config.")

        self.ollama_base_url = os.getenv("OLLAMA_BASE_URL", "http://127.0.0.1:11434")
        self.embed_model_name = os.getenv("OLLAMA_EMBED_MODEL", "embeddinggemma:latest")
        self.max_embed_chars = max(500, int(os.getenv("RAG_MAX_EMBED_CHARS", "2400")))
        self.min_category_guidance_chars = max(
            10, int(os.getenv("RAG_MIN_CATEGORY_GUIDANCE_CHARS", "20"))
        )
        self.embed_batch_size = max(1, min(32, int(os.getenv("RAG_EMBED_BATCH_SIZE", "4"))))
        self.embed_timeout_seconds = max(
            10,
            min(600, int(os.getenv("RAG_EMBED_TIMEOUT_SECONDS", "120"))),
        )
        base_url = os.getenv("OSTICKET_BASE_URL", "").strip()
        self.osticket_base_url = base_url.rstrip("/") if base_url else ""
        self.refresh_seconds = int(os.getenv("RAG_REFRESH_SECONDS", "300"))
        self.default_top_k = int(os.getenv("RAG_DEFAULT_TOP_K", "5"))
        self.max_top_k = int(os.getenv("RAG_MAX_TOP_K", "8"))

        # LlamaIndex embedding backend
        self.embed_model = OllamaEmbedding(
            model_name=self.embed_model_name,
            base_url=self.ollama_base_url,
            embed_batch_size=self.embed_batch_size,
            client_kwargs={"timeout": self.embed_timeout_seconds},
        )

    def _db(self):
        return db_connect(self.db_host, self.db_name, self.db_user, self.db_pass)

    def _table_signature(self, conn, table: TableMeta, updated_col: Optional[str]) -> str:
        if updated_col and updated_col in table.colnames:
            row = fetchone(
                conn,
                f"SELECT COUNT(*) AS c, MAX(`{updated_col}`) AS m FROM `{table.name}`",
            )
            return f"{table.name}:{row['c']}:{row['m']}"

        pk_col = table.pk[0] if table.pk else None
        if pk_col:
            row = fetchone(
                conn,
                f"SELECT COUNT(*) AS c, MAX(`{pk_col}`) AS m FROM `{table.name}`",
            )
            return f"{table.name}:{row['c']}:{row['m']}"

        row = fetchone(conn, f"SELECT COUNT(*) AS c FROM `{table.name}`")
        return f"{table.name}:{row['c']}"

    def compute_signature(self, conn, layout: Layout) -> str:
        parts = [
            self._table_signature(conn, layout.faq, layout.faq_updated_col),
        ]
        if layout.category:
            parts.append(self._table_signature(conn, layout.category, layout.cat_updated_col))
        if layout.help_topic:
            parts.append(self._table_signature(conn, layout.help_topic, layout.topic_updated_col))
        if layout.faq_topic:
            parts.append(self._table_signature(conn, layout.faq_topic, None))
        return "|".join(parts)

    def _staff_link(self, path: str) -> str:
        if self.osticket_base_url:
            return f"{self.osticket_base_url}{path}"
        return path

    def _normalize_for_embedding(self, value: str) -> str:
        text = re.sub(r"<[^>]+>", " ", value or "")
        text = re.sub(r"\s+", " ", text).strip()
        if len(text) > self.max_embed_chars:
            text = text[: self.max_embed_chars] + " ... (truncated)"
        return text

    def _build_category_guidance(self, row: Dict[str, Any], desc_col: Optional[str], notes_col: Optional[str]) -> str:
        parts: List[str] = []
        if desc_col:
            desc = self._normalize_for_embedding(str(row.get(desc_col) or ""))
            if desc:
                parts.append(desc)
        if notes_col:
            notes = self._normalize_for_embedding(str(row.get(notes_col) or ""))
            if notes and notes not in parts:
                parts.append(notes)
        return " ".join(parts).strip()

    def fetch_documents(self, conn, layout: Layout) -> List[Document]:
        faq_cols = {
            layout.faq_id_col,
            layout.faq_question_col,
            layout.faq_answer_col,
        }
        if layout.faq_keywords_col:
            faq_cols.add(layout.faq_keywords_col)
        if layout.faq_category_id_col:
            faq_cols.add(layout.faq_category_id_col)
        faq_select = ", ".join([f"`{c}`" for c in sorted(faq_cols)])
        faq_rows = fetchall(conn, f"SELECT {faq_select} FROM `{layout.faq.name}`")

        categories: Dict[int, Dict[str, Any]] = {}
        faq_count_by_category: Dict[int, int] = {}
        cat_desc_col: Optional[str] = None
        cat_notes_col: Optional[str] = None
        if layout.category and layout.cat_id_col and layout.cat_name_col:
            cols = [layout.cat_id_col, layout.cat_name_col]
            cat_desc_col = first_existing(layout.category.colnames, ("description", "desc", "details", "body", "content"))
            cat_notes_col = first_existing(layout.category.colnames, ("notes", "note", "instructions", "guidance"))
            if layout.cat_public_col:
                cols.append(layout.cat_public_col)
            if cat_desc_col:
                cols.append(cat_desc_col)
            if cat_notes_col and cat_notes_col not in cols:
                cols.append(cat_notes_col)
            select = ", ".join([f"`{c}`" for c in cols])
            for row in fetchall(conn, f"SELECT {select} FROM `{layout.category.name}`"):
                categories[int(row[layout.cat_id_col])] = row

        topic_names: Dict[int, str] = {}
        if layout.help_topic and layout.topic_id_col and layout.topic_name_col:
            select = f"`{layout.topic_id_col}`, `{layout.topic_name_col}`"
            for row in fetchall(conn, f"SELECT {select} FROM `{layout.help_topic.name}`"):
                topic_names[int(row[layout.topic_id_col])] = str(row[layout.topic_name_col] or "")

        faq_topics: Dict[int, List[str]] = {}
        if layout.faq_topic and layout.map_faq_col and layout.map_topic_col:
            select = f"`{layout.map_faq_col}`, `{layout.map_topic_col}`"
            for row in fetchall(conn, f"SELECT {select} FROM `{layout.faq_topic.name}`"):
                faq_id = int(row[layout.map_faq_col])
                topic_id = int(row[layout.map_topic_col])
                name = topic_names.get(topic_id)
                if not name:
                    continue
                faq_topics.setdefault(faq_id, []).append(name)

        docs: List[Document] = []
        for row in faq_rows:
            faq_id = int(row[layout.faq_id_col])
            question = str(row.get(layout.faq_question_col) or "").strip()
            answer_raw = str(row.get(layout.faq_answer_col) or "").strip()
            keywords = (
                str(row.get(layout.faq_keywords_col) or "").strip() if layout.faq_keywords_col else ""
            )
            question_embed = self._normalize_for_embedding(question)
            answer_embed = self._normalize_for_embedding(answer_raw)
            if not question_embed and not answer_embed:
                continue
            category_name = None
            category_guidance = ""
            category_id = None
            visibility = None
            if layout.faq_category_id_col and row.get(layout.faq_category_id_col) is not None:
                cat_id = int(row[layout.faq_category_id_col])
                category_id = cat_id
                faq_count_by_category[cat_id] = faq_count_by_category.get(cat_id, 0) + 1
                cat = categories.get(cat_id)
                if cat and layout.cat_name_col:
                    category_name = str(cat.get(layout.cat_name_col) or "")
                    category_guidance = self._build_category_guidance(cat, cat_desc_col, cat_notes_col)
                    if layout.cat_public_col:
                        pub_val = str(cat.get(layout.cat_public_col) or "0")
                        visibility = "public" if pub_val in ("1", "true", "True") else "private"

            topics = faq_topics.get(faq_id, [])
            topic_txt = " | ".join(sorted(set(topics))) if topics else ""
            answer_snippet = answer_embed[:500]

            chunks = [
                f"Question: {question_embed}",
                f"Answer: {answer_embed}",
            ]
            if keywords:
                chunks.append(f"Keywords: {keywords}")
            if category_name:
                chunks.append(f"Category: {category_name}")
            if len(category_guidance) >= self.min_category_guidance_chars:
                chunks.append(f"CategoryGuidance: {category_guidance}")
            if visibility:
                chunks.append(f"CategoryVisibility: {visibility}")
            if topic_txt:
                chunks.append(f"Topics: {topic_txt}")

            text = "\n".join(chunks)
            category_url = (
                self._staff_link(f"/scp/categories.php?id={category_id}")
                if category_id is not None
                else ""
            )
            faq_url = self._staff_link(f"/scp/faq.php?id={faq_id}")
            reference_url = faq_url or category_url
            metadata = {
                "faq_id": faq_id,
                "category_id": category_id or 0,
                "source_type": "faq",
                "question": question,
                "answer_snippet": answer_snippet,
                "category": category_name or "",
                "category_guidance": category_guidance,
                "topic": topic_txt,
                "visibility": visibility or "",
                "category_url": category_url,
                "faq_url": faq_url,
                "reference_url": reference_url,
            }
            docs.append(Document(text=text, metadata=metadata))

        # Add standalone category guidance docs so category playbooks are retrievable
        # even when FAQ answers are sparse.
        if layout.cat_id_col and layout.cat_name_col:
            for cat_id, cat in categories.items():
                category_name = str(cat.get(layout.cat_name_col) or "").strip()
                category_guidance = self._build_category_guidance(cat, cat_desc_col, cat_notes_col)
                if len(category_guidance) < self.min_category_guidance_chars:
                    continue

                # Skip standalone category doc when category has no useful name.
                if not category_name:
                    continue

                pub_val = str(cat.get(layout.cat_public_col) or "0") if layout.cat_public_col else ""
                visibility = "public" if pub_val in ("1", "true", "True") else "private"
                category_url = self._staff_link(f"/scp/categories.php?id={cat_id}")

                chunks = [
                    f"Category: {category_name}",
                    f"CategoryGuidance: {category_guidance}",
                ]
                if visibility:
                    chunks.append(f"CategoryVisibility: {visibility}")
                chunks.append("SourceType: category")

                docs.append(
                    Document(
                        text="\n".join(chunks),
                        metadata={
                            "faq_id": 0,
                            "category_id": cat_id,
                            "source_type": "category",
                            "question": f"Category Guidance: {category_name}",
                            "answer_snippet": category_guidance[:500],
                            "category": category_name,
                            "category_guidance": category_guidance,
                            "topic": "",
                            "visibility": visibility,
                            "category_url": category_url,
                            "faq_url": "",
                            "reference_url": category_url,
                            "faq_count_in_category": faq_count_by_category.get(cat_id, 0),
                        },
                    )
                )

        return docs

    def rebuild(self, force: bool = False) -> Dict[str, Any]:
        if not self.rebuild_lock.acquire(blocking=False):
            with self.lock:
                return {
                    "rebuilt": False,
                    "reason": "rebuild_in_progress",
                    "signature": self.last_signature,
                    "doc_count": self.doc_count,
                }

        started = time.time()
        try:
            conn = self._db()
            layout = discover_layout(conn, self.db_name, self.db_prefix)
            signature = self.compute_signature(conn, layout)

            with self.lock:
                if (not force) and self.last_signature == signature and self.index is not None:
                    return {
                        "rebuilt": False,
                        "reason": "unchanged",
                        "signature": self.last_signature,
                        "doc_count": self.doc_count,
                    }

            docs = self.fetch_documents(conn, layout)
            # Use one node per FAQ document to avoid expensive automatic chunking.
            nodes = [
                TextNode(text=doc.text, metadata=(doc.metadata or {}))
                for doc in docs
            ]
            index = VectorStoreIndex(nodes, embed_model=self.embed_model)

            with self.lock:
                self.index = index
                self.layout = layout
                self.doc_count = len(docs)
                self.last_signature = signature
                self.last_build_at = datetime.now(timezone.utc).isoformat()
                self.last_error = None
                self.initial_build_complete = True

            LOG.info(
                "KB index rebuilt: docs=%d signature=%s duration=%.2fs",
                len(docs),
                signature,
                time.time() - started,
            )
            return {
                "rebuilt": True,
                "signature": signature,
                "doc_count": len(docs),
                "duration_seconds": round(time.time() - started, 3),
            }
        except Exception as exc:
            with self.lock:
                self.last_error = str(exc)
            raise
        finally:
            try:
                conn.close()
            except Exception:
                pass
            self.rebuild_lock.release()

    def query(self, subject: str, latest_message: str, top_k: Optional[int]) -> List[Dict[str, Any]]:
        with self.lock:
            if not self.index:
                return []
            effective_top_k = top_k or self.default_top_k
            effective_top_k = max(1, min(self.max_top_k, int(effective_top_k)))
            retriever = self.index.as_retriever(similarity_top_k=effective_top_k)

        query_text = f"{(subject or '').strip()}\n{(latest_message or '').strip()}".strip()
        if not query_text:
            query_text = "general support issue"

        nodes = retriever.retrieve(query_text)
        results: List[Dict[str, Any]] = []
        for n in nodes:
            md = getattr(n.node, "metadata", {}) or {}
            results.append(
                {
                    "faq_id": int(md.get("faq_id") or 0),
                    "category_id": int(md.get("category_id") or 0) or None,
                    "source_type": str(md.get("source_type") or "") or None,
                    "question": str(md.get("question") or ""),
                    "answer_snippet": str(md.get("answer_snippet") or ""),
                    "score": float(getattr(n, "score", 0.0) or 0.0),
                    "category": str(md.get("category") or "") or None,
                    "topic": str(md.get("topic") or "") or None,
                    "category_url": str(md.get("category_url") or "") or None,
                    "faq_url": str(md.get("faq_url") or "") or None,
                    "reference_url": str(md.get("reference_url") or "") or None,
                }
            )
        return results

    def start_refresh_loop(self) -> None:
        self.stop_event.clear()

        def _loop():
            while not self.stop_event.wait(self.refresh_seconds):
                try:
                    self.rebuild(force=False)
                except Exception as exc:
                    LOG.error("Periodic reindex failed: %s", exc)

        self.refresh_thread = threading.Thread(target=_loop, daemon=True, name="kb-rag-refresh")
        self.refresh_thread.start()

    def start_initial_build(self) -> None:
        def _initial_build():
            try:
                self.rebuild(force=True)
            except Exception as exc:
                LOG.error("Initial index build failed: %s", exc)

        threading.Thread(target=_initial_build, daemon=True, name="kb-rag-initial-build").start()

    def stop(self) -> None:
        self.stop_event.set()
        if self.refresh_thread and self.refresh_thread.is_alive():
            self.refresh_thread.join(timeout=2.0)

    def health(self) -> Dict[str, Any]:
        with self.lock:
            return {
                "status": (
                    "ok"
                    if self.index is not None
                    else ("error" if self.last_error else "warming_up")
                ),
                "doc_count": self.doc_count,
                "last_signature": self.last_signature,
                "last_build_at": self.last_build_at,
                "initial_build_complete": self.initial_build_complete,
                "last_error": self.last_error,
                "refresh_seconds": self.refresh_seconds,
                "embed_model": self.embed_model_name,
                "ollama_base_url": self.ollama_base_url,
                "osticket_base_url": self.osticket_base_url,
                "db_driver": DB_DRIVER_NAME,
                "config_path": str(self.config_path),
            }


app = FastAPI(title="osTicket KB RAG Service", version="1.0.0")
manager: Optional[KBIndexManager] = None


@app.on_event("startup")
def startup_event():
    global manager
    manager = KBIndexManager()
    manager.start_refresh_loop()
    manager.start_initial_build()
    LOG.info("KB RAG service started.")


@app.on_event("shutdown")
def shutdown_event():
    if manager:
        manager.stop()
    LOG.info("KB RAG service stopped.")


@app.get("/health")
def health():
    if not manager:
        return {"status": "starting"}
    return manager.health()


@app.post("/reindex")
def reindex():
    if not manager:
        raise HTTPException(status_code=503, detail="Service not initialized")
    try:
        return manager.rebuild(force=True)
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc))


@app.post("/query", response_model=QueryResponse)
def query(req: QueryRequest):
    if not manager:
        raise HTTPException(status_code=503, detail="Service not initialized")
    try:
        items = manager.query(req.subject, req.latest_message, req.top_k)
        return {"results": items}
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc))
