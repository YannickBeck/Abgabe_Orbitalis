<?php
/**
 * AI Reply Assistant Plugin for osTicket 1.18.x
 *
 * Automatically generates draft reply suggestions for incoming support tickets
 * using OpenAI Chat Completions API. Drafts are posted as Internal Notes for
 * agent review — never sent directly to customers.
 *
 * Developed by BS Computer (https://bscomputer.com)
 * and BSC IT Solutions (https://bscsolutions.rs)
 *
 * @package    AiReplyAssistant
 * @version    1.0.4
 * @author     Sasa Bajic - BS Computer / BSC IT Solutions
 * @link       https://bscomputer.com
 * @link       https://bscsolutions.rs
 * @license    GPL-2.0-or-later
 * @copyright  2026 BS Computer / BSC IT Solutions
 */

return array(
    'id'          => 'ai-reply-assistant',
    'version'     => '2.0.0',
    'name'        => 'AI Reply Assistant',
    'author'      => 'Sasa Bajic - BS Computer / BSC IT Solutions | Erweitert von Team Orbitalis',
    'description' => 'Generates AI-powered draft replies as internal notes using a local LLM (Ollama). '
                   . 'Original plugin by BS Computer (bscomputer.com) & BSC IT Solutions (bscsolutions.rs). '
                   . 'Erweitert und ausgebaut von Team Orbitalis: '
                   . 'RAG-Integration (semantische Wissenssuche über lokalen Vektor-Index), '
                   . 'KB-Seeder (automatische Befüllung der Wissensdatenbank), '
                   . 'PII-Redaktion, Rate-Limiting, strukturiertes Logging, '
                   . 'JSON-Antwortformat mit source_urls, suggested_tags und confidence-Score, '
                   . 'vollautomatisches Installations-Skript für Debian 13.',
    'url'         => 'https://github.com/YannickBeck/Abgabe_Orbitalis',
    'plugin'      => 'class.AiReplyPlugin.php:AiReplyPlugin',
);
