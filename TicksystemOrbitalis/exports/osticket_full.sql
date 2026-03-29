/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.3-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: osticket
-- ------------------------------------------------------
-- Server version	11.8.3-MariaDB-0+deb13u1 from Debian

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `ost__search`
--

DROP TABLE IF EXISTS `ost__search`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost__search` (
  `object_type` varchar(8) NOT NULL,
  `object_id` int(11) unsigned NOT NULL,
  `title` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`object_type`,`object_id`),
  FULLTEXT KEY `search` (`title`,`content`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost__search`
--

LOCK TABLES `ost__search` WRITE;
/*!40000 ALTER TABLE `ost__search` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost__search` VALUES
('H',1,'osTicket Installed!','Thank you for choosing osTicket. Please make sure you join the osTicket forums and our mailing list to stay up to date on the latest news, security alerts and updates. The osTicket forums are also a great place to get assistance, guidance, tips, and help from other osTicket users. In addition to the forums, the osTicket Docs provides a useful collection of educational materials, documentation, and notes from the community. We welcome your contributions to the osTicket community. If you are looking for a greater level of support, we provide professional services and commercial support with guaranteed response times, and access to the core development team. We can also help customize osTicket or even add new features to the system to meet your unique needs. If the idea of managing and upgrading this osTicket installation is daunting, you can try osTicket as a hosted service at https://supportsystem.com/ -- no installation required and we can import your data! With SupportSystem\'s turnkey infrastructure, you get osTicket at its best, leaving you free to focus on your customers without the burden of making sure the application is stable, maintained, and secure. Cheers, - osTicket Team - https://osticket.com/ PS. Don\'t just make customers happy, make happy customers!'),
('H',2,'','Can\'t login'),
('H',3,'','ES GEHT NICHT'),
('H',4,'','osTicket is a widely-used open source support ticket system, an attractive alternative to higher-cost and complex customer support systems - simple, lightweight, reliable, open source, web-based and easy to setup and use.'),
('H',9,'','Ich habe beim Login eine Fehlermeldung. Mein SSO funktioniert nicht. Hilfe ASAP'),
('H',14,'','BILDTEST-MULTIMODAL-4711 Bitte analysiere den angehÃ¤ngten Screenshot und antworte NUR basierend auf dem, was im Bild steht. Wichtig: 1) Nenne exakt den sichtbaren Fehlertext aus dem Screenshot. 2) Nenne 2 konkrete nÃ¤chste Schritte zur Behebung. 3) FÃ¼ge am Ende den Satz hinzu: \"Bildanalyse wurde verwendet.\" 4) Antworte auf Deutsch.'),
('O',1,'osTicket',''),
('T',1,'465837 osTicket Installed!',''),
('T',2,'596870 Login issue','Login issue'),
('T',3,'175026 ES GEHT NICHT','ES GEHT NICHT'),
('T',4,'612485 SSO ERROR','SSO ERROR'),
('T',5,'771753 Screenshot error','Screenshot error'),
('U',1,'osTicket Team','feedback@osticket.com'),
('U',2,'Yannick',' yannick.beck@test.de\nyannick.beck@test.de'),
('U',3,'Yannick',' Yannick@test.de\nYannick@test.de');
/*!40000 ALTER TABLE `ost__search` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_ai_reply_log`
--

DROP TABLE IF EXISTS `ost_ai_reply_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_ai_reply_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `ticket_id` int(10) unsigned NOT NULL,
  `message_id` int(10) unsigned DEFAULT NULL COMMENT 'Thread entry ID of the triggering user message',
  `note_id` int(10) unsigned DEFAULT NULL COMMENT 'Thread entry ID of the created AI note (if any)',
  `status` enum('generated','skipped','error') NOT NULL,
  `reason` varchar(255) DEFAULT NULL COMMENT 'Reason for skip/error (no PII)',
  `model` varchar(100) DEFAULT NULL COMMENT 'OpenAI model used',
  `prompt_tokens` int(10) unsigned DEFAULT NULL,
  `completion_tokens` int(10) unsigned DEFAULT NULL,
  `total_tokens` int(10) unsigned DEFAULT NULL,
  `latency_ms` int(10) unsigned DEFAULT NULL COMMENT 'API call duration in milliseconds',
  `confidence` decimal(3,2) DEFAULT NULL COMMENT 'AI confidence score 0.00-1.00',
  `hash_prompt` char(64) DEFAULT NULL COMMENT 'SHA-256 hash of the sent prompt (no raw content)',
  `hash_response` char(64) DEFAULT NULL COMMENT 'SHA-256 hash of the AI response (no raw content)',
  PRIMARY KEY (`id`),
  KEY `idx_ticket_id` (`ticket_id`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_status` (`status`),
  KEY `idx_ticket_created` (`ticket_id`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_ai_reply_log`
--

LOCK TABLES `ost_ai_reply_log` WRITE;
/*!40000 ALTER TABLE `ost_ai_reply_log` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ost_ai_reply_log` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_api_key`
--

DROP TABLE IF EXISTS `ost_api_key`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_api_key` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `isactive` tinyint(1) NOT NULL DEFAULT 1,
  `ipaddr` varchar(64) NOT NULL,
  `apikey` varchar(255) NOT NULL,
  `can_create_tickets` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `can_exec_cron` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `notes` text DEFAULT NULL,
  `updated` datetime NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `apikey` (`apikey`),
  KEY `ipaddr` (`ipaddr`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_api_key`
--

LOCK TABLES `ost_api_key` WRITE;
/*!40000 ALTER TABLE `ost_api_key` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ost_api_key` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_attachment`
--

DROP TABLE IF EXISTS `ost_attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_attachment` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` int(11) unsigned NOT NULL,
  `type` char(1) NOT NULL,
  `file_id` int(11) unsigned NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `inline` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `lang` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `file-type` (`object_id`,`file_id`,`type`),
  UNIQUE KEY `file_object` (`file_id`,`object_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_attachment`
--

LOCK TABLES `ost_attachment` WRITE;
/*!40000 ALTER TABLE `ost_attachment` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_attachment` VALUES
(1,1,'C',2,NULL,0,NULL),
(2,8,'T',1,NULL,1,NULL),
(3,9,'T',1,NULL,1,NULL),
(4,10,'T',1,NULL,1,NULL),
(5,11,'T',1,NULL,1,NULL),
(6,12,'T',1,NULL,1,NULL),
(7,13,'T',1,NULL,1,NULL),
(8,14,'T',1,NULL,1,NULL),
(9,16,'T',1,NULL,1,NULL),
(10,17,'T',1,NULL,1,NULL),
(11,18,'T',1,NULL,1,NULL),
(12,19,'T',1,NULL,1,NULL),
(13,4,'H',2,NULL,0,NULL),
(14,3,'D',3,NULL,0,NULL),
(15,9,'H',3,NULL,1,NULL),
(16,6,'D',3,NULL,0,NULL),
(17,5,'D',3,NULL,0,NULL),
(18,14,'H',3,NULL,1,NULL);
/*!40000 ALTER TABLE `ost_attachment` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_canned_response`
--

DROP TABLE IF EXISTS `ost_canned_response`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_canned_response` (
  `canned_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dept_id` int(10) unsigned NOT NULL DEFAULT 0,
  `isenabled` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `title` varchar(255) NOT NULL DEFAULT '',
  `response` text NOT NULL,
  `lang` varchar(16) NOT NULL DEFAULT 'en_US',
  `notes` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`canned_id`),
  UNIQUE KEY `title` (`title`),
  KEY `dept_id` (`dept_id`),
  KEY `active` (`isenabled`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_canned_response`
--

LOCK TABLES `ost_canned_response` WRITE;
/*!40000 ALTER TABLE `ost_canned_response` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_canned_response` VALUES
(1,0,1,'What is osTicket (sample)?','osTicket is a widely-used open source support ticket system, an\nattractive alternative to higher-cost and complex customer support\nsystems - simple, lightweight, reliable, open source, web-based and easy\nto setup and use.','en_US',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(2,0,1,'Sample (with variables)','Hi %{ticket.name.first},\n<br>\n<br>\nYour ticket #%{ticket.number} created on %{ticket.create_date} is in\n%{ticket.dept.name} department.','en_US',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04');
/*!40000 ALTER TABLE `ost_canned_response` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_config`
--

DROP TABLE IF EXISTS `ost_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_config` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `namespace` varchar(64) NOT NULL,
  `key` varchar(64) NOT NULL,
  `value` text NOT NULL,
  `updated` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `namespace` (`namespace`,`key`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_config`
--

LOCK TABLES `ost_config` WRITE;
/*!40000 ALTER TABLE `ost_config` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_config` VALUES
(1,'core','admin_email','admin@ki-projekt.local','2026-02-19 17:15:04'),
(2,'core','helpdesk_url','http://127.0.0.1/','2026-02-19 17:15:04'),
(3,'core','helpdesk_title','KI Helpdesk','2026-02-19 17:15:04'),
(4,'core','schema_signature','5fb92bef17f3b603659e024c01cc7a59','2026-02-19 17:15:04'),
(5,'schedule.1','configuration','{\"holidays\":[4]}','2026-02-19 17:15:04'),
(6,'core','time_format','hh:mm a','2026-02-19 17:15:04'),
(7,'core','date_format','MM/dd/y','2026-02-19 17:15:04'),
(8,'core','datetime_format','MM/dd/y h:mm a','2026-02-19 17:15:04'),
(9,'core','daydatetime_format','EEE, MMM d y h:mm a','2026-02-19 17:15:04'),
(10,'core','default_priority_id','2','2026-02-19 17:15:04'),
(11,'core','enable_daylight_saving','','2026-02-19 17:15:04'),
(12,'core','reply_separator','-- reply above this line --','2026-02-19 17:15:04'),
(13,'core','isonline','1','2026-02-19 17:15:04'),
(14,'core','staff_ip_binding','','2026-02-19 17:15:04'),
(15,'core','staff_max_logins','4','2026-02-19 17:15:04'),
(16,'core','staff_login_timeout','2','2026-02-19 17:15:04'),
(17,'core','staff_session_timeout','30','2026-02-19 17:15:04'),
(18,'core','passwd_reset_period','','2026-02-19 17:15:04'),
(19,'core','client_max_logins','4','2026-02-19 17:15:04'),
(20,'core','client_login_timeout','2','2026-02-19 17:15:04'),
(21,'core','client_session_timeout','30','2026-02-19 17:15:04'),
(22,'core','max_page_size','25','2026-02-19 17:15:04'),
(23,'core','max_open_tickets','','2026-02-19 17:15:04'),
(24,'core','autolock_minutes','3','2026-02-19 17:15:04'),
(25,'core','default_smtp_id','','2026-02-19 17:15:04'),
(26,'core','use_email_priority','','2026-02-19 17:15:04'),
(27,'core','enable_kb','1','2026-02-19 17:42:45'),
(28,'core','enable_premade','1','2026-02-19 17:15:04'),
(29,'core','enable_captcha','','2026-02-19 17:15:04'),
(30,'core','enable_auto_cron','','2026-02-19 17:15:04'),
(31,'core','enable_mail_polling','','2026-02-19 17:15:04'),
(32,'core','send_sys_errors','1','2026-02-19 17:15:04'),
(33,'core','send_sql_errors','1','2026-02-19 17:15:04'),
(34,'core','send_login_errors','1','2026-02-19 17:15:04'),
(35,'core','save_email_headers','1','2026-02-19 17:15:04'),
(36,'core','strip_quoted_reply','1','2026-02-19 17:15:04'),
(37,'core','ticket_autoresponder','','2026-02-19 17:15:04'),
(38,'core','message_autoresponder','','2026-02-19 17:15:04'),
(39,'core','ticket_notice_active','1','2026-02-19 17:15:04'),
(40,'core','ticket_alert_active','1','2026-02-19 17:15:04'),
(41,'core','ticket_alert_admin','1','2026-02-19 17:15:04'),
(42,'core','ticket_alert_dept_manager','1','2026-02-19 17:15:04'),
(43,'core','ticket_alert_dept_members','','2026-02-19 17:15:04'),
(44,'core','message_alert_active','1','2026-02-19 17:15:04'),
(45,'core','message_alert_laststaff','1','2026-02-19 17:15:04'),
(46,'core','message_alert_assigned','1','2026-02-19 17:15:04'),
(47,'core','message_alert_dept_manager','','2026-02-19 17:15:04'),
(48,'core','note_alert_active','','2026-02-19 17:15:04'),
(49,'core','note_alert_laststaff','1','2026-02-19 17:15:04'),
(50,'core','note_alert_assigned','1','2026-02-19 17:15:04'),
(51,'core','note_alert_dept_manager','','2026-02-19 17:15:04'),
(52,'core','transfer_alert_active','','2026-02-19 17:15:04'),
(53,'core','transfer_alert_assigned','','2026-02-19 17:15:04'),
(54,'core','transfer_alert_dept_manager','1','2026-02-19 17:15:04'),
(55,'core','transfer_alert_dept_members','','2026-02-19 17:15:04'),
(56,'core','overdue_alert_active','1','2026-02-19 17:15:04'),
(57,'core','overdue_alert_assigned','1','2026-02-19 17:15:04'),
(58,'core','overdue_alert_dept_manager','1','2026-02-19 17:15:04'),
(59,'core','overdue_alert_dept_members','','2026-02-19 17:15:04'),
(60,'core','assigned_alert_active','1','2026-02-19 17:15:04'),
(61,'core','assigned_alert_staff','1','2026-02-19 17:15:04'),
(62,'core','assigned_alert_team_lead','','2026-02-19 17:15:04'),
(63,'core','assigned_alert_team_members','','2026-02-19 17:15:04'),
(64,'core','auto_claim_tickets','1','2026-02-19 17:15:04'),
(65,'core','auto_refer_closed','1','2026-02-19 17:15:04'),
(66,'core','collaborator_ticket_visibility','1','2026-02-19 17:15:04'),
(67,'core','require_topic_to_close','','2026-02-19 17:15:04'),
(68,'core','show_related_tickets','1','2026-02-19 17:15:04'),
(69,'core','show_assigned_tickets','1','2026-02-19 17:15:04'),
(70,'core','show_answered_tickets','','2026-02-19 17:15:04'),
(71,'core','hide_staff_name','','2026-02-19 17:15:04'),
(72,'core','disable_agent_collabs','','2026-02-19 17:15:04'),
(73,'core','overlimit_notice_active','','2026-02-19 17:15:04'),
(74,'core','email_attachments','1','2026-02-19 17:15:04'),
(75,'core','ticket_number_format','######','2026-02-19 17:15:04'),
(76,'core','ticket_sequence_id','','2026-02-19 17:15:04'),
(77,'core','queue_bucket_counts','','2026-02-19 17:15:04'),
(78,'core','allow_external_images','','2026-02-19 17:15:04'),
(79,'core','task_number_format','#','2026-02-19 17:15:04'),
(80,'core','task_sequence_id','2','2026-02-19 17:15:04'),
(81,'core','log_level','2','2026-02-19 17:15:04'),
(82,'core','log_graceperiod','12','2026-02-19 17:15:04'),
(83,'core','client_registration','public','2026-02-19 17:15:04'),
(84,'core','default_ticket_queue','1','2026-02-19 17:15:04'),
(85,'core','embedded_domain_whitelist','youtube.com, dailymotion.com, vimeo.com, player.vimeo.com, web.microsoftstream.com','2026-02-19 17:15:04'),
(86,'core','max_file_size','1048576','2026-02-19 17:15:04'),
(87,'core','landing_page_id','1','2026-02-19 17:15:04'),
(88,'core','thank-you_page_id','2','2026-02-19 17:15:04'),
(89,'core','offline_page_id','3','2026-02-19 17:15:04'),
(90,'core','system_language','en_US','2026-02-19 17:15:04'),
(91,'mysqlsearch','reindex','0','2026-02-19 17:42:46'),
(92,'core','default_email_id','1','2026-02-19 17:15:04'),
(93,'core','alert_email_id','2','2026-02-19 17:15:04'),
(94,'core','default_dept_id','1','2026-02-19 17:15:04'),
(95,'core','default_sla_id','1','2026-02-19 17:15:04'),
(96,'core','schedule_id','1','2026-02-19 17:15:04'),
(97,'core','default_template_id','1','2026-02-19 17:15:04'),
(98,'core','default_timezone','Europe/Berlin','2026-02-19 17:15:04'),
(99,'core','restrict_kb','','2026-02-19 17:42:45'),
(100,'plugin.1.instance.1','enabled','1','2026-02-19 22:42:39'),
(101,'plugin.1.instance.1','log_level','{\"error\":\"ERROR \\u2014 Errors only\"}','2026-02-19 22:38:31'),
(102,'plugin.1.instance.1','llm_base_url','http://127.0.0.1:11434/v1','2026-02-19 22:38:31'),
(103,'plugin.1.instance.1','llm_auth_enabled','0','2026-02-19 22:38:31'),
(104,'plugin.1.instance.1','llm_api_key','','2026-02-19 22:38:31'),
(105,'plugin.1.instance.1','llm_model','{\"gemma3:4b\":\"gemma3:4b \\u2014 Fast and stable for local deployment (recommended)\"}','2026-02-19 22:38:31'),
(106,'plugin.1.instance.1','llm_model_custom','','2026-02-19 22:38:31'),
(107,'plugin.1.instance.1','openai_api_key','','2026-02-19 22:38:31'),
(108,'plugin.1.instance.1','openai_model','{\"gpt-4.1-mini\":\"gpt-4.1-mini \\u2014 Fast & affordable (recommended)\"}','2026-02-19 22:38:31'),
(109,'plugin.1.instance.1','openai_model_custom','','2026-02-19 22:38:31'),
(110,'plugin.1.instance.1','openai_max_tokens','700','2026-02-19 22:38:31'),
(111,'plugin.1.instance.1','openai_temperature','0.2','2026-02-19 22:38:31'),
(112,'plugin.1.instance.1','openai_timeout','300','2026-02-20 11:18:42'),
(113,'plugin.1.instance.1','openai_retry_count','1','2026-02-19 22:38:31'),
(114,'plugin.1.instance.1','allowed_departments','','2026-02-19 22:38:31'),
(115,'plugin.1.instance.1','blocked_priorities','','2026-02-19 22:38:31'),
(116,'plugin.1.instance.1','blocked_tags','<p>incident,security,legal,billing</p>','2026-02-19 22:38:31'),
(117,'plugin.1.instance.1','allowed_statuses','open','2026-02-19 22:38:31'),
(118,'plugin.1.instance.1','attachment_policy','{\"ignore\":\"Ignore \\u2014 Process message text, skip attachments\"}','2026-02-19 22:38:31'),
(119,'plugin.1.instance.1','context_message_count','6','2026-02-19 22:38:31'),
(120,'plugin.1.instance.1','max_message_length','2000','2026-02-19 22:38:31'),
(121,'plugin.1.instance.1','response_language','Deutsch','2026-02-19 22:38:31'),
(122,'plugin.1.instance.1','mini_kb_content','','2026-02-19 22:38:31'),
(123,'plugin.1.instance.1','use_osticket_kb','1','2026-02-23 15:20:32'),
(124,'plugin.1.instance.1','use_canned_responses','1','2026-02-23 15:20:32'),
(125,'plugin.1.instance.1','kb_article_limit','3','2026-02-19 22:38:31'),
(126,'plugin.1.instance.1','pii_redaction_enabled','0','2026-02-19 22:38:31'),
(127,'plugin.1.instance.1','redact_ip_addresses','0','2026-02-19 22:38:31'),
(128,'plugin.1.instance.1','rate_limit_per_ticket_seconds','0','2026-02-20 11:18:19'),
(129,'plugin.1.instance.1','rate_limit_global_per_minute','0','2026-02-20 11:18:19'),
(130,'plugin.1.instance.1','rag_enabled','1','2026-02-20 11:13:55'),
(131,'plugin.1.instance.1','rag_service_url','http://127.0.0.1:8099','2026-02-20 11:13:55'),
(132,'plugin.1.instance.1','kb_reference_base_url','','2026-02-20 11:13:55'),
(133,'plugin.1.instance.1','rag_timeout_seconds','10','2026-02-20 11:13:55'),
(134,'plugin.1.instance.1','rag_top_k','5','2026-02-20 11:13:55'),
(135,'plugin.1.instance.1','rag_fail_mode','{\"strict\":\"Strict \\u2014 Abort AI draft when RAG service fails (required)\"}','2026-02-20 11:13:55'),
(136,'plugin.1.instance.1','attachment_max_images','3','2026-02-23 15:20:32'),
(137,'plugin.1.instance.1','attachment_max_image_bytes','2097152','2026-02-23 15:20:32');
/*!40000 ALTER TABLE `ost_config` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_content`
--

DROP TABLE IF EXISTS `ost_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_content` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `isactive` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `type` varchar(32) NOT NULL DEFAULT 'other',
  `name` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `notes` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_content`
--

LOCK TABLES `ost_content` WRITE;
/*!40000 ALTER TABLE `ost_content` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_content` VALUES
(1,1,'landing','Landing','<h1>Welcome to the Support Center</h1> <p> In order to streamline support requests and better serve you, we utilize a support ticket system. Every support request is assigned a unique ticket number which you can use to track the progress and responses online. For your reference we provide complete archives and history of all your support requests. A valid email address is required to submit a ticket. </p>','The Landing Page refers to the content of the Customer Portal\'s initial view. The template modifies the content seen above the two links <strong>Open a New Ticket</strong> and <strong>Check Ticket Status</strong>.','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(2,1,'thank-you','Thank You','<div>%{ticket.name},\n<br>\n<br>\nThank you for contacting us.\n<br>\n<br>\nA support ticket request has been created and a representative will be\ngetting back to you shortly if necessary.</p>\n<br>\n<br>\nSupport Team\n</div>','This template defines the content displayed on the Thank-You page after a\nClient submits a new ticket in the Client Portal.','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(3,1,'offline','Offline','<div><h1>\n<span style=\"font-size: medium\">Support Ticket System Offline</span>\n</h1>\n<p>Thank you for your interest in contacting us.</p>\n<p>Our helpdesk is offline at the moment, please check back at a later\ntime.</p>\n</div>','The Offline Page appears in the Customer Portal when the Help Desk is offline.','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(4,1,'registration-staff','Welcome to osTicket','<h3><strong>Hi %{recipient.name.first},</strong></h3> <div> We\'ve created an account for you at our help desk at %{url}.<br /> <br /> Please follow the link below to confirm your account and gain access to your tickets.<br /> <br /> <a href=\"%{link}\">%{link}</a><br /> <br /> <em style=\"font-size: small\">Your friendly Customer Support System<br /> %{company.name}</em> </div>','This template defines the initial email (optional) sent to Agents when an account is created on their behalf.','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(5,1,'pwreset-staff','osTicket Staff Password Reset','<h3><strong>Hi %{staff.name.first},</strong></h3> <div> A password reset request has been submitted on your behalf for the helpdesk at %{url}.<br /> <br /> If you feel that this has been done in error, delete and disregard this email. Your account is still secure and no one has been given access to it. It is not locked and your password has not been reset. Someone could have mistakenly entered your email address.<br /> <br /> Follow the link below to login to the help desk and change your password.<br /> <br /> <a href=\"%{link}\">%{link}</a><br /> <br /> <em style=\"font-size: small\">Your friendly Customer Support System</em> <br /> <img src=\"cid:b56944cb4722cc5cda9d1e23a3ea7fbc\" alt=\"Powered by osTicket\" width=\"126\" height=\"19\" style=\"width: 126px\" /> </div>','This template defines the email sent to Staff who select the <strong>Forgot My Password</strong> link on the Staff Control Panel Log In page.','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(6,1,'banner-staff','Authentication Required','','This is the initial message and banner shown on the Staff Log In page. The first input field refers to the red-formatted text that appears at the top. The latter textarea is for the banner content which should serve as a disclaimer.','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(7,1,'registration-client','Welcome to %{company.name}','<h3><strong>Hi %{recipient.name.first},</strong></h3> <div> We\'ve created an account for you at our help desk at %{url}.<br /> <br /> Please follow the link below to confirm your account and gain access to your tickets.<br /> <br /> <a href=\"%{link}\">%{link}</a><br /> <br /> <em style=\"font-size: small\">Your friendly Customer Support System <br /> %{company.name}</em> </div>','This template defines the email sent to Clients when their account has been created in the Client Portal or by an Agent on their behalf. This email serves as an email address verification. Please use %{link} somewhere in the body.','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(8,1,'pwreset-client','%{company.name} Help Desk Access','<h3><strong>Hi %{user.name.first},</strong></h3> <div> A password reset request has been submitted on your behalf for the helpdesk at %{url}.<br /> <br /> If you feel that this has been done in error, delete and disregard this email. Your account is still secure and no one has been given access to it. It is not locked and your password has not been reset. Someone could have mistakenly entered your email address.<br /> <br /> Follow the link below to login to the help desk and change your password.<br /> <br /> <a href=\"%{link}\">%{link}</a><br /> <br /> <em style=\"font-size: small\">Your friendly Customer Support System <br /> %{company.name}</em> </div>','This template defines the email sent to Clients who select the <strong>Forgot My Password</strong> link on the Client Log In page.','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(9,1,'banner-client','Sign in to %{company.name}','To better serve you, we encourage our Clients to register for an account.','This composes the header on the Client Log In page. It can be useful to inform your Clients about your log in and registration policies.','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(10,1,'registration-confirm','Account registration','<div><strong>Thanks for registering for an account.</strong><br/> <br /> We\'ve just sent you an email to the address you entered. Please follow the link in the email to confirm your account and gain access to your tickets. </div>','This templates defines the page shown to Clients after completing the registration form. The template should mention that the system is sending them an email confirmation link and what is the next step in the registration process.','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(11,1,'registration-thanks','Account Confirmed!','<div> <strong>Thanks for registering for an account.</strong><br /> <br /> You\'ve confirmed your email address and successfully activated your account. You may proceed to open a new ticket or manage existing tickets.<br /> <br /> <em>Your friendly support center</em><br /> %{company.name} </div>','This template defines the content displayed after Clients successfully register by confirming their account. This page should inform the user that registration is complete and that the Client can now submit a ticket or access existing tickets.','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(12,1,'access-link','Ticket [#%{ticket.number}] Access Link','<h3><strong>Hi %{recipient.name.first},</strong></h3> <div> An access link request for ticket #%{ticket.number} has been submitted on your behalf for the helpdesk at %{url}.<br /> <br /> Follow the link below to check the status of the ticket #%{ticket.number}.<br /> <br /> <a href=\"%{recipient.ticket_link}\">%{recipient.ticket_link}</a><br /> <br /> If you <strong>did not</strong> make the request, please delete and disregard this email. Your account is still secure and no one has been given access to the ticket. Someone could have mistakenly entered your email address.<br /> <br /> --<br /> %{company.name} </div>','This template defines the notification for Clients that an access link was sent to their email. The ticket number and email address trigger the access link.','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(13,1,'email2fa-staff','osTicket Two Factor Authentication','<h3><strong>Hi %{staff.name.first},</strong></h3> <div> You have just logged into for the helpdesk at %{url}.<br /> <br /> Use the verification code below to finish logging into the helpdesk.<br /> <br /> %{otp}<br /> <br /> <em style=\"font-size: small\">Your friendly Customer Support System</em> <br /> <img src=\"cid:b56944cb4722cc5cda9d1e23a3ea7fbc\" alt=\"Powered by osTicket\" width=\"126\" height=\"19\" style=\"width: 126px\" /> </div>','This template defines the email sent to Staff who use Email for Two Factor Authentication','2026-02-19 18:15:04','2026-02-19 18:15:04');
/*!40000 ALTER TABLE `ost_content` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_department`
--

DROP TABLE IF EXISTS `ost_department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_department` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(11) unsigned DEFAULT NULL,
  `tpl_id` int(10) unsigned NOT NULL DEFAULT 0,
  `sla_id` int(10) unsigned NOT NULL DEFAULT 0,
  `schedule_id` int(10) unsigned NOT NULL DEFAULT 0,
  `email_id` int(10) unsigned NOT NULL DEFAULT 0,
  `autoresp_email_id` int(10) unsigned NOT NULL DEFAULT 0,
  `manager_id` int(10) unsigned NOT NULL DEFAULT 0,
  `flags` int(10) unsigned NOT NULL DEFAULT 0,
  `name` varchar(128) NOT NULL DEFAULT '',
  `signature` text NOT NULL,
  `ispublic` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `group_membership` tinyint(1) NOT NULL DEFAULT 0,
  `ticket_auto_response` tinyint(1) NOT NULL DEFAULT 1,
  `message_auto_response` tinyint(1) NOT NULL DEFAULT 0,
  `path` varchar(128) NOT NULL DEFAULT '/',
  `updated` datetime NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`,`pid`),
  KEY `manager_id` (`manager_id`),
  KEY `autoresp_email_id` (`autoresp_email_id`),
  KEY `tpl_id` (`tpl_id`),
  KEY `flags` (`flags`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_department`
--

LOCK TABLES `ost_department` WRITE;
/*!40000 ALTER TABLE `ost_department` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_department` VALUES
(1,NULL,0,0,0,0,0,0,4,'Support','Support Department',1,1,1,1,'/1/','2026-02-19 18:15:03','2026-02-19 18:15:03'),
(2,NULL,0,1,0,0,0,0,4,'Sales','Sales and Customer Retention',1,1,1,1,'/2/','2026-02-19 18:15:03','2026-02-19 18:15:03'),
(3,NULL,0,0,0,0,0,0,4,'Maintenance','Maintenance Department',1,0,1,1,'/3/','2026-02-19 18:15:03','2026-02-19 18:15:03');
/*!40000 ALTER TABLE `ost_department` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_draft`
--

DROP TABLE IF EXISTS `ost_draft`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_draft` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `staff_id` int(11) unsigned NOT NULL,
  `namespace` varchar(32) NOT NULL DEFAULT '',
  `body` text NOT NULL,
  `extra` text DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `staff_id` (`staff_id`),
  KEY `namespace` (`namespace`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_draft`
--

LOCK TABLES `ost_draft` WRITE;
/*!40000 ALTER TABLE `ost_draft` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_draft` VALUES
(1,1,'ticket.response.2','<p>osTicket is a widely-used open source support ticket system, an</p>\n<p>attractive alternative to higher-cost and complex customer support</p>\n<p>systems - simple, lightweight, reliable, open source, web-based and easy</p>\n<p>to setup and use.</p>',NULL,'2026-02-19 22:32:44',NULL);
/*!40000 ALTER TABLE `ost_draft` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_email`
--

DROP TABLE IF EXISTS `ost_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_email` (
  `email_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `noautoresp` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `priority_id` int(11) unsigned NOT NULL DEFAULT 2,
  `dept_id` int(11) unsigned NOT NULL DEFAULT 0,
  `topic_id` int(11) unsigned NOT NULL DEFAULT 0,
  `email` varchar(255) NOT NULL DEFAULT '',
  `name` varchar(255) NOT NULL DEFAULT '',
  `notes` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`email_id`),
  UNIQUE KEY `email` (`email`),
  KEY `priority_id` (`priority_id`),
  KEY `dept_id` (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_email`
--

LOCK TABLES `ost_email` WRITE;
/*!40000 ALTER TABLE `ost_email` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_email` VALUES
(1,0,2,1,0,'support@ki-projekt.local','Support',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(2,0,2,1,0,'alerts@ki-projekt.local','osTicket Alerts',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(3,0,2,1,0,'noreply@ki-projekt.local','',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04');
/*!40000 ALTER TABLE `ost_email` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_email_account`
--

DROP TABLE IF EXISTS `ost_email_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_email_account` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `email_id` int(11) unsigned NOT NULL,
  `type` enum('mailbox','smtp') NOT NULL DEFAULT 'mailbox',
  `auth_bk` varchar(128) NOT NULL,
  `auth_id` varchar(16) DEFAULT NULL,
  `active` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `host` varchar(128) NOT NULL DEFAULT '',
  `port` int(11) NOT NULL,
  `folder` varchar(255) DEFAULT NULL,
  `protocol` enum('IMAP','POP','SMTP','OTHER') NOT NULL DEFAULT 'OTHER',
  `encryption` enum('NONE','AUTO','SSL') NOT NULL DEFAULT 'AUTO',
  `fetchfreq` tinyint(3) unsigned NOT NULL DEFAULT 5,
  `fetchmax` tinyint(4) unsigned DEFAULT 30,
  `postfetch` enum('archive','delete','nothing') NOT NULL DEFAULT 'nothing',
  `archivefolder` varchar(255) DEFAULT NULL,
  `allow_spoofing` tinyint(1) unsigned DEFAULT 0,
  `num_errors` int(11) unsigned NOT NULL DEFAULT 0,
  `last_error_msg` tinytext DEFAULT NULL,
  `last_error` datetime DEFAULT NULL,
  `last_activity` datetime DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `email_id` (`email_id`),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_email_account`
--

LOCK TABLES `ost_email_account` WRITE;
/*!40000 ALTER TABLE `ost_email_account` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ost_email_account` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_email_template`
--

DROP TABLE IF EXISTS `ost_email_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_email_template` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tpl_id` int(11) unsigned NOT NULL,
  `code_name` varchar(32) NOT NULL,
  `subject` varchar(255) NOT NULL DEFAULT '',
  `body` text NOT NULL,
  `notes` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `template_lookup` (`tpl_id`,`code_name`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_email_template`
--

LOCK TABLES `ost_email_template` WRITE;
/*!40000 ALTER TABLE `ost_email_template` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_email_template` VALUES
(1,1,'ticket.autoresp','Support Ticket Opened [#%{ticket.number}]','<h3><strong>Dear %{recipient.name.first},</strong></h3> <p>A request for support has been created and assigned #%{ticket.number}. A representative will follow-up with you as soon as possible. You can <a href=\"%%7Brecipient.ticket_link%7D\">view this ticket\'s progress online</a>. </p> <br /> <div style=\"color:rgb(127, 127, 127)\">Your %{company.name} Team, <br /> %{signature} </div> <hr /> <div style=\"color:rgb(127, 127, 127);font-size:small\"><em>If you wish to provide additional comments or information regarding the issue, please reply to this email or <a href=\"%%7Brecipient.ticket_link%7D\"><span style=\"color:rgb(84, 141, 212)\">login to your account</span></a> for a complete archive of your support requests.</em></div>',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(2,1,'ticket.autoreply','Re: %{ticket.subject} [#%{ticket.number}]','<h3><strong>Dear %{recipient.name.first},</strong></h3> A request for support has been created and assigned ticket <a href=\"%%7Brecipient.ticket_link%7D\">#%{ticket.number}</a> with the following automatic reply <br /> <br /> Topic: <strong>%{ticket.topic.name}</strong> <br /> Subject: <strong>%{ticket.subject}</strong> <br /> <br /> %{response} <br /> <br /> <div style=\"color:rgb(127, 127, 127)\">Your %{company.name} Team,<br /> %{signature}</div> <hr /> <div style=\"color:rgb(127, 127, 127);font-size:small\"><em>We hope this response has sufficiently answered your questions. If you wish to provide additional comments or information, please reply to this email or <a href=\"%%7Brecipient.ticket_link%7D\"><span style=\"color:rgb(84, 141, 212)\">login to your account</span></a> for a complete archive of your support requests.</em></div>',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(3,1,'message.autoresp','Message Confirmation','<h3><strong>Dear %{recipient.name.first},</strong></h3> Your reply to support request <a href=\"%%7Brecipient.ticket_link%7D\">#%{ticket.number}</a> has been noted <br /> <br /> <div style=\"color:rgb(127, 127, 127)\">Your %{company.name} Team,<br /> %{signature} </div> <hr /> <div style=\"color:rgb(127, 127, 127);font-size:small;text-align:center\"><em>You can view the support request progress <a href=\"%%7Brecipient.ticket_link%7D\">online here</a></em> </div>',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(4,1,'ticket.notice','%{ticket.subject} [#%{ticket.number}]','<h3><strong>Dear %{recipient.name.first},</strong></h3> Our customer care team has created a ticket, <a href=\"%%7Brecipient.ticket_link%7D\">#%{ticket.number}</a> on your behalf, with the following details and summary: <br /> <br /> Topic: <strong>%{ticket.topic.name}</strong> <br /> Subject: <strong>%{ticket.subject}</strong> <br /> <br /> %{message} <br /> <br /> %{response} <br /> <br /> If need be, a representative will follow-up with you as soon as possible. You can also <a href=\"%%7Brecipient.ticket_link%7D\">view this ticket\'s progress online</a>. <br /> <br /> <div style=\"color:rgb(127, 127, 127)\">Your %{company.name} Team,<br /> %{signature}</div> <hr /> <div style=\"color:rgb(127, 127, 127);font-size:small\"><em>If you wish to provide additional comments or information regarding the issue, please reply to this email or <a href=\"%%7Brecipient.ticket_link%7D\"><span style=\"color:rgb(84, 141, 212)\">login to your account</span></a> for a complete archive of your support requests.</em></div>',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(5,1,'ticket.overlimit','Open Tickets Limit Reached','<h3><strong>Dear %{ticket.name.first},</strong></h3> You have reached the maximum number of open tickets allowed. To be able to open another ticket, one of your pending tickets must be closed. To update or add comments to an open ticket simply <a href=\"%%7Burl%7D/tickets.php?e=%%7Bticket.email%7D\">login to our helpdesk</a>. <br /> <br /> Thank you,<br /> Support Ticket System',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(6,1,'ticket.reply','Re: %{ticket.subject} [#%{ticket.number}]','<h3><strong>Dear %{recipient.name.first},</strong></h3> %{response} <br /> <br /> <div style=\"color:rgb(127, 127, 127)\">Your %{company.name} Team,<br /> %{signature} </div> <hr /> <div style=\"color:rgb(127, 127, 127);font-size:small;text-align:center\"><em>We hope this response has sufficiently answered your questions. If not, please do not send another email. Instead, reply to this email or <a href=\"%%7Brecipient.ticket_link%7D\" style=\"color:rgb(84, 141, 212)\">login to your account</a> for a complete archive of all your support requests and responses.</em></div>',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(7,1,'ticket.activity.notice','Re: %{ticket.subject} [#%{ticket.number}]','<h3><strong>Dear %{recipient.name.first},</strong></h3> <div><em>%{poster.name}</em> just logged a message to a ticket in which you participate. </div> <br /> %{message} <br /> <br /> <hr /> <div style=\"color:rgb(127, 127, 127);font-size:small;text-align:center\"><em>You\'re getting this email because you are a collaborator on ticket <a href=\"%%7Brecipient.ticket_link%7D\" style=\"color:rgb(84, 141, 212)\">#%{ticket.number}</a>. To participate, simply reply to this email or <a href=\"%%7Brecipient.ticket_link%7D\" style=\"color:rgb(84, 141, 212)\">click here</a> for a complete archive of the ticket thread.</em> </div>',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(8,1,'ticket.alert','New Ticket Alert','<h2>Hi %{recipient.name},</h2> New ticket #%{ticket.number} created <br /> <br /> <table><tbody><tr><td><strong>From</strong>: </td> <td>%{ticket.name} &lt;%{ticket.email}&gt; </td> </tr> <tr><td><strong>Department</strong>: </td> <td>%{ticket.dept.name} </td> </tr> </tbody> </table> <br /> %{message} <br /> <br /> <hr /> <div>To view or respond to the ticket, please <a href=\"%%7Bticket.staff_link%7D\">login</a> to the support ticket system</div> <em style=\"font-size:small\">Your friendly Customer Support System</em> <br /> <a href=\"https://osticket.com/\"><img width=\"126\" height=\"19\" style=\"width:126px\" alt=\"Powered By osTicket\" src=\"cid:b56944cb4722cc5cda9d1e23a3ea7fbc\" /></a>',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(9,1,'message.alert','New Message Alert','<h3><strong>Hi %{recipient.name},</strong></h3> New message appended to ticket <a href=\"%%7Bticket.staff_link%7D\">#%{ticket.number}</a> <br /> <br /> <table><tbody><tr><td><strong>From</strong>: </td> <td>%{poster.name} &lt;%{ticket.email}&gt; </td> </tr> <tr><td><strong>Department</strong>: </td> <td>%{ticket.dept.name} </td> </tr> </tbody> </table> <br /> %{message} <br /> <br /> <hr /> <div>To view or respond to the ticket, please <a href=\"%%7Bticket.staff_link%7D\"><span style=\"color:rgb(84, 141, 212)\">login</span></a> to the support ticket system</div> <em style=\"color:rgb(127,127,127);font-size:small\">Your friendly Customer Support System</em><br /> <img src=\"cid:b56944cb4722cc5cda9d1e23a3ea7fbc\" alt=\"Powered by osTicket\" width=\"126\" height=\"19\" style=\"width:126px\" />',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(10,1,'note.alert','New Internal Activity Alert','<h3><strong>Hi %{recipient.name},</strong></h3> An agent has logged activity on ticket <a href=\"%%7Bticket.staff_link%7D\">#%{ticket.number}</a> <br /> <br /> <table><tbody><tr><td><strong>From</strong>: </td> <td>%{note.poster} </td> </tr> <tr><td><strong>Title</strong>: </td> <td>%{note.title} </td> </tr> </tbody> </table> <br /> %{note.message} <br /> <br /> <hr /> To view/respond to the ticket, please <a href=\"%%7Bticket.staff_link%7D\">login</a> to the support ticket system <br /> <br /> <em style=\"font-size:small\">Your friendly Customer Support System</em> <br /> <img src=\"cid:b56944cb4722cc5cda9d1e23a3ea7fbc\" alt=\"Powered by osTicket\" width=\"126\" height=\"19\" style=\"width:126px\" />',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(11,1,'assigned.alert','Ticket Assigned to you','<h3><strong>Hi %{assignee.name.first},</strong></h3> Ticket <a href=\"%%7Bticket.staff_link%7D\">#%{ticket.number}</a> has been assigned to you by %{assigner.name.short} <br /> <br /> <table><tbody><tr><td><strong>From</strong>: </td> <td>%{ticket.name} &lt;%{ticket.email}&gt; </td> </tr> <tr><td><strong>Subject</strong>: </td> <td>%{ticket.subject} </td> </tr> </tbody> </table> <br /> %{comments} <br /> <br /> <hr /> <div>To view/respond to the ticket, please <a href=\"%%7Bticket.staff_link%7D\"><span style=\"color:rgb(84, 141, 212)\">login</span></a> to the support ticket system</div> <em style=\"font-size:small\">Your friendly Customer Support System</em> <br /> <img src=\"cid:b56944cb4722cc5cda9d1e23a3ea7fbc\" alt=\"Powered by osTicket\" width=\"126\" height=\"19\" style=\"width:126px\" />',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(12,1,'transfer.alert','Ticket #%{ticket.number} transfer - %{ticket.dept.name}','<h3>Hi %{recipient.name},</h3> Ticket <a href=\"%%7Bticket.staff_link%7D\">#%{ticket.number}</a> has been transferred to the %{ticket.dept.name} department by <strong>%{staff.name.short}</strong> <br /> <br /> <blockquote>%{comments} </blockquote> <hr /> <div>To view or respond to the ticket, please <a href=\"%%7Bticket.staff_link%7D\">login</a> to the support ticket system. </div> <em style=\"font-size:small\">Your friendly Customer Support System</em> <br /> <a href=\"https://osticket.com/\"><img width=\"126\" height=\"19\" alt=\"Powered By osTicket\" style=\"width:126px\" src=\"cid:b56944cb4722cc5cda9d1e23a3ea7fbc\" /></a>',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(13,1,'ticket.overdue','Stale Ticket Alert','<h3><strong>Hi %{recipient.name}</strong>,</h3> A ticket, <a href=\"%%7Bticket.staff_link%7D\">#%{ticket.number}</a> is seriously overdue. <br /> <br /> We should all work hard to guarantee that all tickets are being addressed in a timely manner. <br /> <br /> Signed,<br /> %{ticket.dept.manager.name} <hr /> <div>To view or respond to the ticket, please <a href=\"%%7Bticket.staff_link%7D\"><span style=\"color:rgb(84, 141, 212)\">login</span></a> to the support ticket system. You\'re receiving this notice because the ticket is assigned directly to you or to a team or department of which you\'re a member.</div> <em style=\"font-size:small\">Your friendly <span style=\"font-size:smaller\">(although with limited patience)</span> Customer Support System</em><br /> <img src=\"cid:b56944cb4722cc5cda9d1e23a3ea7fbc\" height=\"19\" alt=\"Powered by osTicket\" width=\"126\" style=\"width:126px\" />',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(14,1,'task.alert','New Task Alert','<h2>Hi %{recipient.name},</h2> New task <a href=\"%%7Btask.staff_link%7D\">#%{task.number}</a> created <br /> <br /> <table><tbody><tr><td><strong>Department</strong>: </td> <td>%{task.dept.name} </td> </tr> </tbody> </table> <br /> %{task.description} <br /> <br /> <hr /> <div>To view or respond to the task, please <a href=\"%%7Btask.staff_link%7D\">login</a> to the support system</div> <em style=\"font-size:small\">Your friendly Customer Support System</em> <br /> <a href=\"https://osticket.com/\"><img width=\"126\" height=\"19\" style=\"width:126px\" alt=\"Powered By osTicket\" src=\"cid:b56944cb4722cc5cda9d1e23a3ea7fbc\" /></a>',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(15,1,'task.activity.notice','Re: %{task.title} [#%{task.number}]','<h3><strong>Dear %{recipient.name.first},</strong></h3> <div><em>%{poster.name}</em> just logged a message to a task in which you participate. </div> <br /> %{message} <br /> <br /> <hr /> <div style=\"color:rgb(127, 127, 127);font-size:small;text-align:center\"><em>You\'re getting this email because you are a collaborator on task #%{task.number}. To participate, simply reply to this email.</em> </div>',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(16,1,'task.activity.alert','Task Activity [#%{task.number}] - %{activity.title}','<h3><strong>Hi %{recipient.name},</strong></h3> Task <a href=\"%%7Btask.staff_link%7D\">#%{task.number}</a> updated: %{activity.description} <br /> <br /> %{message} <br /> <br /> <hr /> <div>To view or respond to the task, please <a href=\"%%7Btask.staff_link%7D\"><span style=\"color:rgb(84, 141, 212)\">login</span></a> to the support system</div> <em style=\"color:rgb(127,127,127);font-size:small\">Your friendly Customer Support System</em><br /> <img src=\"cid:b56944cb4722cc5cda9d1e23a3ea7fbc\" alt=\"Powered by osTicket\" width=\"126\" height=\"19\" style=\"width:126px\" />',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(17,1,'task.assignment.alert','Task Assigned to you','<h3><strong>Hi %{assignee.name.first},</strong></h3> Task <a href=\"%%7Btask.staff_link%7D\">#%{task.number}</a> has been assigned to you by %{assigner.name.short} <br /> <br /> %{comments} <br /> <br /> <hr /> <div>To view/respond to the task, please <a href=\"%%7Btask.staff_link%7D\"><span style=\"color:rgb(84, 141, 212)\">login</span></a> to the support system</div> <em style=\"font-size:small\">Your friendly Customer Support System</em> <br /> <img src=\"cid:b56944cb4722cc5cda9d1e23a3ea7fbc\" alt=\"Powered by osTicket\" width=\"126\" height=\"19\" style=\"width:126px\" />',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(18,1,'task.transfer.alert','Task #%{task.number} transfer - %{task.dept.name}','<h3>Hi %{recipient.name},</h3> Task <a href=\"%%7Btask.staff_link%7D\">#%{task.number}</a> has been transferred to the %{task.dept.name} department by <strong>%{staff.name.short}</strong> <br /> <br /> <blockquote>%{comments} </blockquote> <hr /> <div>To view or respond to the task, please <a href=\"%%7Btask.staff_link%7D\">login</a> to the support system. </div> <em style=\"font-size:small\">Your friendly Customer Support System</em> <br /> <a href=\"https://osticket.com/\"><img width=\"126\" height=\"19\" alt=\"Powered By osTicket\" style=\"width:126px\" src=\"cid:b56944cb4722cc5cda9d1e23a3ea7fbc\" /></a>',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(19,1,'task.overdue.alert','Stale Task Alert','<h3><strong>Hi %{recipient.name}</strong>,</h3> A task, <a href=\"%%7Btask.staff_link%7D\">#%{task.number}</a> is seriously overdue. <br /> <br /> We should all work hard to guarantee that all tasks are being addressed in a timely manner. <br /> <br /> Signed,<br /> %{task.dept.manager.name} <hr /> <div>To view or respond to the task, please <a href=\"%%7Btask.staff_link%7D\"><span style=\"color:rgb(84, 141, 212)\">login</span></a> to the support system. You\'re receiving this notice because the task is assigned directly to you or to a team or department of which you\'re a member.</div> <em style=\"font-size:small\">Your friendly <span style=\"font-size:smaller\">(although with limited patience)</span> Customer Support System</em><br /> <img src=\"cid:b56944cb4722cc5cda9d1e23a3ea7fbc\" height=\"19\" alt=\"Powered by osTicket\" width=\"126\" style=\"width:126px\" />',NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04');
/*!40000 ALTER TABLE `ost_email_template` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_email_template_group`
--

DROP TABLE IF EXISTS `ost_email_template_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_email_template_group` (
  `tpl_id` int(11) NOT NULL AUTO_INCREMENT,
  `isactive` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `name` varchar(32) NOT NULL DEFAULT '',
  `lang` varchar(16) NOT NULL DEFAULT 'en_US',
  `notes` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` timestamp NOT NULL,
  PRIMARY KEY (`tpl_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_email_template_group`
--

LOCK TABLES `ost_email_template_group` WRITE;
/*!40000 ALTER TABLE `ost_email_template_group` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_email_template_group` VALUES
(1,1,'osTicket Default Template (HTML)','en_US','Default osTicket templates','2026-02-19 18:15:04','2026-02-19 17:15:04');
/*!40000 ALTER TABLE `ost_email_template_group` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_event`
--

DROP TABLE IF EXISTS `ost_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_event` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `description` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_event`
--

LOCK TABLES `ost_event` WRITE;
/*!40000 ALTER TABLE `ost_event` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_event` VALUES
(1,'created',NULL),
(2,'closed',NULL),
(3,'reopened',NULL),
(4,'assigned',NULL),
(5,'released',NULL),
(6,'transferred',NULL),
(7,'referred',NULL),
(8,'overdue',NULL),
(9,'edited',NULL),
(10,'viewed',NULL),
(11,'error',NULL),
(12,'collab',NULL),
(13,'resent',NULL),
(14,'deleted',NULL),
(15,'merged',NULL),
(16,'unlinked',NULL),
(17,'linked',NULL),
(18,'login',NULL),
(19,'logout',NULL),
(20,'message',NULL),
(21,'note',NULL);
/*!40000 ALTER TABLE `ost_event` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_faq`
--

DROP TABLE IF EXISTS `ost_faq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_faq` (
  `faq_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned NOT NULL DEFAULT 0,
  `ispublished` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `question` varchar(255) NOT NULL,
  `answer` text NOT NULL,
  `keywords` tinytext DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`faq_id`),
  UNIQUE KEY `question` (`question`),
  KEY `category_id` (`category_id`),
  KEY `ispublished` (`ispublished`)
) ENGINE=InnoDB AUTO_INCREMENT=373 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_faq`
--

LOCK TABLES `ost_faq` WRITE;
/*!40000 ALTER TABLE `ost_faq` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_faq` VALUES
(1,1,1,'Outlook startet nicht â€“ Profil reparieren / neu erstellen','<p><b>Symptom:</b> Outlook Ã¶ffnet sich nicht oder bleibt beim Laden hÃ¤ngen.</p><ol><li>Outlook schlieÃŸen (auch im Task-Manager prÃ¼fen).</li><li>Systemsteuerung â†’ <i>Mail</i> â†’ <i>Profile anzeigen</i>.</li><li>Neues Profil anlegen und als Standard setzen.</li><li>Outlook starten, Konto erneut verbinden.</li><li>Wenn Add-ins vermutet: Outlook im abgesicherten Modus starten (outlook.exe /safe) und Add-ins deaktivieren.</li></ol><p><b>Hinweis:</b> Bei Exchange/365 werden Postfachdaten neu synchronisiert.</p>','outlook,profil,startet nicht,office','seed_osticket_kb.py','2026-02-19 18:01:40','2026-02-19 18:04:41'),
(2,2,1,'Benutzerkonto gesperrt (AD/Azure AD) â€“ Entsperren und Ursache prÃ¼fen','<p><b>Symptom:</b> Anmeldung nicht mÃ¶glich, Konto gesperrt.</p><ol><li>AD: Benutzer entsperren (ADUC) / Entra: Sign-in Logs prÃ¼fen.</li><li>Letzte Fehlversuche und Quelle identifizieren (z.B. altes Handy, gespeicherte Credentials, Outlook/Teams).</li><li>Passwort ggf. zurÃ¼cksetzen und alte Anmeldedaten auf EndgerÃ¤ten entfernen.</li><li>Falls wiederkehrend: betroffene Dienste (VPN, WLAN, Mail) nacheinander testen.</li></ol>','konto gesperrt,ad,azure ad,lockout','seed_osticket_kb.py','2026-02-19 18:01:40','2026-02-19 18:04:41'),
(4,4,1,'Windows Update hÃ¤ngt bei 0% / 100% â€“ Standard-Reparatur','<p><b>Kurzanleitung:</b></p><ol><li>Neustart durchfÃ¼hren.</li><li>Genug freien Speicher prÃ¼fen (&gt;10 GB).</li><li>Windows Update Problembehandlung ausfÃ¼hren.</li><li>Optional: Update-Cache zurÃ¼cksetzen (wuauserv/bits stoppen, SoftwareDistribution leeren, Dienste starten).</li><li>Erneut nach Updates suchen.</li></ol>','windows update,hÃ¤ngt,0%,100%,repair','seed_osticket_kb.py','2026-02-19 18:01:40','2026-02-19 18:04:41'),
(5,5,1,'Kein Zugriff auf Netzlaufwerk / SMB Share â€“ Checkliste','<ol><li>VPN/Netzverbindung prÃ¼fen (Ping auf Fileserver).</li><li>DNS-AuflÃ¶sung testen (nslookup).</li><li>Anmeldedaten/gespeicherte Credentials entfernen und neu verbinden.</li><li>Berechtigungen prÃ¼fen (Share + NTFS).</li><li>Falls nÃ¶tig: Laufwerk trennen und neu mappen.</li></ol>','netzlaufwerk,smb,share,zugriff,berechtigung','seed_osticket_kb.py','2026-02-19 18:01:40','2026-02-19 18:04:41'),
(6,6,1,'Drucker \'Offline\' â€“ schnelle MaÃŸnahmen','<ol><li>Strom/Netzwerk prÃ¼fen, Testseite am GerÃ¤t.</li><li>Windows: Druckwarteschlange leeren.</li><li>Druckdienst (Spooler) neu starten.</li><li>Treiber/Port prÃ¼fen (TCP/IP, WSD vermeiden wenn mÃ¶glich).</li><li>Optional: Drucker neu hinzufÃ¼gen.</li></ol>','drucker,offline,spooler,treiber','seed_osticket_kb.py','2026-02-19 18:01:40','2026-02-19 18:04:41'),
(8,8,1,'VPN verbindet nicht â€“ typische Ursachen','<ol><li>Internetverbindung testen, Uhrzeit/Datum prÃ¼fen.</li><li>2FA/MFA Status prÃ¼fen (Push/OTP).</li><li>Client-Logs prÃ¼fen (Fehlercode).</li><li>Zertifikat/Profil gÃ¼ltig?</li><li>Fallback: anderes Netzwerk testen (Hotspot).</li></ol>','vpn,verbindung,client,cert,2fa','seed_osticket_kb.py','2026-02-19 18:01:40','2026-02-19 18:04:41'),
(9,9,1,'Teams: Mikrofon/Kamera funktioniert nicht â€“ Troubleshooting','<ol><li>Windows Datenschutz: Mikrofon/Kamera fÃ¼r Teams erlauben.</li><li>Teams GerÃ¤te-Einstellungen prÃ¼fen (richtige Ein-/Ausgabe).</li><li>Andere Apps schlieÃŸen (Zoom, Browser).</li><li>Treiber/Firmware aktualisieren, Neustart.</li><li>Testanruf in Teams durchfÃ¼hren.</li></ol>','teams,mikrofon,kamera,audio,permissions','seed_osticket_kb.py','2026-02-19 18:01:40','2026-02-19 18:04:41'),
(10,1,1,'OneDrive synchronisiert nicht â€“ StandardlÃ¶sung','<ol><li>Statussymbol prÃ¼fen (Pause/Fehler).</li><li>Ab- und Anmelden in OneDrive.</li><li>OneDrive Reset (onedrive.exe /reset) und neu starten.</li><li>Konflikte/Dateipfade (&lt; 260 Zeichen) prÃ¼fen.</li><li>Storage-Quota prÃ¼fen.</li></ol>','onedrive,sync,cache,reset','seed_osticket_kb.py','2026-02-19 18:01:40','2026-02-19 18:04:41'),
(11,10,1,'BitLocker WiederherstellungsschlÃ¼ssel erforderlich â€“ Vorgehen','<ol><li>Recovery Key aus Entra/AD oder Microsoft Account abrufen (je nach Setup).</li><li>Ursache prÃ¼fen: BIOS/TPM Ã„nderung, Secure Boot, Firmware Update.</li><li>Nach erfolgreichem Boot: BitLocker Status prÃ¼fen und ggf. Schutz aus-/einschalten.</li></ol>','bitlocker,recovery key,verschlÃ¼sselung','seed_osticket_kb.py','2026-02-19 18:01:40','2026-02-19 18:04:41'),
(12,11,1,'Serverplatte voll â€“ SofortmaÃŸnahmen & PrÃ¤vention','<ol><li>GrÃ¶ÃŸte Verzeichnisse identifizieren (Logs, Temp, Dumps).</li><li>Alte Logs rotieren/komprimieren.</li><li>Windows: DatentrÃ¤gerbereinigung, WinSxS prÃ¼fen.</li><li>Monitoring/Alerts konfigurieren (Thresholds).</li></ol>','disk full,server,cleanup,logs,temp','seed_osticket_kb.py','2026-02-19 18:01:40','2026-02-19 18:04:41'),
(13,12,1,'DEMO MASS - Endpoint Management: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---endpoint-management','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(14,12,1,'DEMO MASS - Endpoint Management: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---endpoint-management','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(15,12,1,'DEMO MASS - Endpoint Management: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---endpoint-management','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(16,12,1,'DEMO MASS - Endpoint Management: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---endpoint-management','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(17,13,1,'DEMO MASS - Identity Access: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---identity-access','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(18,13,1,'DEMO MASS - Identity Access: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---identity-access','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(19,13,1,'DEMO MASS - Identity Access: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---identity-access','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(20,13,1,'DEMO MASS - Identity Access: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---identity-access','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(21,14,1,'DEMO MASS - Windows Clients: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---windows-clients','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(22,14,1,'DEMO MASS - Windows Clients: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---windows-clients','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(23,14,1,'DEMO MASS - Windows Clients: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---windows-clients','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(24,14,1,'DEMO MASS - Windows Clients: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---windows-clients','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(25,15,1,'DEMO MASS - Network Operations: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---network-operations','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(26,15,1,'DEMO MASS - Network Operations: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---network-operations','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(27,15,1,'DEMO MASS - Network Operations: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---network-operations','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(28,15,1,'DEMO MASS - Network Operations: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---network-operations','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(29,16,1,'DEMO MASS - Printer Services: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---printer-services','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(30,16,1,'DEMO MASS - Printer Services: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---printer-services','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(31,16,1,'DEMO MASS - Printer Services: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---printer-services','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(32,16,1,'DEMO MASS - Printer Services: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---printer-services','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(33,17,1,'DEMO MASS - VPN Remote: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---vpn-remote','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(34,17,1,'DEMO MASS - VPN Remote: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---vpn-remote','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(35,17,1,'DEMO MASS - VPN Remote: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---vpn-remote','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(36,17,1,'DEMO MASS - VPN Remote: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---vpn-remote','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(37,18,1,'DEMO MASS - Collaboration: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---collaboration','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(38,18,1,'DEMO MASS - Collaboration: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---collaboration','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(39,18,1,'DEMO MASS - Collaboration: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---collaboration','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(40,18,1,'DEMO MASS - Collaboration: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---collaboration','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(41,19,1,'DEMO MASS - Mail Flow: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---mail-flow','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(42,19,1,'DEMO MASS - Mail Flow: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---mail-flow','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(43,19,1,'DEMO MASS - Mail Flow: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---mail-flow','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(44,19,1,'DEMO MASS - Mail Flow: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---mail-flow','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(45,20,1,'DEMO MASS - Backup Restore: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---backup-restore','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(46,20,1,'DEMO MASS - Backup Restore: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---backup-restore','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(47,20,1,'DEMO MASS - Backup Restore: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---backup-restore','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(48,20,1,'DEMO MASS - Backup Restore: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---backup-restore','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(49,21,1,'DEMO MASS - Server Storage: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---server-storage','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(50,21,1,'DEMO MASS - Server Storage: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---server-storage','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(51,21,1,'DEMO MASS - Server Storage: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---server-storage','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(52,21,1,'DEMO MASS - Server Storage: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---server-storage','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(53,22,1,'DEMO MASS - Virtualization: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---virtualization','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(54,22,1,'DEMO MASS - Virtualization: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---virtualization','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(55,22,1,'DEMO MASS - Virtualization: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---virtualization','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(56,22,1,'DEMO MASS - Virtualization: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---virtualization','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(57,23,1,'DEMO MASS - DNS DHCP: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---dns-dhcp','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(58,23,1,'DEMO MASS - DNS DHCP: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---dns-dhcp','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(59,23,1,'DEMO MASS - DNS DHCP: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---dns-dhcp','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(60,23,1,'DEMO MASS - DNS DHCP: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---dns-dhcp','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(61,24,1,'DEMO MASS - WiFi NAC: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---wifi-nac','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(62,24,1,'DEMO MASS - WiFi NAC: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---wifi-nac','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(63,24,1,'DEMO MASS - WiFi NAC: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---wifi-nac','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(64,24,1,'DEMO MASS - WiFi NAC: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---wifi-nac','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(65,25,1,'DEMO MASS - Security Endpoint: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---security-endpoint','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(66,25,1,'DEMO MASS - Security Endpoint: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---security-endpoint','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(67,25,1,'DEMO MASS - Security Endpoint: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---security-endpoint','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(68,25,1,'DEMO MASS - Security Endpoint: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---security-endpoint','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(69,26,1,'DEMO MASS - Patch Management: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---patch-management','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(70,26,1,'DEMO MASS - Patch Management: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---patch-management','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(71,26,1,'DEMO MASS - Patch Management: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---patch-management','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(72,26,1,'DEMO MASS - Patch Management: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---patch-management','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(73,27,1,'DEMO MASS - Monitoring Alerts: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---monitoring-alerts','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(74,27,1,'DEMO MASS - Monitoring Alerts: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---monitoring-alerts','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(75,27,1,'DEMO MASS - Monitoring Alerts: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---monitoring-alerts','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(76,27,1,'DEMO MASS - Monitoring Alerts: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---monitoring-alerts','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(77,28,1,'DEMO MASS - Browser Webapps: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---browser-webapps','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(78,28,1,'DEMO MASS - Browser Webapps: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---browser-webapps','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(79,28,1,'DEMO MASS - Browser Webapps: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---browser-webapps','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(80,28,1,'DEMO MASS - Browser Webapps: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---browser-webapps','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(81,29,1,'DEMO MASS - Mobile Device: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---mobile-device','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(82,29,1,'DEMO MASS - Mobile Device: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---mobile-device','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(83,29,1,'DEMO MASS - Mobile Device: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---mobile-device','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(84,29,1,'DEMO MASS - Mobile Device: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---mobile-device','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(85,30,1,'DEMO MASS - Certificates PKI: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---certificates-pki','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(86,30,1,'DEMO MASS - Certificates PKI: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---certificates-pki','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(87,30,1,'DEMO MASS - Certificates PKI: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---certificates-pki','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(88,30,1,'DEMO MASS - Certificates PKI: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---certificates-pki','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(89,31,1,'DEMO MASS - File Services: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---file-services','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(90,31,1,'DEMO MASS - File Services: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---file-services','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(91,31,1,'DEMO MASS - File Services: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---file-services','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(92,31,1,'DEMO MASS - File Services: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---file-services','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(93,32,1,'DEMO MASS - ERP CRM Clients: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---erp-crm-clients','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(94,32,1,'DEMO MASS - ERP CRM Clients: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---erp-crm-clients','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(95,32,1,'DEMO MASS - ERP CRM Clients: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---erp-crm-clients','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(96,32,1,'DEMO MASS - ERP CRM Clients: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---erp-crm-clients','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(97,33,1,'DEMO MASS - Database Clients: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---database-clients','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(98,33,1,'DEMO MASS - Database Clients: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---database-clients','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(99,33,1,'DEMO MASS - Database Clients: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---database-clients','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(100,33,1,'DEMO MASS - Database Clients: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---database-clients','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(101,34,1,'DEMO MASS - Remote Desktop: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---remote-desktop','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(102,34,1,'DEMO MASS - Remote Desktop: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---remote-desktop','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(103,34,1,'DEMO MASS - Remote Desktop: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---remote-desktop','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(104,34,1,'DEMO MASS - Remote Desktop: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---remote-desktop','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(105,35,1,'DEMO MASS - IAM SSO: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---iam-sso','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(106,35,1,'DEMO MASS - IAM SSO: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---iam-sso','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(107,35,1,'DEMO MASS - IAM SSO: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---iam-sso','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(108,35,1,'DEMO MASS - IAM SSO: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---iam-sso','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(109,36,1,'DEMO MASS - M365 Platform: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---m365-platform','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(110,36,1,'DEMO MASS - M365 Platform: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---m365-platform','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(111,36,1,'DEMO MASS - M365 Platform: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---m365-platform','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(112,36,1,'DEMO MASS - M365 Platform: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---m365-platform','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(113,37,1,'DEMO MASS - Teams Voice: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---teams-voice','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(114,37,1,'DEMO MASS - Teams Voice: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---teams-voice','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(115,37,1,'DEMO MASS - Teams Voice: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---teams-voice','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(116,37,1,'DEMO MASS - Teams Voice: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---teams-voice','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(117,38,1,'DEMO MASS - Linux Clients: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---linux-clients','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(118,38,1,'DEMO MASS - Linux Clients: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---linux-clients','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(119,38,1,'DEMO MASS - Linux Clients: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---linux-clients','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(120,38,1,'DEMO MASS - Linux Clients: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---linux-clients','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(121,39,1,'DEMO MASS - Mac Clients: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---mac-clients','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(122,39,1,'DEMO MASS - Mac Clients: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---mac-clients','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(123,39,1,'DEMO MASS - Mac Clients: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---mac-clients','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(124,39,1,'DEMO MASS - Mac Clients: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---mac-clients','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(125,40,1,'DEMO MASS - Service Desk: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---service-desk','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(126,40,1,'DEMO MASS - Service Desk: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---service-desk','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(127,40,1,'DEMO MASS - Service Desk: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---service-desk','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(128,40,1,'DEMO MASS - Service Desk: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---service-desk','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(129,41,1,'DEMO MASS - Compliance Audit: Anmeldung fehlgeschlagen - Erstdiagnose','<p><b>Symptom:</b> Anmeldung am Dienst oder Client nicht moeglich.</p><ol><li>Benutzername und UPN pruefen.</li><li>Uhrzeit und Zeitsynchronisation kontrollieren.</li><li>Netzwerkpfad und DNS-Aufloesung pruefen.</li><li>Konto-Sperre und MFA-Status kontrollieren.</li><li>Erneut anmelden und Ergebnis dokumentieren.</li></ol>','demo,login,anmeldung,auth,diagnose,demo-mass---compliance-audit','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(130,41,1,'DEMO MASS - Compliance Audit: Client reagiert sehr langsam - Standardanalyse','<p><b>Symptom:</b> Anwendungen reagieren verzoegert.</p><ol><li>CPU, RAM und Datentraeger-Auslastung messen.</li><li>Autostarts und Hintergrundprozesse bewerten.</li><li>Aktuelle Updates und Treiberstand pruefen.</li><li>Temporare Dateien bereinigen.</li><li>Nach Neustart erneut benchmarken.</li></ol>','demo,performance,langsam,client,analyse,demo-mass---compliance-audit','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(131,41,1,'DEMO MASS - Compliance Audit: Dienst nicht erreichbar - Verbindungscheck','<p><b>Symptom:</b> Service antwortet nicht oder Timeout.</p><ol><li>Ping/Traceroute auf Ziel pruefen.</li><li>DNS-Eintrag und Zieladresse validieren.</li><li>Firewall-Regeln und Portfreigaben kontrollieren.</li><li>Service-Status auf Zielsystem pruefen.</li><li>Connectivity-Test protokollieren.</li></ol>','demo,dienst,nicht erreichbar,netzwerk,check,demo-mass---compliance-audit','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(132,41,1,'DEMO MASS - Compliance Audit: Fehler nach Update - Recovery Ablauf','<p><b>Symptom:</b> Problem trat nach einem Update auf.</p><ol><li>Zeitpunkt und Update-KB/Paket identifizieren.</li><li>Ereignisprotokolle auf Fehlermeldungen pruefen.</li><li>Betroffene Komponente isoliert testen.</li><li>Falls erforderlich Rollback gem. Change-Prozess ausfuehren.</li><li>Stabilen Zustand verifizieren und Ursache dokumentieren.</li></ol>','demo,update,fehler,recovery,rollback,demo-mass---compliance-audit','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(133,42,1,'DEMO XL - Endpoint Security: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---endpoint-security','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(134,42,1,'DEMO XL - Endpoint Security: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---endpoint-security','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(135,42,1,'DEMO XL - Endpoint Security: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---endpoint-security','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(136,42,1,'DEMO XL - Endpoint Security: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---endpoint-security','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(137,43,1,'DEMO XL - Endpoint Compliance: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---endpoint-compliance','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(138,43,1,'DEMO XL - Endpoint Compliance: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---endpoint-compliance','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(139,43,1,'DEMO XL - Endpoint Compliance: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---endpoint-compliance','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(140,43,1,'DEMO XL - Endpoint Compliance: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---endpoint-compliance','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(141,44,1,'DEMO XL - Entra Identity: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---entra-identity','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(142,44,1,'DEMO XL - Entra Identity: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---entra-identity','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(143,44,1,'DEMO XL - Entra Identity: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---entra-identity','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(144,44,1,'DEMO XL - Entra Identity: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---entra-identity','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(145,45,1,'DEMO XL - Active Directory: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---active-directory','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(146,45,1,'DEMO XL - Active Directory: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---active-directory','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(147,45,1,'DEMO XL - Active Directory: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---active-directory','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(148,45,1,'DEMO XL - Active Directory: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---active-directory','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(149,46,1,'DEMO XL - Password Policy: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---password-policy','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(150,46,1,'DEMO XL - Password Policy: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---password-policy','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(151,46,1,'DEMO XL - Password Policy: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---password-policy','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(152,46,1,'DEMO XL - Password Policy: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---password-policy','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(153,47,1,'DEMO XL - Privileged Access: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---privileged-access','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(154,47,1,'DEMO XL - Privileged Access: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---privileged-access','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(155,47,1,'DEMO XL - Privileged Access: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---privileged-access','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(156,47,1,'DEMO XL - Privileged Access: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---privileged-access','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(157,48,1,'DEMO XL - Windows Deployment: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---windows-deployment','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(158,48,1,'DEMO XL - Windows Deployment: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---windows-deployment','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(159,48,1,'DEMO XL - Windows Deployment: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---windows-deployment','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(160,48,1,'DEMO XL - Windows Deployment: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---windows-deployment','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(161,49,1,'DEMO XL - Windows Performance: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---windows-performance','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(162,49,1,'DEMO XL - Windows Performance: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---windows-performance','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(163,49,1,'DEMO XL - Windows Performance: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---windows-performance','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(164,49,1,'DEMO XL - Windows Performance: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---windows-performance','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(165,50,1,'DEMO XL - Windows Printing: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---windows-printing','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(166,50,1,'DEMO XL - Windows Printing: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---windows-printing','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(167,50,1,'DEMO XL - Windows Printing: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---windows-printing','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(168,50,1,'DEMO XL - Windows Printing: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---windows-printing','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(169,51,1,'DEMO XL - Windows Networking: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---windows-networking','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(170,51,1,'DEMO XL - Windows Networking: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---windows-networking','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(171,51,1,'DEMO XL - Windows Networking: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---windows-networking','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(172,51,1,'DEMO XL - Windows Networking: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---windows-networking','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(173,52,1,'DEMO XL - DNS Operations: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---dns-operations','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(174,52,1,'DEMO XL - DNS Operations: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---dns-operations','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(175,52,1,'DEMO XL - DNS Operations: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---dns-operations','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(176,52,1,'DEMO XL - DNS Operations: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---dns-operations','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(177,53,1,'DEMO XL - DHCP Operations: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---dhcp-operations','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(178,53,1,'DEMO XL - DHCP Operations: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---dhcp-operations','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(179,53,1,'DEMO XL - DHCP Operations: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---dhcp-operations','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(180,53,1,'DEMO XL - DHCP Operations: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---dhcp-operations','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(181,54,1,'DEMO XL - VPN Operations: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---vpn-operations','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(182,54,1,'DEMO XL - VPN Operations: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---vpn-operations','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(183,54,1,'DEMO XL - VPN Operations: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---vpn-operations','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(184,54,1,'DEMO XL - VPN Operations: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---vpn-operations','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(185,55,1,'DEMO XL - Firewall Rules: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---firewall-rules','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(186,55,1,'DEMO XL - Firewall Rules: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---firewall-rules','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(187,55,1,'DEMO XL - Firewall Rules: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---firewall-rules','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(188,55,1,'DEMO XL - Firewall Rules: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---firewall-rules','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(189,56,1,'DEMO XL - Proxy Web: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---proxy-web','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(190,56,1,'DEMO XL - Proxy Web: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---proxy-web','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(191,56,1,'DEMO XL - Proxy Web: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---proxy-web','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(192,56,1,'DEMO XL - Proxy Web: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---proxy-web','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(193,57,1,'DEMO XL - Microsoft 365 Apps: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---microsoft-365-apps','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(194,57,1,'DEMO XL - Microsoft 365 Apps: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---microsoft-365-apps','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(195,57,1,'DEMO XL - Microsoft 365 Apps: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---microsoft-365-apps','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(196,57,1,'DEMO XL - Microsoft 365 Apps: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---microsoft-365-apps','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(197,58,1,'DEMO XL - Exchange Online: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---exchange-online','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(198,58,1,'DEMO XL - Exchange Online: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---exchange-online','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(199,58,1,'DEMO XL - Exchange Online: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---exchange-online','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(200,58,1,'DEMO XL - Exchange Online: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---exchange-online','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(201,59,1,'DEMO XL - SharePoint Online: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---sharepoint-online','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(202,59,1,'DEMO XL - SharePoint Online: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---sharepoint-online','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(203,59,1,'DEMO XL - SharePoint Online: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---sharepoint-online','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(204,59,1,'DEMO XL - SharePoint Online: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---sharepoint-online','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(205,60,1,'DEMO XL - OneDrive Operations: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---onedrive-operations','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(206,60,1,'DEMO XL - OneDrive Operations: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---onedrive-operations','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(207,60,1,'DEMO XL - OneDrive Operations: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---onedrive-operations','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(208,60,1,'DEMO XL - OneDrive Operations: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---onedrive-operations','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(209,61,1,'DEMO XL - Teams Collaboration: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---teams-collaboration','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(210,61,1,'DEMO XL - Teams Collaboration: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---teams-collaboration','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(211,61,1,'DEMO XL - Teams Collaboration: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---teams-collaboration','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(212,61,1,'DEMO XL - Teams Collaboration: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---teams-collaboration','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(213,62,1,'DEMO XL - Teams Meetings: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---teams-meetings','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(214,62,1,'DEMO XL - Teams Meetings: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---teams-meetings','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(215,62,1,'DEMO XL - Teams Meetings: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---teams-meetings','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(216,62,1,'DEMO XL - Teams Meetings: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---teams-meetings','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(217,63,1,'DEMO XL - Teams Voice: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---teams-voice','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(218,63,1,'DEMO XL - Teams Voice: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---teams-voice','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(219,63,1,'DEMO XL - Teams Voice: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---teams-voice','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(220,63,1,'DEMO XL - Teams Voice: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---teams-voice','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(221,64,1,'DEMO XL - Mail Security: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---mail-security','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(222,64,1,'DEMO XL - Mail Security: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---mail-security','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(223,64,1,'DEMO XL - Mail Security: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---mail-security','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(224,64,1,'DEMO XL - Mail Security: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---mail-security','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(225,65,1,'DEMO XL - SPF DKIM DMARC: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---spf-dkim-dmarc','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(226,65,1,'DEMO XL - SPF DKIM DMARC: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---spf-dkim-dmarc','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(227,65,1,'DEMO XL - SPF DKIM DMARC: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---spf-dkim-dmarc','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(228,65,1,'DEMO XL - SPF DKIM DMARC: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---spf-dkim-dmarc','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(229,66,1,'DEMO XL - Backup Policy: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---backup-policy','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(230,66,1,'DEMO XL - Backup Policy: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---backup-policy','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(231,66,1,'DEMO XL - Backup Policy: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---backup-policy','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(232,66,1,'DEMO XL - Backup Policy: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---backup-policy','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(233,67,1,'DEMO XL - Backup Restore: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---backup-restore','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(234,67,1,'DEMO XL - Backup Restore: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---backup-restore','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(235,67,1,'DEMO XL - Backup Restore: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---backup-restore','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(236,67,1,'DEMO XL - Backup Restore: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---backup-restore','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(237,68,1,'DEMO XL - Storage Capacity: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---storage-capacity','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(238,68,1,'DEMO XL - Storage Capacity: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---storage-capacity','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(239,68,1,'DEMO XL - Storage Capacity: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---storage-capacity','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(240,68,1,'DEMO XL - Storage Capacity: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---storage-capacity','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(241,69,1,'DEMO XL - VMware Operations: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---vmware-operations','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(242,69,1,'DEMO XL - VMware Operations: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---vmware-operations','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(243,69,1,'DEMO XL - VMware Operations: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---vmware-operations','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(244,69,1,'DEMO XL - VMware Operations: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---vmware-operations','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(245,70,1,'DEMO XL - HyperV Operations: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---hyperv-operations','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(246,70,1,'DEMO XL - HyperV Operations: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---hyperv-operations','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(247,70,1,'DEMO XL - HyperV Operations: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---hyperv-operations','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(248,70,1,'DEMO XL - HyperV Operations: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---hyperv-operations','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(249,71,1,'DEMO XL - Linux Server: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---linux-server','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(250,71,1,'DEMO XL - Linux Server: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---linux-server','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(251,71,1,'DEMO XL - Linux Server: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---linux-server','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(252,71,1,'DEMO XL - Linux Server: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---linux-server','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(253,72,1,'DEMO XL - Linux Client: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---linux-client','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(254,72,1,'DEMO XL - Linux Client: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---linux-client','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(255,72,1,'DEMO XL - Linux Client: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---linux-client','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(256,72,1,'DEMO XL - Linux Client: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---linux-client','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(257,73,1,'DEMO XL - Mac Client: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---mac-client','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(258,73,1,'DEMO XL - Mac Client: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---mac-client','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(259,73,1,'DEMO XL - Mac Client: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---mac-client','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(260,73,1,'DEMO XL - Mac Client: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---mac-client','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(261,74,1,'DEMO XL - WLAN Enterprise: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---wlan-enterprise','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(262,74,1,'DEMO XL - WLAN Enterprise: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---wlan-enterprise','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(263,74,1,'DEMO XL - WLAN Enterprise: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---wlan-enterprise','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(264,74,1,'DEMO XL - WLAN Enterprise: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---wlan-enterprise','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(265,75,1,'DEMO XL - NAC Authentication: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---nac-authentication','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(266,75,1,'DEMO XL - NAC Authentication: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---nac-authentication','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(267,75,1,'DEMO XL - NAC Authentication: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---nac-authentication','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(268,75,1,'DEMO XL - NAC Authentication: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---nac-authentication','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(269,76,1,'DEMO XL - PKI Certificates: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---pki-certificates','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(270,76,1,'DEMO XL - PKI Certificates: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---pki-certificates','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(271,76,1,'DEMO XL - PKI Certificates: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---pki-certificates','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(272,76,1,'DEMO XL - PKI Certificates: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---pki-certificates','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(273,77,1,'DEMO XL - TLS Services: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---tls-services','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(274,77,1,'DEMO XL - TLS Services: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---tls-services','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(275,77,1,'DEMO XL - TLS Services: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---tls-services','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(276,77,1,'DEMO XL - TLS Services: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---tls-services','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(277,78,1,'DEMO XL - Web Applications: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---web-applications','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(278,78,1,'DEMO XL - Web Applications: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---web-applications','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(279,78,1,'DEMO XL - Web Applications: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---web-applications','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(280,78,1,'DEMO XL - Web Applications: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---web-applications','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(281,79,1,'DEMO XL - Browser Support: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---browser-support','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(282,79,1,'DEMO XL - Browser Support: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---browser-support','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(283,79,1,'DEMO XL - Browser Support: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---browser-support','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(284,79,1,'DEMO XL - Browser Support: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---browser-support','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(285,80,1,'DEMO XL - Database Access: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---database-access','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(286,80,1,'DEMO XL - Database Access: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---database-access','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(287,80,1,'DEMO XL - Database Access: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---database-access','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(288,80,1,'DEMO XL - Database Access: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---database-access','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(289,81,1,'DEMO XL - SQL Client: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---sql-client','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(290,81,1,'DEMO XL - SQL Client: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---sql-client','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(291,81,1,'DEMO XL - SQL Client: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---sql-client','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(292,81,1,'DEMO XL - SQL Client: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---sql-client','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(293,82,1,'DEMO XL - RDP Services: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---rdp-services','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(294,82,1,'DEMO XL - RDP Services: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---rdp-services','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(295,82,1,'DEMO XL - RDP Services: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---rdp-services','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(296,82,1,'DEMO XL - RDP Services: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---rdp-services','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(297,83,1,'DEMO XL - Remote Support: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---remote-support','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(298,83,1,'DEMO XL - Remote Support: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---remote-support','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(299,83,1,'DEMO XL - Remote Support: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---remote-support','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(300,83,1,'DEMO XL - Remote Support: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---remote-support','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(301,84,1,'DEMO XL - Monitoring Alerts: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---monitoring-alerts','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(302,84,1,'DEMO XL - Monitoring Alerts: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---monitoring-alerts','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(303,84,1,'DEMO XL - Monitoring Alerts: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---monitoring-alerts','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(304,84,1,'DEMO XL - Monitoring Alerts: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---monitoring-alerts','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(305,85,1,'DEMO XL - Log Management: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---log-management','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(306,85,1,'DEMO XL - Log Management: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---log-management','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(307,85,1,'DEMO XL - Log Management: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---log-management','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(308,85,1,'DEMO XL - Log Management: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---log-management','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(309,86,1,'DEMO XL - SIEM Integration: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---siem-integration','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(310,86,1,'DEMO XL - SIEM Integration: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---siem-integration','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(311,86,1,'DEMO XL - SIEM Integration: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---siem-integration','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(312,86,1,'DEMO XL - SIEM Integration: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---siem-integration','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(313,87,1,'DEMO XL - MDM Devices: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---mdm-devices','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(314,87,1,'DEMO XL - MDM Devices: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---mdm-devices','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(315,87,1,'DEMO XL - MDM Devices: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---mdm-devices','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(316,87,1,'DEMO XL - MDM Devices: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---mdm-devices','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(317,88,1,'DEMO XL - Mobile Apps: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---mobile-apps','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(318,88,1,'DEMO XL - Mobile Apps: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---mobile-apps','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(319,88,1,'DEMO XL - Mobile Apps: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---mobile-apps','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(320,88,1,'DEMO XL - Mobile Apps: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---mobile-apps','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(321,89,1,'DEMO XL - Intune Policies: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---intune-policies','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(322,89,1,'DEMO XL - Intune Policies: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---intune-policies','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(323,89,1,'DEMO XL - Intune Policies: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---intune-policies','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(324,89,1,'DEMO XL - Intune Policies: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---intune-policies','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(325,90,1,'DEMO XL - Patch Rollout: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---patch-rollout','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(326,90,1,'DEMO XL - Patch Rollout: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---patch-rollout','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(327,90,1,'DEMO XL - Patch Rollout: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---patch-rollout','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(328,90,1,'DEMO XL - Patch Rollout: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---patch-rollout','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(329,91,1,'DEMO XL - Vulnerability Mgmt: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---vulnerability-mgmt','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(330,91,1,'DEMO XL - Vulnerability Mgmt: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---vulnerability-mgmt','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(331,91,1,'DEMO XL - Vulnerability Mgmt: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---vulnerability-mgmt','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(332,91,1,'DEMO XL - Vulnerability Mgmt: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---vulnerability-mgmt','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(333,92,1,'DEMO XL - Service Desk L1: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---service-desk-l1','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(334,92,1,'DEMO XL - Service Desk L1: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---service-desk-l1','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(335,92,1,'DEMO XL - Service Desk L1: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---service-desk-l1','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(336,92,1,'DEMO XL - Service Desk L1: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---service-desk-l1','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(337,93,1,'DEMO XL - Service Desk L2: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---service-desk-l2','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(338,93,1,'DEMO XL - Service Desk L2: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---service-desk-l2','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(339,93,1,'DEMO XL - Service Desk L2: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---service-desk-l2','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(340,93,1,'DEMO XL - Service Desk L2: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---service-desk-l2','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(341,94,1,'DEMO XL - Incident Process: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---incident-process','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(342,94,1,'DEMO XL - Incident Process: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---incident-process','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(343,94,1,'DEMO XL - Incident Process: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---incident-process','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(344,94,1,'DEMO XL - Incident Process: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---incident-process','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(345,95,1,'DEMO XL - Problem Management: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---problem-management','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(346,95,1,'DEMO XL - Problem Management: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---problem-management','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(347,95,1,'DEMO XL - Problem Management: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---problem-management','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(348,95,1,'DEMO XL - Problem Management: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---problem-management','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(349,96,1,'DEMO XL - Change Management: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---change-management','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(350,96,1,'DEMO XL - Change Management: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---change-management','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(351,96,1,'DEMO XL - Change Management: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---change-management','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(352,96,1,'DEMO XL - Change Management: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---change-management','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(353,97,1,'DEMO XL - Asset Inventory: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---asset-inventory','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(354,97,1,'DEMO XL - Asset Inventory: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---asset-inventory','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(355,97,1,'DEMO XL - Asset Inventory: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---asset-inventory','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(356,97,1,'DEMO XL - Asset Inventory: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---asset-inventory','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(357,98,1,'DEMO XL - License Management: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---license-management','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(358,98,1,'DEMO XL - License Management: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---license-management','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(359,98,1,'DEMO XL - License Management: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---license-management','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(360,98,1,'DEMO XL - License Management: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---license-management','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(361,99,1,'DEMO XL - Compliance Audit: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---compliance-audit','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(362,99,1,'DEMO XL - Compliance Audit: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---compliance-audit','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(363,99,1,'DEMO XL - Compliance Audit: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---compliance-audit','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(364,99,1,'DEMO XL - Compliance Audit: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---compliance-audit','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(365,100,1,'DEMO XL - GDPR Operations: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---gdpr-operations','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(366,100,1,'DEMO XL - GDPR Operations: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---gdpr-operations','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(367,100,1,'DEMO XL - GDPR Operations: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---gdpr-operations','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(368,100,1,'DEMO XL - GDPR Operations: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---gdpr-operations','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(369,101,1,'DEMO XL - Business Continuity: Stoerung klassifizieren und Erstmassnahmen starten','<p><b>Ziel:</b> Stoerung sauber einordnen und schnell stabilisieren.</p><ol><li>Auswirkung und Betroffenheit erfassen.</li><li>Prioritaet nach SLA bestimmen.</li><li>Sofortmassnahme zur Stabilisierung durchfuehren.</li><li>Logeintraege und Fehlermeldungen sichern.</li><li>Ticket mit reproduzierbaren Schritten aktualisieren.</li></ol>','demo-xl,stoerung,klassifikation,erstmassnahmen,runbook,demo-xl---business-continuity','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(370,101,1,'DEMO XL - Business Continuity: Root-Cause Analyse im Standardablauf','<p><b>Vorgehen:</b> Systematisch zur Ursache.</p><ol><li>Zeitleiste mit Aenderungen erstellen.</li><li>Komponenten einzeln isoliert testen.</li><li>Konfigurationsabweichungen vergleichen.</li><li>Hypothese pruefen und gegentesten.</li><li>Ursache mit Nachweis dokumentieren.</li></ol>','demo-xl,root cause,analyse,rca,ursache,demo-xl---business-continuity','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(371,101,1,'DEMO XL - Business Continuity: Standard-Rollback nach fehlerhafter Aenderung','<p><b>Ziel:</b> Stabilen Zustand schnell wiederherstellen.</p><ol><li>Letzte Aenderung identifizieren.</li><li>Freigabe gemaess Change-Prozess holen.</li><li>Rollback-Schritte in definierter Reihenfolge ausfuehren.</li><li>Smoke-Test auf Kernfunktionen machen.</li><li>Resultat und offene Risiken kommunizieren.</li></ol>','demo-xl,rollback,change,fehler,stabilisierung,demo-xl---business-continuity','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(372,101,1,'DEMO XL - Business Continuity: Praevention und Monitoring-Checks definieren','<p><b>Nachbearbeitung:</b> Wiederholungen vermeiden.</p><ol><li>Schwellwerte fuer Monitoring festlegen.</li><li>Automatische Alarme auf Fehlerbild einstellen.</li><li>Dokumentation und Runbook aktualisieren.</li><li>Wissenstransfer im Team durchfuehren.</li><li>Wirksamkeit nach 7 Tagen kontrollieren.</li></ol>','demo-xl,praevention,monitoring,alerting,checkliste,demo-xl---business-continuity','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06');
/*!40000 ALTER TABLE `ost_faq` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_faq_category`
--

DROP TABLE IF EXISTS `ost_faq_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_faq_category` (
  `category_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_pid` int(10) unsigned DEFAULT NULL,
  `ispublic` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `name` varchar(125) DEFAULT NULL,
  `description` text NOT NULL,
  `notes` tinytext NOT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`category_id`),
  KEY `ispublic` (`ispublic`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_faq_category`
--

LOCK TABLES `ost_faq_category` WRITE;
/*!40000 ALTER TABLE `ost_faq_category` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_faq_category` VALUES
(1,0,1,'DEMO â€¢ Microsoft 365','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:01:40','2026-02-19 18:04:41'),
(2,0,1,'DEMO â€¢ Identity & Access','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:01:40','2026-02-19 18:04:41'),
(4,0,1,'DEMO â€¢ Windows Clients','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:01:40','2026-02-19 18:04:41'),
(5,0,1,'DEMO â€¢ Netzwerk','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:01:40','2026-02-19 18:04:41'),
(6,0,1,'DEMO â€¢ Drucker','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:01:40','2026-02-19 18:04:41'),
(8,0,1,'DEMO â€¢ VPN & Remote','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:01:40','2026-02-19 18:04:41'),
(9,0,1,'DEMO â€¢ Collaboration','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:01:40','2026-02-19 18:04:41'),
(10,0,1,'DEMO â€¢ Security','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:01:40','2026-02-19 18:04:41'),
(11,0,1,'DEMO â€¢ Server & Storage','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:01:40','2026-02-19 18:04:41'),
(12,0,1,'DEMO MASS - Endpoint Management','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(13,0,1,'DEMO MASS - Identity Access','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(14,0,1,'DEMO MASS - Windows Clients','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(15,0,1,'DEMO MASS - Network Operations','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(16,0,1,'DEMO MASS - Printer Services','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(17,0,1,'DEMO MASS - VPN Remote','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(18,0,1,'DEMO MASS - Collaboration','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(19,0,1,'DEMO MASS - Mail Flow','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(20,0,1,'DEMO MASS - Backup Restore','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(21,0,1,'DEMO MASS - Server Storage','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(22,0,1,'DEMO MASS - Virtualization','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(23,0,1,'DEMO MASS - DNS DHCP','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(24,0,1,'DEMO MASS - WiFi NAC','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(25,0,1,'DEMO MASS - Security Endpoint','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(26,0,1,'DEMO MASS - Patch Management','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(27,0,1,'DEMO MASS - Monitoring Alerts','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(28,0,1,'DEMO MASS - Browser Webapps','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(29,0,1,'DEMO MASS - Mobile Device','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(30,0,1,'DEMO MASS - Certificates PKI','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(31,0,1,'DEMO MASS - File Services','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(32,0,1,'DEMO MASS - ERP CRM Clients','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(33,0,1,'DEMO MASS - Database Clients','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(34,0,1,'DEMO MASS - Remote Desktop','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(35,0,1,'DEMO MASS - IAM SSO','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(36,0,1,'DEMO MASS - M365 Platform','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(37,0,1,'DEMO MASS - Teams Voice','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(38,0,1,'DEMO MASS - Linux Clients','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(39,0,1,'DEMO MASS - Mac Clients','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(40,0,1,'DEMO MASS - Service Desk','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(41,0,1,'DEMO MASS - Compliance Audit','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:12:08','2026-02-19 18:12:14'),
(42,0,1,'DEMO XL - Endpoint Security','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(43,0,1,'DEMO XL - Endpoint Compliance','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(44,0,1,'DEMO XL - Entra Identity','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(45,0,1,'DEMO XL - Active Directory','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(46,0,1,'DEMO XL - Password Policy','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(47,0,1,'DEMO XL - Privileged Access','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(48,0,1,'DEMO XL - Windows Deployment','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(49,0,1,'DEMO XL - Windows Performance','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(50,0,1,'DEMO XL - Windows Printing','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(51,0,1,'DEMO XL - Windows Networking','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(52,0,1,'DEMO XL - DNS Operations','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(53,0,1,'DEMO XL - DHCP Operations','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(54,0,1,'DEMO XL - VPN Operations','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(55,0,1,'DEMO XL - Firewall Rules','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(56,0,1,'DEMO XL - Proxy Web','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(57,0,1,'DEMO XL - Microsoft 365 Apps','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(58,0,1,'DEMO XL - Exchange Online','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(59,0,1,'DEMO XL - SharePoint Online','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(60,0,1,'DEMO XL - OneDrive Operations','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:50','2026-02-19 18:14:06'),
(61,0,1,'DEMO XL - Teams Collaboration','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(62,0,1,'DEMO XL - Teams Meetings','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(63,0,1,'DEMO XL - Teams Voice','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(64,0,1,'DEMO XL - Mail Security','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(65,0,1,'DEMO XL - SPF DKIM DMARC','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(66,0,1,'DEMO XL - Backup Policy','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(67,0,1,'DEMO XL - Backup Restore','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(68,0,1,'DEMO XL - Storage Capacity','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(69,0,1,'DEMO XL - VMware Operations','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(70,0,1,'DEMO XL - HyperV Operations','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(71,0,1,'DEMO XL - Linux Server','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(72,0,1,'DEMO XL - Linux Client','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(73,0,1,'DEMO XL - Mac Client','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(74,0,1,'DEMO XL - WLAN Enterprise','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(75,0,1,'DEMO XL - NAC Authentication','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(76,0,1,'DEMO XL - PKI Certificates','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(77,0,1,'DEMO XL - TLS Services','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(78,0,1,'DEMO XL - Web Applications','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(79,0,1,'DEMO XL - Browser Support','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(80,0,1,'DEMO XL - Database Access','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(81,0,1,'DEMO XL - SQL Client','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(82,0,1,'DEMO XL - RDP Services','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(83,0,1,'DEMO XL - Remote Support','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(84,0,1,'DEMO XL - Monitoring Alerts','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(85,0,1,'DEMO XL - Log Management','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(86,0,1,'DEMO XL - SIEM Integration','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(87,0,1,'DEMO XL - MDM Devices','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(88,0,1,'DEMO XL - Mobile Apps','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(89,0,1,'DEMO XL - Intune Policies','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(90,0,1,'DEMO XL - Patch Rollout','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(91,0,1,'DEMO XL - Vulnerability Mgmt','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(92,0,1,'DEMO XL - Service Desk L1','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(93,0,1,'DEMO XL - Service Desk L2','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(94,0,1,'DEMO XL - Incident Process','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(95,0,1,'DEMO XL - Problem Management','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(96,0,1,'DEMO XL - Change Management','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(97,0,1,'DEMO XL - Asset Inventory','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(98,0,1,'DEMO XL - License Management','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(99,0,1,'DEMO XL - Compliance Audit','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(100,0,1,'DEMO XL - GDPR Operations','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06'),
(101,0,1,'DEMO XL - Business Continuity','Demo-Kategorie (automatisch erstellt)','seed_osticket_kb.py','2026-02-19 18:13:51','2026-02-19 18:14:06');
/*!40000 ALTER TABLE `ost_faq_category` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_faq_topic`
--

DROP TABLE IF EXISTS `ost_faq_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_faq_topic` (
  `faq_id` int(10) unsigned NOT NULL,
  `topic_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`faq_id`,`topic_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_faq_topic`
--

LOCK TABLES `ost_faq_topic` WRITE;
/*!40000 ALTER TABLE `ost_faq_topic` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_faq_topic` VALUES
(13,1),
(14,10),
(15,11),
(16,2),
(17,1),
(18,10),
(19,11),
(20,2),
(21,1),
(22,10),
(23,11),
(24,2),
(25,1),
(26,10),
(27,11),
(28,2),
(29,1),
(30,10),
(31,11),
(32,2),
(33,1),
(34,10),
(35,11),
(36,2),
(37,1),
(38,10),
(39,11),
(40,2),
(41,1),
(42,10),
(43,11),
(44,2),
(45,1),
(46,10),
(47,11),
(48,2),
(49,1),
(50,10),
(51,11),
(52,2),
(53,1),
(54,10),
(55,11),
(56,2),
(57,1),
(58,10),
(59,11),
(60,2),
(61,1),
(62,10),
(63,11),
(64,2),
(65,1),
(66,10),
(67,11),
(68,2),
(69,1),
(70,10),
(71,11),
(72,2),
(73,1),
(74,10),
(75,11),
(76,2),
(77,1),
(78,10),
(79,11),
(80,2),
(81,1),
(82,10),
(83,11),
(84,2),
(85,1),
(86,10),
(87,11),
(88,2),
(89,1),
(90,10),
(91,11),
(92,2),
(93,1),
(94,10),
(95,11),
(96,2),
(97,1),
(98,10),
(99,11),
(100,2),
(101,1),
(102,10),
(103,11),
(104,2),
(105,1),
(106,10),
(107,11),
(108,2),
(109,1),
(110,10),
(111,11),
(112,2),
(113,1),
(114,10),
(115,11),
(116,2),
(117,1),
(118,10),
(119,11),
(120,2),
(121,1),
(122,10),
(123,11),
(124,2),
(125,1),
(126,10),
(127,11),
(128,2),
(129,1),
(130,10),
(131,11),
(132,2),
(133,1),
(134,10),
(135,11),
(136,2),
(137,1),
(138,10),
(139,11),
(140,2),
(141,1),
(142,10),
(143,11),
(144,2),
(145,1),
(146,10),
(147,11),
(148,2),
(149,1),
(150,10),
(151,11),
(152,2),
(153,1),
(154,10),
(155,11),
(156,2),
(157,1),
(158,10),
(159,11),
(160,2),
(161,1),
(162,10),
(163,11),
(164,2),
(165,1),
(166,10),
(167,11),
(168,2),
(169,1),
(170,10),
(171,11),
(172,2),
(173,1),
(174,10),
(175,11),
(176,2),
(177,1),
(178,10),
(179,11),
(180,2),
(181,1),
(182,10),
(183,11),
(184,2),
(185,1),
(186,10),
(187,11),
(188,2),
(189,1),
(190,10),
(191,11),
(192,2),
(193,1),
(194,10),
(195,11),
(196,2),
(197,1),
(198,10),
(199,11),
(200,2),
(201,1),
(202,10),
(203,11),
(204,2),
(205,1),
(206,10),
(207,11),
(208,2),
(209,1),
(210,10),
(211,11),
(212,2),
(213,1),
(214,10),
(215,11),
(216,2),
(217,1),
(218,10),
(219,11),
(220,2),
(221,1),
(222,10),
(223,11),
(224,2),
(225,1),
(226,10),
(227,11),
(228,2),
(229,1),
(230,10),
(231,11),
(232,2),
(233,1),
(234,10),
(235,11),
(236,2),
(237,1),
(238,10),
(239,11),
(240,2),
(241,1),
(242,10),
(243,11),
(244,2),
(245,1),
(246,10),
(247,11),
(248,2),
(249,1),
(250,10),
(251,11),
(252,2),
(253,1),
(254,10),
(255,11),
(256,2),
(257,1),
(258,10),
(259,11),
(260,2),
(261,1),
(262,10),
(263,11),
(264,2),
(265,1),
(266,10),
(267,11),
(268,2),
(269,1),
(270,10),
(271,11),
(272,2),
(273,1),
(274,10),
(275,11),
(276,2),
(277,1),
(278,10),
(279,11),
(280,2),
(281,1),
(282,10),
(283,11),
(284,2),
(285,1),
(286,10),
(287,11),
(288,2),
(289,1),
(290,10),
(291,11),
(292,2),
(293,1),
(294,10),
(295,11),
(296,2),
(297,1),
(298,10),
(299,11),
(300,2),
(301,1),
(302,10),
(303,11),
(304,2),
(305,1),
(306,10),
(307,11),
(308,2),
(309,1),
(310,10),
(311,11),
(312,2),
(313,1),
(314,10),
(315,11),
(316,2),
(317,1),
(318,10),
(319,11),
(320,2),
(321,1),
(322,10),
(323,11),
(324,2),
(325,1),
(326,10),
(327,11),
(328,2),
(329,1),
(330,10),
(331,11),
(332,2),
(333,1),
(334,10),
(335,11),
(336,2),
(337,1),
(338,10),
(339,11),
(340,2),
(341,1),
(342,10),
(343,11),
(344,2),
(345,1),
(346,10),
(347,11),
(348,2),
(349,1),
(350,10),
(351,11),
(352,2),
(353,1),
(354,10),
(355,11),
(356,2),
(357,1),
(358,10),
(359,11),
(360,2),
(361,1),
(362,10),
(363,11),
(364,2),
(365,1),
(366,10),
(367,11),
(368,2),
(369,1),
(370,10),
(371,11),
(372,2);
/*!40000 ALTER TABLE `ost_faq_topic` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_file`
--

DROP TABLE IF EXISTS `ost_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_file` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ft` char(1) NOT NULL DEFAULT 'T',
  `bk` char(1) NOT NULL DEFAULT 'D',
  `type` varchar(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '',
  `size` bigint(20) unsigned NOT NULL DEFAULT 0,
  `key` varchar(86) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `signature` varchar(86) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `attrs` varchar(255) DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ft` (`ft`),
  KEY `key` (`key`),
  KEY `signature` (`signature`),
  KEY `type` (`type`),
  KEY `created` (`created`),
  KEY `size` (`size`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_file`
--

LOCK TABLES `ost_file` WRITE;
/*!40000 ALTER TABLE `ost_file` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_file` VALUES
(1,'T','D','image/png',9452,'b56944cb4722cc5cda9d1e23a3ea7fbc','gjMyblHhAxCQvzLfPBW3EjMUY1AmQQmz','powered-by-osticket.png',NULL,'2026-02-19 18:15:04'),
(2,'T','D','text/plain',24,'j4-yfMWtx86n3ccfeGGNagoRoTDtol7o','MWtx86n3ccfeGGNafaacpitTxmJ4h3Ls','osTicket.txt',NULL,'2026-02-19 18:15:04'),
(3,'T','D','image/png',26990,'WLE_C0wWGCoo9R0-JJ-x4Wqp6qvR8CsE','0wWGCoo9R0-JJ-x4K4bKZeHT_gAQn_ko','d305860a8a3d474f8927ec785aaa7aaaf47c0ac1.png',NULL,'2026-02-23 16:22:59');
/*!40000 ALTER TABLE `ost_file` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_file_chunk`
--

DROP TABLE IF EXISTS `ost_file_chunk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_file_chunk` (
  `file_id` int(11) NOT NULL,
  `chunk_id` int(11) NOT NULL,
  `filedata` longblob NOT NULL,
  PRIMARY KEY (`file_id`,`chunk_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_file_chunk`
--

LOCK TABLES `ost_file_chunk` WRITE;
/*!40000 ALTER TABLE `ost_file_chunk` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_file_chunk` VALUES
(1,0,'‰PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0Ú\0\0\0(\0\0\0˜GäÉ\0\0\nCiCCPICC profile\0\0xÚSwX“÷>ß÷eVBØð±—l\0\"#¬ÈY¢’\0a„@Å…ˆ\nVœHUÄ‚Õ\nHˆâ (¸gAŠˆZ‹U\\8îÜ§µ}zïííû×û¼çœçüÎyÏ€&‘æ¢j\09R…<:ØOHÄÉ½€Hà æËÂgÅ\0\0ðyx~t°?ü¯o\0\0pÕ.$ÇáÿƒºP&W\0 ‘\0à\"çR\0È.TÈ\0È\0°S³d\n\0”\0\0ly|B\"\0ª\r\0ìôI>\0Ø©“Ü\0Ø¢©\0\0™(G$@»\0`UR,ÀÂ\0 ¬@\".À®€Y¶2G€½\0vŽX@`\0€™B,Ì\0 8\0CÍ L 0Ò¿à©_p…¸H\0ÀË•Í—KÒ3¸•Ð\Zwòðàâ!âÂl±Ba)f	ä\"œ—›#HçLÎ\0\0\ZùÑÁþ8?çæäáæfçlïôÅ¢þkðo\">!ñßþ¼Œ\0NÏïÚ_ååÖpÇ°u¿k©[\0ÚV\0hßù]3Û	 Z\nÐzù‹y8ü@ž¡PÈ<\ní%b¡½0ã‹>ÿ3áoà‹~öü@þÛzð\0qš@™­À£ƒýqanv®RŽçËB1n÷ç#þÇ…ýŽ)Ñâ4±\\,ŠñX‰¸P\"MÇy¹R‘D!É•âé2ñ–ý	“w\r\0¬†OÀN¶µËlÀ~î‹XÒv\0@~ó-Œ\Z‘\0g42y÷\0\0“¿ù@+\0Í—¤ã\0\0¼è\\¨”LÆ\0\0D *°AÁ¬ÀœÁ¼ÀaD@$À<Bä€\n¡–ATÀ:Øµ°\Z šá´Á18\rçà\\ëp`žÂ¼†	AÈa!:ˆbŽØ\"Î™Ž\"aH4’€¤ éˆQ\"ÅÈr¤©Bj‘]H#ò-r9\\@úÛÈ 2ŠüŠ¼G1”²QÔu@¹¨\ZŠÆ sÑt4]€–¢kÑ\Z´=€¶¢§ÑKèut\0}ŠŽc€Ñ1fŒÙa\\Œ‡E`‰X\Z&ÇcåX5V5cX7vÀžaï$‹€ì^„Âl‚GXLXC¨%ì#´ºW	ƒ„1Â\'\"“¨O´%zùÄxb:±XF¬&î!!ž%^\'_“H$É’äN\n!%2IIkHÛH-¤S¤>ÒiœL&ëmÉÞä²€¬ —‘·O’ûÉÃä·:ÅˆâL	¢$R¤”J5e?å¥Ÿ2B™ ªQÍ©žÔªˆ:ŸZIm vP/S‡©4uš%Í›CË¤-£ÕÐšigi÷h/étº	ÝƒE—Ð—Òkèéçéƒôw\r†\rƒÇHb(k{§·/™L¦Ó—™ÈT0×2™g˜˜oUX*ö*|‘Ê•:•V•~•çªTUsU?ÕyªT«U«^V}¦FU³Pã©	Ô«Õ©U»©6®ÎRwRPÏQ_£¾_ý‚úc\r²†…F †H£Tc·Æ!Æ2eñXBÖrVë,k˜Mb[²ùìLvûv/{LSCsªf¬f‘fæqÍÆ±àð9ÙœJÎ!Î\rÎ{--?-±Öj­f­~­7ÚzÚ¾ÚbírííëÚïup@,õ:m:÷u	º6ºQº…ºÛuÏê>Ócëyé	õÊõéÝÑGõmô£õêïÖïÑ7046l18cðÌcèk˜i¸Ñð„á¨Ëhº‘Äh£ÑI£\'¸&î‡gã5x>f¬ob¬4ÞeÜk<abi2Û¤Ä¤Åä¾)Í”kšfºÑ´ÓtÌÌÈ,Ü¬Ø¬ÉìŽ9Õœkža¾Ù¼Ûü…¥EœÅJ‹6‹Ç–Ú–|Ë–M–÷¬˜V>VyVõV×¬IÖ\\ë,ëmÖWlPW››:›Ë¶¨­›­Äv›mßâ)Ò)õSnÚ1ìüì\nìšìí9öaö%ömöÏÌÖ;t;|rtuÌvlp¼ë¤á4Ã©Ä©ÃéWgg¡só5¦KË—v—Sm§Š§nŸzË•å\ZîºÒµÓõ£›»›Ü­ÙmÔÝÌ=Å}«ûM.›É]Ã=ïAôð÷XâqÌã§›§Âóç/^v^Y^û½O³œ&žÖ0mÈÛÄ[à½Ë{`:>=eúÎé>Æ>ŸzŸ‡¾¦¾\"ß=¾#~Ö~™~üžû;úËýø¿áyòñN`Áå½\Z³k™¥5»/>B	\rYr“oÀòùc3Üg,šÑÊZú0Ì&LÖŽ†Ïß~o¦ùLéÌ¶ˆàGlˆ¸i™ù})*2ª.êQ´Stqt÷,Ö¬äYûg½Žñ©Œ¹;Ûj¶rvg¬jlRlcì›¸€¸ª¸x‡øEñ—t$	í‰äÄØÄ=‰ãsçlš3œäšT–tc®åÜ¢¹æéÎËžw<Y5Y|8…˜—²?åƒ BP/Oå§nMò„›…OE¾¢¢Q±·¸J<’æV•ö8Ý;}Cúh†OFuÆ3	OR+y‘’¹#óMVDÖÞ¬ÏÙqÙ-9”œ”œ£R\ri–´+×0·(·Of++“\räyæmÊ“‡Ê÷ä#ùsóÛl…LÑ£´R®PL/¨+x[[x¸H½HZÔ3ßfþêù#‚|½°P¸°³Ø¸xYñà\"¿E»#‹Sw.1]RºdxiðÒ}ËhË²–ýPâXRUòjyÜòŽRƒÒ¥¥C+‚W4•©”ÉËn®ôZ¹ca•dUïj—Õ[V*•_¬p¬¨®ø°F¸æâWN_Õ|õymÚÚÞJ·ÊíëHë¤ën¬÷Y¿¯J½jAÕÐ†ð\r­ñå_mJÞt¡zjõŽÍ´ÍÊÍ5a5í[Ì¶¬Ûò¡6£öz]ËVý­«·¾Ù&ÚÖ¿Ýw{óƒ;Þï”ì¼µ+xWk½E}õnÒî‚Ý\Zbº¿æ~Ý¸GwOÅž{¥{öEïëjtolÜ¯¿¿²	mR6H:på›€oÚ›íšwµpZ*ÂAåÁ\'ß¦|{ãPè¡ÎÃÜÃÍß™·õëHy+Ò:¿u¬-£m =¡½ïèŒ£^G¾·ÿ~ï1ãcuÇ5Wž (=ñùä‚“ã§d§žN?=Ô™Üy÷Lü™k]Q]½gCÏž?tîL·_÷ÉóÞç]ð¼pô\"÷bÛ%·K­=®=G~pýáH¯[oëe÷ËíW<®tôMë;ÑïÓújÀÕs×ø×.]Ÿy½ïÆì·n&Ý¸%ºõøvöíw\nîLÜ]zx¯ü¾Úýêúê´þ±eÀmàø`À`ÏÃYï	‡žþ”ÿÓ‡áÒGÌGÕ#F#\r\Z½òdÎ“á§²§ÏÊ~Vÿyës«çßýâûKÏXüØðù‹Ï¿®y©órï«©¯:Ç#Ç¼Îy=ñ¦ü­ÎÛ}ï¸ïºßÇ½™(ü@þPóÑúcÇ§ÐO÷>ç|þü/÷„óû€9%\0\0\0tEXtSoftware\0Adobe ImageReadyqÉe<\0\0(iTXtXML:com.adobe.xmp\0\0\0\0\0<?xpacket begin=\"ï»¿\" id=\"W5M0MpCehiHzreSzNTczkc9d\"?> <x:xmpmeta xmlns:x=\"adobe:ns:meta/\" x:xmptk=\"Adobe XMP Core 5.6-c014 79.156797, 2014/08/20-09:53:02        \"> <rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"> <rdf:Description rdf:about=\"\" xmlns:xmp=\"http://ns.adobe.com/xap/1.0/\" xmlns:xmpMM=\"http://ns.adobe.com/xap/1.0/mm/\" xmlns:stRef=\"http://ns.adobe.com/xap/1.0/sType/ResourceRef#\" xmp:CreatorTool=\"Adobe Photoshop CC 2014 (Macintosh)\" xmpMM:InstanceID=\"xmp.iid:6E2C95DEA67311E4BDCDDF91FAF94DA5\" xmpMM:DocumentID=\"xmp.did:6E2C95DFA67311E4BDCDDF91FAF94DA5\"> <xmpMM:DerivedFrom stRef:instanceID=\"xmp.iid:CFA74E4FA67111E4BDCDDF91FAF94DA5\" stRef:documentID=\"xmp.did:CFA74E50A67111E4BDCDDF91FAF94DA5\"/> </rdf:Description> </rdf:RDF> </x:xmpmeta> <?xpacket end=\"r\"?>‹þöÊ\0\0IDATxÚì]	œSÕÕ?/{2Édf€aq]67ÐÏ­(*¨-\nöó³¶.õ+ÖÖ…º nµJÁ­öS‹R´Õ:VDT¤,eÑ2¨l‚ ¬‚ì‹3ÌÂL’—÷Ý›üosæN’ÉPqÌùý$“—÷î»÷üÏùŸsï»1†NY96¤ÚtÒØîïS±/QÄý]k~K¡“…îz›Ðí>ƒ%4ß¤Ò5ºú­<²Ù,²ÍclmYóÎÊ’„ž\'ôÇB¯hô·£BóLZ¸ÞM?›¤°\0]s™GÖ>¾×âZ(4W¨]h\r\"Ò¾&F4™]þ¶?JKD$úF>Yd-}QŠZY eå»)­„ž*t€ÐÓ„¶êà$»‰\r	=(t•ÐéBg	=Á¹íø_‚´¢Ñ”Q\0mÆVí+³SvaŠD›WÇgöýŽB¯ú¿B»eøÞB¯ºLèH¡Ò›#tó»BÇ	ýmFW’\0;tÈ _ŽÙì@–ÍÑš¿x„Þ.t!¿[Î!#à\\¡÷ã|ÉäWˆ’:÷Ø\rG³ I³·9é‰Ò*Ê6ËÈ­ùJk¡S…þAèqGÀN¼\09¤›EBïM¹~-4?í™Õ~ã I‹}Ô&·yåeYêØüå¡o\níu„Ï{.r»½Bk¸Öiv?Š—úLG·´Ñ”µjÈ-+ß‘Qæ•£\02%>ä|™Êï(^Í›’ß\nêXèÆr³æTÒÏRÇæ-’*öÿ–®-ãÑR¡Ë…V±¿ËBIË:GÊTÌ#þÉ5iþ\ZE\"Fó”lD;æ\\_äp¾ýsjÊdñ‘“õB\"t‡ÐB)ô2äwßÄïÏŠ»÷`”æ­ôÐ¤•^š¶ÑMnA!æ<¬YË>†¼ž¥’í§ö\n«ktõMæJw%ù»œ<.ÿÝÂÃB¿U\\GñBI?ç¦“]\0ÌoÆÐôå^ýô¥ºeF&.÷‘×a‘Ça5ï±Íš÷±#Ò£o>¤=L^«Ñþ]FŽžÚßJ…N\0ƒG¹ùã…¾V‡\Zú¢!q#!Å–ÛéÀ6=Xê§9›\\T2Èï²¨{«™cÑæ³,ÐŽ)zak³l´ú@1õÏß{¡„^£ýMF”¡_bÕæ(7ý9¡£­‘+\'J«Ö{hñ—nê¡[\\ôhiµóGc41\'\'±Mëû1¶Ž³Ï>;káÇL›¿ŒÞÜÝ‹ú·Ø$Ü|Æ~ð,Š—Ý•”xß ¶lÚâ(4W.Ó\ZAjÕˆÂrâãsrÉWµÉMÐW”rÝ\"zµhž«>²í;™§Y”çªŠE,0ÞŒ\\¾\\1ïbïº¯å\"á\'„¾‘ÁxËüêuÐLYÌÈ£x9ß)´ù^[\0›PôXVç‚NXá¥Í»T(\"Y¶‰u‹ßWevŠÝˆRUØC55AòØC™ÐGY6?‘½ÿ@è«Ú1k„VS|‚9ÈIîXÊè£Ä*rDÊ\"€öL¡ƒ„ÎŽ=*@4é«=NÊwZj‰9¾%pÉöÊ%aíñ~ÐyBe–•˜øíµ´¢¢\r•ììKÃ;HTëoè+ƒ)¾QÉ_Å¸t¡Ôë‰cIìUžÈ±B\"”VÚªÈVg>LÊvW¦Sâ1›|òX»¶îpÑ°Éy´í Zx£rR­Å\'·# °)ýÅWšHª[ ÔöÊº±	Ý(#ò=B2ŠûC¡Û²@ËJL,H$ËÝµ(ñŸN)2š©°\'¿›ä˜®\ZµÔ/*Ïð\'rZŸKDÜûV((ßÕg	Œ²Å›{€ÆP“]aYÇ ¹jßŠ=B³\n\"4~n€VnwR÷¶‘XŽFñUÿrQsÎJdäÜ\Zz¾ô7\"ày¡7e©cVŽŠ¸ªéý½Ýèäàê%”BþT`Ë…SòOÐ;]NNy±XÞz7â¶s´Ñ}óôä‡~j/¨ß¬\rnª´·ÒFÃz×ÐÈ*ˆÄf–Û‰æ´Œ5)×ÜEžè¡EK|ôÖj·4Èù4\rI.òÂ–”x¶ÍÛÄ.ŒjÀ6ˆ¨GJŽG_÷†Ó˜‘Zz1`NxãPŠã<8¦^þÈ$6“vÔhUYõ\nìG¶äójrÞ¬/^ïDŽ¥‹¤aÝSš£ÛšImÂ·Lœ•\Zû^ fZË†A36ºck å{,\Z9 RÜ±@WµQ% °Zädó·×ãWmö†ož–\'rKŠÇJöŠöU0Ã7YÞ§D~&*¯ØòÑÿ•‡1~ÿé…&=PH:	ïÇeÖ°È~¹|Ôd4ÅŸ:æÒ‡âë\nÛã˜{ŽÔÅ£TÇ¹+h²,ó‹ˆÖ9wwªÍzäüX\0¯¿ýÒå-‡K€ÌN/RÛðÍÏÌÌ\rÝ3-H…h+Ÿapymv+ÒÊgÉ§¥7·òE#ó¶:éê’*¹ò€ÛêZ;xù×ÎwÉ*‰¯Kq¨8WàQ€Ì€È¶<ð{Xž&Ò£”xPTRÏ;PÄ‘ ü#œ—›š²%Â·\'íÈH/¼d–¢&Añy©ø?™• ²åLjÈ‡6á=\"²9¡t9\Z_¨»2I$Ûõ\0éKí,Ú-\"Ùh²žùg.Ýþv°°8ß¼Éa‹=¨Ùž]MV*D-z²c0:òz7yßÉ£GÏ¯(/y=¿|Ò§^[¹Óº¶caäq>ÑºQj‹ÐÇ)¾bD—¯ÙkyƒŸJ@ãýÖc˜å¤K–·¡ £leh\rK„ÑÅ)¨ãAxnývF8\r“J¶Bww*%Gl^Í–Ì‹*ùDûLVÜþ†ª —)QÓxÀæ1×NTñ7oæÑ.ß|Îe§S¢Vì>^„ÑÈüèB/‘\ZŽÒ½ÇÍqSEÞöÅ>;-Þî41út¯ö¡¦iDÅç“8U”}\'Ñ\"ôOBÏz–#ñœÍÅÞw¢ø–v8;¹„ìIºF>È:Ô¹³ã°€âO4Dåå³r—‚ÖáŒÆSÝmò.¦øF!%¦8äŠ›I¬‚y\"úº“†§‹á„eÛ*HàNEÃf£t5ÅçK#Á®L’›BâçÅEÁ3ãÙ6P• Ëý$ŠV72öã;ÜèP\"1úÃ“È¹ ùàòÄ¡Ú¹ƒÔ\\y¨Õ ä(ªrÿ\"ªW²>•ƒªÝzúSñ}‹ê|?AŸÈ6N£øŠyÎ‹p9H«’\0¢­ŠÄ6Â1‹6Ê§PÔZ}iÍ\"§²R7Å%’ÞOÞèÄûíÑ‹kCU!j/@61à²z	Ê\'ó‰[„~¥åw×£ú7V\0q_®+ö}ê˜o^e4\"6¶‰Ž½Â¨ôs„þ¶ô!Å×\\râÊkžJN­Tò—$@“Q÷Nª¿®SÉù ¥éæÌ$yZ(_õ:ë{éÀäW,”¤\r·/ƒ¹u¹\ZsÖx†çÑ°qhèØæ‚ç«Ð.ŸÞ}	žŠ‹ìg(¾b[\ZÖsðL7ãüRF¡ä+¯%¡(ÁßGÃ8\"ð4¤rê)Ú5VÂ‚6IÙFõ\r:ï XR>9±ÚQ;G)Ú´ïï¦øÀ^–ÓLÈ°RÆ#‹ÌÓ.cà/Â õÀ5/dÔIzf9¹,ç›æ}Og+>{8¾²¾xqï*êîÀk¹‚^ßZ`5¢Êr¹uÀÜuúºÊ ¾è\"’IÍE[uT‹\\µ\nÑqŒÈßfåº-éÏµâÍº/I4%8´{0Æ7\"W+k «¼T…ŒGa_édC:¶ö¨2ÙÆá¸ßv\0ÝYìóµÈ-»£ß{À¶ú0ÇŸNì6VýñÂàû!1ýšyˆš\0@LF™yè@:ö:xæ:¬/+EŸÃ®u.^f=0	²WÈV\"b…¦KÐ5¬3G í„ht¸#À+Áõ>?÷àÇ½=‚ö˜0Ž}0žÎt É¼×´u\rþVˆ¶Ê9¬)ŒftÑ¼~;¼žWŸ9XtÈtÆŠ#)\n6Exý9r¢óá8¸¼ë_K€Ì¥gè‘—æDûŠœì¬š¿+	È¸¼\nìáZ­ôþušï-@ßGðÝLÊò©¢ÝM\ZÈÂ`Òñ^Nñ\r‚^F¥È«	ÇÝÈÞÏ` #¸ÎbLåFDÚ~”xÖŽ@7Ÿ„Ó:ÉÛþ!lò1Àl\Z—•\'þ9@p)‹báPbNæUP®óq¬â¬÷ñþt€è8’\"–\'ª\r\\&!Âª²·ã&OGG×‚bÞnf`]Ê0çèN=m?‘ÏkõÂëÛXïF$?µ±2übP\n±ÁØ•p¶0˜ë{õEAoh¿Œ|®êdùYë·E,ÇqjQe˜0×íT`ÒËK|4bf.äDÉf‹õ‡ŒÚo³èžNÔDøÃªÒý=l,uÙ1¹\\£¤•vßU‹‹¼îP°šwÀB®G_û)1§\0»NŸo©°¡–¥CØçÄÆç&ÒûØç—Í<Pq~ÿ6ª®²cmZ˜žÀæb>Æ	”\\£U†ñ£ÿ‚\' øyø>!Ü¶F¾äG´,ÍGä²ÊMOÉf ÊuQçìÀÕàýnxª©ˆŠªHðrL<Ü4Š?f/å qR¦ƒêJÊ¿É¤%e\"£‰È2Žs!Ö§Œ!¨¯\'ó~Ëëp\r#Jeå¹+R=uËúm£^J¾‚U’|¨²ÊFïop“C¼öú(h_oI3™Ì]puB4û+®q.¢ÖC—¶I[ÙIM›gTm(‹üFò‡Fœg/\"êX–·®Aÿð]™¯\03#°¨)IÎ5ã­rØ¬ÀcÓ¨}ÊªãGÚû…@©@Q¾|\0ºÂE(ˆN‘žåw”ØÌ¥þuDÎK\0–þhÔ*äYªC¥.ƒ1ÛàUrX4<žy¢ÅÌ;²Èù_B¿@‡D1p~mxÞVËÞ¯è»g´5Zeò+xÐãàH¶Ì\'ÃP\rDé¾¬Ÿë€lw­ŸúöPÍÌdùxì>]h÷ü­B‹°›ÕG¼¾ÔG¯­ðR·Âˆ|ÈÒ`ýœéQìêvð¢ÛÓ ÀB¿†C,Eî¶ˆROøg*µ÷/6òû9 pª8!Ä­Œæì”¯ q\"BZ45xH2Å¢-G: ™I83%©¾Õ$ñ‚|™‹aYÛ\0<Ü´¤Z½ÈW³›Ø0ì&ªÑæÏaTnÍàU¹ØÃ¢ÓZtš¦epª\ZØÔi#E¿™ŒF¨6Îýé*Ûí\\çóo¾­&H\'	=Ðc6¹m\"Ä¶6¨WéÆÜJVQSq*ê²¨b§“¦,óQ› ©žd¶±{Î4Òð{r²±Êu!Æ²è×F¡n£¦-èµ’Ì–7a®íL­¸‘ƒê7i@ã{PžLé–®%$Â(Ðô\'qû°c¶€Ãw`ž”`@ùˆ5	´eöÀ°Ôã\Z—²Èò9ÀfÕ£¡š—V%õ®¯¢“M(–Ã«úqÎaðúês¾ß÷Q€è¨w^Ë“wÒ\nRZ0Ç²‹EÍOàtn`Å‡Åè—¸eY=Þm.ù÷’\'2_ªýCN`Æ®Š(!–kÇûMÐÄû4u›º%¼4)±H¦[øÐ/ª;õý}\\Œþ8›*äXüŒÔ=Mwh\r\Zt\nÑ\\\'\"Ü\nÆ„ìZ~M3µ-9Ù8ÚR8‰¤g†_@uWNÀæ4º²ê“šÏ¹›5b5ËóT^RcSVh§bà>b\0#äØ5:¡,ûwÌcT§¨Pma×ù¢ú¼\'¦ þE	e0ÃXÔŽBI‹Fx\\y¾•ÀUìõ\"­8¡rŽãõ[ü„EÞr:!5ˆdIA–Çhí\'Z4Wt°¶¶¯gÎ4é†²övä<ÇQý]ˆ-ôÿ\\âØA(5`m,¯	çšŒÂ‰’V¨\ZúXd¯Ñ*¦çPbŽõ<¦B%+û#c.V* éíPŽ”˜,VÕ™y(:Œ\0°F#\"|Fu7†™Áªl+\0(¿–´ïÅ€ôbóŸ²‚Ì`xÚ—PRý7Õ*)ù.^U(è\\ŽÎœŠ÷;†¶è„«PÐ™\0ƒy—\ZÀ™êÇñèü\0ˆjËì8™§ý\ZÇÐó“ÞÝyÙd…Qæe©Ÿ®Zó	ÆEOÀ·ýÛhÂu)ˆÐÐîµ´h»3¶!›[SUÄ\'¨á_Œˆqü¢õÇ(.ý”RO¯BÑbòºW›Ñ¶hï¯Ô‹G\rÈN«ÖÀ)žÎîé|V¦FühÿÁ&D]îôêE4 ky6hwâõ =ßàÄ?D©½\'›³¹•uüb-áTsû˜G•²”y­yˆ¬`8—¢ßÇ<…\na+VÂ\rh÷2	óxš«1×Ñ–MA¼y—)lÞk$¸ü³¬H‘Ãy™7üýt\r¢•jËHô/6-ÓJÀu&<}\"¢QÄ•n@{³jðK\Zµ.`-N±BÚ†éšÓ«hµM/^•‚\\ß€1vSÃ/GJP”!½6#¢½£9¶:Cbý±öð€æDÄRÝ_Ì9ø†C\r‹þSU]SE4;¼òÐBªo¯\"¢(ùø÷Px)\'ŒåÌµpÊ²Ô	ÞÓœ{ˆPï4	þå0,@:ÑL•\\jÕ_ðùgù08‚0îc‹\"!Üë,x77®ñ\Z\nðdû\"~hàƒç“çºùÞ~P•9I¸ý,FSçÔ;km@F2?\n%û5z|:ú¸5hÐDíÛCØtGÂTET“å}-þËqzç{\n¥ûiIî³Q¿3þ#æÌdtþ-Æ!ÙDWDÒ#w#e&°š\ZñÀQNDûw•€Ý”jíq²¢Ô{p¤£k›§£+Ü{gZÇ«rÐ¥l«Á\"ülŽm$lÛp$I?€1»`<ÉøË:$“êìBiæb–B“c]šÎÝ€k8q°vC”d’W“èxUÞ\'¹yž¿À¡¬ ðQ’é.ˆ=o…3µV…˜ %–þ|Fõ×=ŠVÊ+­ž$‹E\'^9Oõ7KíÏLõƒè½²Z…äÈ«³IÎ4xø‡a°ÏÂA•á>ÎÄgÐ·³³¾\0`_c:\ZÁ˜\rF´(Dä~@3Ñ·3)±¾S:¸ß _?ðµ€“\\¨M)è´î8Ö~x/ÆïÁÆF!ÕPnép/Ø½åØ%h[pÝ‹Xes,Ú¾Ä‘¢\nieLÓ˜ÉD÷JKKrÖu”A˜)JÀw\"öd´±þò¥x^¶ÌâWÈû\npÓÉæ$¹Æ\0D÷(¢-‹]]¢Ó:†hk¹çi„üd3þ¿ªñ+ðî;ØßUnþ4\nKÉ¶P(PÇhýë×\n;^»Æ²”,]|ž„X¾Ë«±Tw	VžÆÞv\0¼uª¿à¾žbS(ÁÕÙ–Z?=g`x’ÚÑ¡5ÀMY9\Z’ƒ\\Sl3¨e:Y	jæBn©v¡J5—sûzÒSÐÆ.\'ÔÒ%›jhÌœ€\0Z=_ð\Z¢ó¥˜öh`oe[šâºË)ñ#ñ2§i°ìŸMÉ7×™ŽbV÷õ«„N@tòSý_]ŠëýÿwfHuÍ™He¦ãmÐéÿÛHk ZµDÛ½øî\'(˜ƒŠ¹NT»ç|_;ç\"´ëVJLÉ”i¾ñòË/÷BhŒ ‘³¸8â\"©Æ/á!wÂûšìÀëÊF5åüvT!+QÁ­/A“FOÒ˜Òê4›CŸ\Zp0jC•\nJÌ\'6¸£Qš~Ô7vD3/ØB5¨ªÕ@ÛZ pÉãËþ_€\0³à¯˜s]Jý\0\0\0\0IEND®B`‚'),
(2,0,'Canned Attachments Rock!'),
(3,0,'‰PNG\r\n\Z\n\0\0\0\rIHDR\0\0d\0\0’\0\0\0ó¸Pï\0\0i5IDATxÚÌÕnâ0ÆqnT\näA8]Iy±ÛæI/´²f¦Þq<V²«JŸ~úÛ˜Ýåñe,¡mõ™ÐvÚýTBƒÎ%ú®–YCO*þ6^r‚ö[EÛn‹hÛ ­i£%m«jÐ°Pâš´íºèBõ0‹\"h~w™wÝ§9\\®Z}ë•7jOÜ~9ïÁèœ÷€Ýé\'´Ÿî¬ÃgÆûn˜ñn¿”vî\rS^=èmwEß¼‚?e»Ë¯/sÚÝK$ú®yŠlP=hçÑý·˜_lu¢Æ\"\'¦«9\\ò‹$®YIFKmHÛt„Þf…D\\`7À¦h{	\'õ;ºÛïÆG—4ïÑh´‡ö[î.6§×„G:ã%G·Ýí—¢{ÃÔl}t½m¡àv—æi,ùæD;y	í°VNJhÞ\ZšßYæZ²Š¶ÍQ…’´i¼äí·’¶D~‘Ý›n Í[Ð6 ÕàJ\\³;m«zó	éá©Úf`4ÚC»w£mw’è½Ž6š»=*õt³n¿ÌíA™±¶ÚÞ¶ÐüRÞweª„æÝ~×Ï—ºÁ½á•6ª½í>Ð·?@É~ÿçÞ]“¹F¢{‰DÑF´–©g6ì,Ñw•D~ñ·f±ÑXä\0+%ò‹$®YÑ¿Äæ-´¡Ù}H\Z¡×ì.ˆìÈíüítßæXö¤ÔÓÍ¸ÕrÚÔ–6xTæ¼GÚz´ý—Ñæ=(3—¢}Òv›þa¯ŽrR‡¢(3¢KA@é¥yt*7ŠrÛJöÙiNÝ§¡FCÿ/+++}<Ý¥N?w¯Ø®c_wf®£ÊNz³|Dµ;‘mgêv÷s—ú;¿wä~x3:0u3voJ}ÐÛõF¶?w!]7ëó,‡¤´¥Ga]/+½«{%Ûe¨wUe¯·ë½«û½÷ƒ¾$Ë°^ê#½Ó[÷­Þ•½“íÏ\"¨%7!}QR·ç©Ùý¬çºS½¥›OìïžìÐ“è]·ý™ù»8*yË–ŽÔn>SÝ[ÙÝlëžú»«ºùL\\ÿù¢\'Ò?™Îx³ož‹ÞËög]ÝkÙvîB:(;·W»¢eWôÊÓ£¼Ï…tÝ<„´?Ãò–NõÖmÉ2¤ýT÷@ö%YèNÊ[zÒ‰ìf2·û6ësŠm·ÎVïzoó«-Ÿ÷M>¬n*3½ýÝŸýÍ†ÚþîWvÙá™êíï^ÖS÷d×Î“Þþžø;ÊûÉõÄu¤vó¹×Ûu·Ô÷zK?f#ì:ýKÒ9\0€/q,\0àX\0À±\0À‹c	\0€c	\0€c	\0€c	\0€c	\0€c	\0€c	\0€c	\0€c	\0€c	\0€c	\0€c	\0€c	\0€c	\0€c	\0€c	\0€¡EÇò\0ÐJ§ËµáX–^í\0ÐMžÌ«?–¥ù\0h÷B÷òº¥œÉãñ˜½Úká\0 ^ÙÏ?;r2O¢–+>–¥KùEf>^^!„\\YÞþ³c7+mDa\0†¯«k\"Þ÷!î\\¹¢+]w.DPAADQ#ŠºkÁ¶J«Ô41IÓDK…6H Žæùx–Ãœqf<o’ö{ùæc™”²Z­Š%@g\n	Hz)–O~­LJY.—Å 3…$½lýËå›e­V«T*ÅbQ,:SH@AÈX6e½^ObY(Ä 3…$±QË¿¦á7Ø|>/–\0)$àñ/±b)–\0ˆeK±,•J777b	Ð™BBÄR,K±@,X –‘K\0Ä22b	€XFF,ËÈˆ%\0b±@,##–\0ˆedÄ\0±ŒŒX –‘K\0Ä22b	€XFF,ËÈˆ%\0b±@,##–\0ˆedÄ\0±ŒŒX –‘K\0Ä22bùŠÕïŽŽÒym¼¬ûÓÓÚÞÞK­þsw7\\@:ïbÙÚ¼X–××K««Où±µ•Î·ªeÅ……pwß½+­¬Dþ63ŽÌõô´¹hhóíââ—‰‰ó¡¡¯““aéû““göëðP®³ÙÃÃ—ãã…ùùz.÷üùkûû×ÓÓ™ÌùààçLæzjª¿º½ý}n.~ââ76mŸ¢ö»ºÂëžÔÿ_=<ë°t®»ûîø8\rw#\\ÆíÒÒU6{»¼ü°!lnþ:;k’ùð@ƒðê¦óÿUËTÇòùµNúúÒùVµìÓÈHò§]Ž=Äæà ¼¶VÙØh88+)k;+^ý9IƒpÎüìì¿‡)Ù¯\\ŒŽ†Mªéþþa` é³{ßßß¬²q‡½½Û¿Ù5ƒ–‚(Ž´¾Aêu(H\"ˆ®^;yõ¦ozñàÁ“âE/–%jEATQýêÅkÚ!wÄFYdwföÍìç½ÿ¼÷æSÂÝ^ÙØ	6LŒ³ò¾T’ïnl¸JvÇäheEF‡¢¼ØV–Ë2{éö	öp?ð¬×¥õ¡RñSñ§¢Äd9ÅdÙY]õsU9—§Z\0†É4”Wé´X±Ût¼Csa¡·¹©TDaÜ€¿¥Mx]˜ìöÒ’Öô·¶l‹ßšŸ×tî%‡ËËZÃXÏ#Æð€õñA&ãµ°,\0ÅøøôÇÛÛ|&kWÉî˜°yâkžìì°+ò™,µÜ‹1YÆdú›5²Ä,ú¹z\"?m:±)uÐMÒ\"Â	‰d3{*•x–æ¶€*¬)rˆ!k=&U}Œ>ÄiŽ³~ÇFIƒ%“ºÒï\'°c$Ë\\l~ê‚M–8ÁfV•HIsnNšˆÊÆd“åð_L–Fœò[Ö\rå‘Ô‹Í¶íâYºÁ\0U&³Ã­ÒD~Qj0I_5¹œ=óDÄÕŽî,.Ú(½µÛê•²Ùˆ&“ÊËÊ@ò,ï°ÎK£Áö\"úf™c$Ë×V™Q`¤ÛŸÉÒ]wôÝÇN–ºÛ£^’»6Y†|8Wèìnˆ\rM»ÒÍO^ŒÉr–É“M°ˆƒ$âq«úÏugm\r½ê®¯‹LN²˜ÆÓÝ]$hÎ5SeŽ\"Ä6vt¾ØÛ•Œbª%£ph‚úÛBÛÇj•kŠhÑu6Ëµb+ML5`Ó Y£ÓàŠØy2)´Z19¡·CÌ\r>%	R\\ÌV™Ø6—´Ž”x¾ÉçeäÕ\0‹ËT*ÐkŸÍ!?Ú|gïü~í*ª8þOúàƒ‰4šÆD…6¡4(iƒ7”·ÖˆÁÐDZHlâ+ÄÄ@ôI-R.´”~ÔŠš?ú­_‡Y÷ì™;ÝçvŸ{×ÉÊÍ¹sfÏžY3³¾k­Y3ó_î±ä6;c¿üýïß;z´\\¸öÌ3ZRãîÒý÷ûíúÚ×J‹œ×ÅŠy˜1°ù÷ó_¬ô¶«O=åJ’ñyóÜ¹¨ÞÁ.;Æi]Ùœ&O4zQqœ¿1wºÛ>;Xzø]úÞ÷\"Xöw\\?ëL´F9Û_¾ñˆŠ;]ÙÉtú­óç—		–û,•ó­o}Ë51X~ø³ŸiP\nD+œãÿFÚ~äehéÊ‰Z,YÔSL³¸Ç¼å_&³þezóïõS§bÅÞ>|¸”éJ®èêí‰Æb$l8efb®M³Þ™\'²ÁaeÃnÛ­sòÊ“Oò=‚\"a·*3Æ­(ýÂkVÆ\"[%FMŠÙ8~dRWÄ0P69¨+\"U¿Ê°¦z¥UÄ:b|ÄKÎ6å%Ä#‘dhò„ÒTý;0w\ZmŸ,/=ð€¼\Z,;;®Ÿu&u„‘òÿÙNŸ.³ñ‰‘àZ&F&XîO°Ôùì…X® X¦œ«\"`]=\'˜\Z2D”ŽÚ†‘È¯—zH‰©äi	‰¬œìš°gÆ¿ÿè£ÎI))LZ¾G°dÒ2¥©†ã?!y5-Ó]UðK³ƒ‰jI1A– Ðå#G°Ex]3U\n8ªñD0ê.T~0Sµ°N\0þì—¿Ôž\"ý‹Ð\0Ë¹K9ÖÏhf4²+Ä˜ÇrbXóF¶Yj×ér]ðWS¿D°´Ò\0a!:Œ7¿1É@‚¯[)ä\'n`2ê¬S6xÀr`î4Ú>+XÒGü´ýðÃ,û;®Ÿu!Äw²=ñLC‰!E(‹ÙíÄ‚$EËPüçÿH Zµð•ò—	“	––Úô‰qVæêÀâ\\ +±BQ_yª˜H|…ô¬hJ®!P÷¯iSÙC‹W<‚eçÒ\Z„..;AÍ%Õ›/¿¬œeÔvŒÌÜ®r~–z	ñ´@QŒ\"={B[‘>Ùl÷T1Gˆ	Ä°œ‹±h;6áêÉ“Jg±?Ñao«Ò›k–,a…-àÒÜ”“­öû!ë?~þù²´Ïà•ñ¦ÅƒåÀÜi¶}^°D]ÐO†–ý×Ï:k½P©q¢Oó,d¥™EE†kÛ,×4³i™0™`¹1`)ô(Ý\"XZÆÒVù!Ùà¬Ÿ´hi‹7dFè_ôMíž^bõ\ZSåÙKÏØ¨ä6wî«¥ÛÇŽQxíŒ:t(zG‘Âp¸„Lë(¯èà¥pÜnýCJ:ž®Ê(§æî‘Q°g,K\\ÚÏaðë<~J)lºqö¬Ò‰1ÙXú(žÎAÍùuÚR1ÖR‡~°š;í¶ƒ%žÞÑ)hi(O^DE°ìï¸~ÖÁ¥ ÕEMÅ4à¼ú	o“lôeÂd‚åÆ€%ðóDr¼«s:ö!‚¥]&#_b¸&éL±þXSl/›A,ãÙ?é S^w7`i«Â¡›JÇÚ\nüD–æë};Fëñ:JøYÐRNËÁæº©­mÙßÍƒœ&6Ï!.ÀrÆz‰‘ —Š”~}k«?q‘•€#/Zï,)¼?r•¶€ÈtÌN„@™Ã‹0\0–Cs§Ýöy÷YROGJG°ìï¸~Ö16¸¤À($\0J@T¶dYÆ—:Ún™H™`¹`Ù¿fIÀä*°®¢»fâ,ÙOàÇd!íˆœT@Ž\rÀ ¿™Žó,Ã`ÓÑ!,ÓÇŽñÖIN§k•GÐ¯Qï<)#S\"YÖw†xø4Idò‰6`9cµŽ;AXÓã{h,q	4§¬>\r4\0–³ÍÚ>/XRmf£ÎJ^ËþŽÛ-ë\0Ô˜“ú¸2huMù‰i»L¤L°<Ð`i™Žá&^eKOH,6Ü’Ž\ZÀ¥YMÈI~›å€¥Kpd`O~‡Â7!¨Õö‰§™¸å2˜|×„\nß\0KZ47XzÉ™êaCW„Ì_ÍÚ€±~Ëÿž£ip	 ±Á^=–ãsg~°ì	Š‰`Ùßqý¬óâ\r\'bN%“š!KÚœ‰/%€€/K>ª>Áòà‚¥ýE^Bˆ~?<\'Ã`Ix…íÈ~ã¥—<ýä¢d:i¶ï=X‚@Èbá’cq§\ZuIf-	G\"½ZÐE˜>J”ôÎ“N‹A\\\"¼*	±e§Yµñ£ùÁ’xæ¨XXºùñpt2o´\'äÒñœÕºæXöÏÅ‚eOÇí–uÑéÂÜ/—˜^wX&&X&X®Ä9™Dñ”á´©4–Ìí¼–Œ³øþhkKF›¥OXB(­3Z–T@«°ncs°ÖÁ~8i#îêÄW»aÝv)ï1|ƒÒã2¤)n_#\\Î±‰@V’º:J±e°œ‘±ŽûÑ£wš gð`,ñLtFÃz÷½}Î°K‹ý~EŒüd§„%~“\'Ë±¹Óßvž\"üm­`Ùßqý¬CF¡2*f\"|KÞÓ¢@žjÒ¡IóRÂŽ–	“	––¨uÁHV¨‡ÁÒ1l,Ú31ûÌ=E´;’{,­H\nH¢Z*ßl,m-Q1â¨ä,`©¤‚[XuF|8ÞžØ¹äàâæå8¥&ôî)ý„ANò“ Ž¿|—È€°¹›G¸yûšcÚŽAù¥ÄˆªErW\Z,gd,Õó&9ø‰!BÅë€ÁáJŽ5E|Sf\0Ë\"ŠRMxì±Û¯¿Nó1ÙQ ì#uÐµ:š)CÚOi‰ßä‰ÁrÆ¹ÛîkÈàÀúÀ²¿ãúYçŽ`vh*éø\'%:Ô´~C//%ûR,\r–	“	––­+ºÆÁòÐ7YŽ3”‡ÁÒÖ›ý„1B¾Ù&X\Z¨20X\"|.¹­ÀxpL<yÄ¨Y±Xª”tª:ñ¿’§ó˜!$KM‘Îa<Ì±B`°œ—±úŠoÕO`i»ÇZHËÒNb¤ò´E¬–È“2¤³ÉƒåŒs\'¶~•õeÇõ³ŽjøWH§xdÆ5‹HðgÉÑ=	–›\r–½èœåb@„Ãiœc#‡PÍÌ€–z8ªÛS:šÈú\\½>æÃ‹|Ví£LgÊõ$†\"lä.7`ÿÅÌÈ\ZmE¯ Ö·oF-Z3Õ#¤Þsî6FRsÇJºªQ^ZÊÁwøCâ5|NÂìŒ¥sÙÞW6¿4lŽFt{¢©¨	ñ¸;ªW900kô“Ån™ÇŽôRYÁèqs€¨&O®?÷œ:nÆ¹ÛN[ôj\né¼¬ží	ð¶û¡§ãXçëtªŽÐ¾¦Šübš1Ç	Îóebd‚åf€å^–žleVO5Ä_4o¼œãã1¹\0NdP“w æÄ(É¿4Mrp!V8…¿|_÷f2›HCš3ÀØu¿±ß“O×ô°|b©ÞòÈ4lPCòŒódýs\'”³ˆ¡ÒÏ:rr#Ó¤Ùe0\rˆ]òÞÊËË¤¤¤¤¤ËË¤¤¤¤¤ËÉO‚eRRRRR‚eã“`™”””””`Ùø$X&%%%%%X6>	–IIIII	–O‚eRRRRR‚eã“`™”””””`Ùø$X&%Ý{â¤Sö¹?»äó1öò ¾˜8´aSvôïJ°L°ÜTB˜ràçqz5§Yrªg‚,³ª{Fp€Sd9õ°ifŽWsð˜.Ž¸{â\\=dF¿ÜÍ³ËäóÞÏUgWç^ºÿ~ýÄßeV~ÿQ‚e‚e âèH“äÌÆ=ñ¼êD;Ÿ0oŠç<¹=¨çbQY7øûÂnŠ\'¯Ž“Ï§UM88w/Ÿõ Ýè!ºõÊ+ñÒSŽÖ­5>gx™CqÿQ‚e‚eCzrúº_äËFøÒÌìÛ}X3WCpô¹S¨ðÔs™]¦ƒ×}ÿå=KNjåTq®§à¤Ð½|Öƒv£g„}°ÜŽÉçâ°}‰ÚeŽÃ}I	–	––¾D	yZÞè‰ËNIµñÐ@°gLØ%c`¹ÌÑx\0ÁrÚyH™`y÷Ÿý	–Ì\r®Aèšÿê¾-A§þ‹j%djÞÔ•Àëî„¸“=^ã%úÛo«Ÿ¸ßãnŠX\Z®\'mäþv.»FŸ}G§t–P]k%›R÷]>rd:?Í„úÁ’ÌT8ö,µà³p†Ú8n¡Æx*œÇ¹)ÅÿT£9þ}áåìäú/®,,ÈÇrš¥º~–«eu	¾É—¼_~ðA-û“ŸÜ‰°ÌõÝ‡L³«\'N\Z#‘*âÝ{0ÑÈæ_ù•—áñÇ]+òs1ÞŽRæÓ_üBK,¾ƒóú©S¥O‰’]_ø7.ÃÄ»0É)q™€¸×­î\\š¯šûÆã²þþÉ…üèG4ÄMÆìõ×S,uîöã¾hýùc\rV¸O¹µ[—ô’Á%\\¼ï>ÝÚIº\n‘«áÀ„…\røÓŸºùòáÓOÓü–Œ%~e˜.ãNMôpOa8\\èB{åë¸¤I6”¢Ê(ý€+…aµ›\0aâY_É-Öæ¤ƒÖmávIr*Cs<÷Ï†ÊÕ“\'Ý§ŒyÜ¤e†f5\"ù½Šº¤c¼œ‰LÝ_]åŸúë®Ç†‹«¤SÃeâ\\‚åªÏþKT<	©ÉrëÕWËœ„ƒ’iû‘Gª1Mâ[‡Y.”sÏ!”ñWH¡‰vEBa+D-8×c‘ø¶çHÍÐ‰õ¦Ý,á²}üxõp%6b¦H\nÑ#Ÿ	.mÖSvd\Z·äwò­\"Þ\\OŠ•˜~1ý8Á\"Ð4ÖŽ(™Ù‚R¡uð¼ª\Z@ã\n¡íÅgËŸ½ûƒ8sÉ½ONŸnZ·ÅÚŒQª9ž{\nþWÍS«;ÕhûÆÏœá;c)¾‚ÛÈ\'.uWž¿¿ñF™Îë¾U»§þÑÏÞ³£¢†¶LœK°\\õÙ\'`	œã`QÂ¨e‰Ž	 \0@·`b«€¥J+‹`ºüÐCJD‡-…µ¥09‘ªL$,*%ú~vtj~òã|‡dÉñR^­0<VÅHG´]ùÉOH©bÜ)ßÖ¤juóÜ9J”I	˜wJäKsƒT™åi¤Lª4\n$y¤<…Â^‚(–“\näJgr‚ X~’ST¸YO„üOèDF-Áý.3òÙDQœÑ‹ÜÑ”Ò¸V¾g´`È$²	+T®²qÁµŠ½øÍoªSh)Ö‰#X\ZJ~´Ó¡”¤ÄðŸx‘±é›`	1ät?ð­óçN*\r!¾êY++°E›IÌ4’\0ƒÖm±Í:Þ~í5Âˆ:ÇótáÔÇüt*ç©ìã‰jt‚%Uå¥×Ÿ{NìRxû„—;¡R9 bõO°L°\\4Xþõ×¿¾#@·¶ø7‚rY)h—šíÈ¾ÒÛf–ï•°®^ÙUÍæ\n\ràÊ¶ˆ\"ü€NÁG§Éfõ\\^é¼q8pææË/WlG«@M¶×Ôd!‹!qœ–A¤°«\nÜ§™×ž}¶YÏ+Ø©A\r§¥â6½Á’ªFûçd@xÌœÒ´¡mÈ26ü¢X¦‡Š‘@é,UÿR±º£]:6M”ˆç¹–¡E7^zIéh«ž¥”RÖ„Å\rEXsYÑ:\n\rÏ¡ð0ÃnH†œ V5Ú`9¶fÉZ€£˜È˜ï¯‚e‚å¢ÁÁ\'°‰?1X=Ìs	ÊU>7\\ˆ•¾oñ-0Ù%Ã±²„Pö-¾í%«Þ7ß¤òHÆ1°tÓ¶‹Î1LØõ\0‘öÁV}ïèQ¡†Î@4¬”êSåÇð²ˆ¯Ü°;[­­b7Ë[Ðä†åÝí×_·[BÌØ;‘ßXBK{&L6.«Í¦T¡u,²Á+h<>K­”‚\0f¬–¾“ñ\nïš§„È.oTcm`i‰IaÅH)øúëŸ`™`¹h°dùù;¶Ÿ!\nGk\"†ªœ(28:Á½øÆÙ³ k¢˜\Z²Ì$\\¼‘Ãë:ëÛ’	É‹Y@Ô‰J\n2«+ánO¬†\0#ËÇßôQB*(¼³ž¤Øf*I6´™`þS~ù8ªŒ²á”+ÓÉÖ	–ˆ³¨¡ÈˆqŠ;%òtXVgúàÓ“ó3ŠËN°ŒÑ³ŽaŽÏÚþ+#’à-˜ÖÕ	–±-ýã¹Y¸…¿±XBf„C±\Z{–v9Ðk¥–bÞýõO°L°\\4X\"µµºÓ¹ïÊá9QßN‚°»ºÁÒoŒdáâ<ˆ¡½Ù¿H ŒÖÞ„6dí‰•Ö‚¸2­ªšó7ÓõDŽ7GÂq}`É†¢2ZÄ¤‹¶æPY–ØÇó‚¥¼¦ý`é€d÷¯	U	Þ–nKÿxn®yÊšñD0\Zjk¨ÆÚÁÒ£ÈžXû`­.÷×?Á2Ár¹`)Ë2j|Ñ%k_kÔ+½’4X9\"¼Ç\n\">UŒ›`Y\ZWÖ–mw´áW8yø°=±(Ë–‘àáõ­-qòªU¬gd2æÁ2±ðÌ_àaM`ié9A”ãÍ-q¨ò–6nÌ8¨585hq-€eÿxž.\\Å®<Ì«{–ž‰t1Œ²Ã þK¯¡˜p`$X¶?	–³ƒ¥Gª} 1Î¡¯E#ûZQõk”Â˜Ss%«›Qä9î#®Y¢œFç0Ö!!`‰+íé½JÜ(~˜¿ÕæK{bÑ£U«¦ê`DÌt=	&lú\0Ö–¸ Õ:l¯ŠP\Zd\"Óq½ª$‚Š7,M´ÅCd\0,ûÇótá,@Ê{¿Ê=ÎŽç{–F2:ŽUa‰âxê2j†Gö&X¶?	–³‚e;Êî‹”(…)­øÒj™Í;ä•Ã`É*N´w™~•\'Ì.1ºÌR N%„@$‡xL\0 ÇiTÔ!¢¶Œv‘ ‡´KÁ¿\"/ jyU’bÇÎt=IÉ/ ¶BA\\!ø³&°ä‘ÒyP€§K¹	°•Öœq—– do¶ewTÈâ mÏ…³Øé²Á¤s„Ô=KG$àM‘çÊXý]ú¢’T	–]ŸË5%ÈÞxW¢ÎÃG„bèíeU¬ : Cû	«Bï tgò€%D/ÂU¥w9§€‡úÎ•ÓÂÅöœ¢Hmj…d§2Ö\0¢Ô#LäˆgõEÓ»¿˜×â¶œYU„€s±½=\nz	 ÎeY*<‡Ÿšõä»„|€W /lA‚P%Ræì`é:¦×†éÓÒÉÛ«¡‚×Aûý—–°Â6±zœ±ÇÂ[8%5ÚJõçXxÜxCp™‚íEïkP¡lÝ[°´û´\Zfõgä—qã\ZçäI°ìú$X–4ûy°vÅù†öóhO=’z\0,m0‰Œ@ÌæF<K\\Â…¢±JRr·¸ÁÃeNø±úXsãï>—ÄT-×AÀê*\0–t0Ïm¾7ëÉÂdl¦òxgv°¤g‘hÓÛDxV%Œ©sÉ`‰òç‘	´¬NÚ‰¶ôçvá ‘:Â¢«îXÚãÓ\nã¯ýõ##¯¨”`Ùþ$X®	,}]‘b»ËãU£å$£ASÂ³o‰ÔðJ1Œ«kDµD°ÄWI-ÓÀÓÆ›Á}ä‡žÂ“Ã»âîŽS‚s’ãQ¢iHÔF?±0âôfÝË›_\'l,[äÑc‰)Yt€ÕÕ_O”qýZ‘¿É_ºD_W¢9nÊŒ^ÖˆèÕ9«•Ÿ–!!6ñ\"ú\ZÙWùâìÂ­Vœ\0K»ì`]uÞý¿ùRä”Ž@ŸÆgKŽ}\\B&oŒ~û8h\'ÚÒ3ž›…»ñ^ð¬8ìuÇÑD–_C?€¥Ot_™Þ_HoKT,by%RËËÄ¹ËUŸ}–v• õ°<š—QKeÆ;ªðÔáâƒ¢—˜!ÂzJ [óÖ\\Éq$)%÷ŸË|FÈb8N7™2%ã€êiî!5ØÚOÇê‰µG7QE-sÎ›!´ZìEÖ±W:*¯{Ð¶)ŽçáÂ)A~ËÅwGMe¼þ4Ÿ“`™ƒ$Á²ó³Á2i–Ðbÿ¶Ì\Z&%­‰PRe¡rcÏ2k¸”`™`¹1¤³»úI‘®øíds#ß“’B×}ÐùÜÄ¹»—µß£|™S{#(Á2Árch\0,q•wvâªM°L:8`‰¦è`ÖÔ—9¯7…,,÷3± Gô A+ÿ9F`Ù‹ˆII³kùŒ¢Þˆ«_f\r7ˆ,,“’’’’,,“’’’’,Ã\'Á2)))))Á²ñI°LJJJJJ°l|,“öqë$á»Ë¬[RÒA£Ëå‚%Gið\rq°È2GOÒšÈ\'©Òûm¸Ì\Z&%(J°\\.XrŠ´oO\\æèIšesÇ†A|Ùñ:îWZfÍ“’%X&X&ÝKŠJû\0}ŽÂç0÷<u%))Á2Á2Áò ›½œ”´|J°Ü$°äð6\">z®øàÊ‹¹î¦hÜÃ0SMh×Zo0 ðùË¿xño¾IÍ{Buxû¼`É{ýÍ\'Ó!LÑ¨eŠª¤¤ËË6X^{öYß!ÇÕq;®cq©¡n¬õ%ïÊæ»uG+\'`)eú\'nâå¾„’ƒu7zƒZ51qaoäšõONŸvfâY¸Ë±î[6ÉCN¥T·*ê\'à|\Z°¹Ž˜œ¾¥–«¡Áonæ;·!úÔYÝùï!g`Q™ÎÕ%ï=ZÞe}í™g@Ä¨jp8\'·lúí—¾ÿ}žõ\r‚¤Ðd·]uð=”z5\0V½úêÉ“\rïÁðÁ\\Ý»É=‹z–ë&®<þ8p?røÙŽ7¡ÒG®…^´L•””`™`¹,¹C8¾ˆ;§â­ú‘¸sÀ75\n3­Õ‹À\'‰rò”ÌFºõÊ+j·jbR\"·%ïxk¿ò¼êrc¡ÅÛ‡OW†Û+cùÜj+ˆò}È«ŸâÝFJ×-¸6ÁÚX,7o›§q‚d1¯æ²\\_q©²8e}ôêX&Ð[EÒB—x f®¸Q–ãï(1Ë”YII	–s}öXJê!=¹p\nÇŸïqõUûoç;ì4À»yþ<—l(¥E¬±ÒÕÆwŽD± ï€Ö·¿\rHðî+à¥A(ê®	ä¦]¼ï¾/.\\ i<‹‰¦Ä[¯¾ªlX<ÂÔjSMÑH\\\nmË3‘Ê€¯JKàPô¥óDßPm—ê\n0èú©SJÄ~ÅÀÅÉÉÛa zSœw)Ù¯ÐÆÊ–¶SmPr—/ï…Ÿœ9#ˆNäß\n,!L[]•L·’GÈÿÊiÀ¾òÄ”O•Hç\Z\'¿¿:))Áò.?û\r,‰­JŒ\"|•Ø\\yòI6”îJä¸ez%Kw+è«D™;A˜ü‹kT¥Ùû\'¡âNÔ¹³&K<„eN–\0mýTãlNDèOû`ð86¥Ur0ø†Áòæ¹s;â4®Q¥‡P5dn–Ù0ÍáNõæšeKð^)xMËœ(fZ–—|°ºÝPéö*S¥”ìöï~G%¡u~RR‚åÆƒ¥1Æ$å£­­é\0¼\nÞ„<ö˜SXÓ\"\\±åtÇzá…è_r´%Ö„«›’2ÑìÌŒà$kûá‡\'Þˆ-¥?=s¦ú	%c,Y›ÆÇš*\'‹šBôéµÞ~°dñUd,D¶»íoƒ%øZfÈmìÞiøÏ®ô´#“’,7,cHŽB6Ü•s’@•«\'NŒƒÜ|ëÐ¡H¸ï*O,ÂW¸[YŸÀvII^Öò³‘úk¢Pªz–KÒy0\"AåƒBÁ	AÈ\0<–ï|÷»6Ú*R:AI•7[àŠªñù‹/b×Ž¥ùÀ_ýíZã¨Á2F2+è­;Ì|ã2ú‰V„}¿Li•””`™`¹»}–Dy,ó‰Ó,VÆýœ`û`šÊ€ÍÑlã„w®¿&JùüW¿ªJ`M±KòØk¬¢F\'ËXOÅ Uh,ÀÇjÊŠd³ãÔ._«\Z,\"bÃ\r€%¯ŽñY\"V.•{Z`{*‚¥—™¥ ˆ¼äÐ.Sf%%%XÎõ9p`é\0¼©`f\r¦ÕŽ«ŒÈA\'ò·Œ>5|\nHpW–D˜W®óeÂ_×¨ÉX\ZÆÈk,/jÞ¯Wx[…‰%Ì¦eiÔ`é•H™æð!ò‡¿·_{Í;¦sSlwxó\0X\nÒ0mW±Zñ}·`i{n\\>rD¬–:’Ç¸\'%%Xî+°Ô:ßŸ¿þõjËüŽ`	äÈe§8X¯`9þE/Å:PçFM†Àzÿøqybíƒ%¥¹g?zzc°4Ol¼V\r–vxz‰·ŸèÄŠ¯_´[°¼úÔSq¹T¤8ïà¡\0ËÀ7©Pð¿L±•””`9ËçÀ¥¬íãÇË<È÷èüTä‹òüüó1¦TA@1W±”Dù¥š5KÛ»ŠÞÄ¸lrÏ\\ØJ¤Q<n°´ñç-+qj	–èJ!,¶ÂötÂÌh1lƒô¯É^î/ÿö!;èf\Z,oœ=[Â\\½öôÓ»KV(©$€íi¼»%ß8®v™R,))ÁrìsàÀ€±¬G¨~€¸!JD¬©+¼}ìØª0ìD9v!H duœj¤VMÆÁ2.êš&±Å‚Ì\nŠQXOÅ%«Hƒ¥‘ÀâÈf¥æøNI1X: Ô[N7<ºð¬õQŸ{®l˜Ô¼š<²,±¹…ß™ƒ¢*ÁÒxÌƒF;ÖSIÁøÃ= €ûÁÒ\'H°\'w·Þó•HÝ|ÃþÍÞ­´„a¾8¯Èëñ6¼¼ŠU£Ð`hÒ<èG~–:1\Z6ÏÇ{ÒtÑÍ¶Ì»ÿì?³WWù$%þyd\0Y‘‹“e•;¡Ì”Ñ3Ãh)ªž×ÈÊÈ½¿­¿žÖ5þvÎä›²l5eãð=QkÜŸÒæŠK–µ0£?óvdÉ²–œ6sô´E>}«TÛÇ®þ˜Yß¾”¯_ÝËrúd±]ÉžÌç€ÃeYÝ=õeCþ_õÝX­S©¾Èyd\0Y‘¹Èòþ~Ú¢ÒËrº¶=Æt8N¡“}[ò‚§^–U¨}ÞSšR2ê§ƒx6yI538íƒÏ¤2ZýGµ†²¿\ZµýÍjªâ©–|¤õ·ºa÷^!9µàëëtëôËTšcr†Ó¯™’1ÝOý¦»­”,rúÍü´tÖÔ1µ†§JÕ½ƒSÜ×¯Î	g¿ºæòbu{[{<õóä­Žœ\n8MCíóº%Šé÷6¹mEmî¢Îs ÈòˆÌD–G™e*o¨´/É&?°^FñÏ¤*­T9G¼;%ŽÉùÔÓÙ^–ÓÂ1A?8s¼9æÏÝ]¦X?¿Ôq[;Ã!Mr™w=íÍYÛï£4Çâ’!ËYÉrÆ¤á¨=¥íïP²<Ï/€,É_ å`zkÛ¤qµŒ’%\0²ü~Èr>L;†Òƒ“OÈ\0Yž$d9ò mqs“¦ÙÓ.òËÐtßx«\0²$K\0\0Y~²\0å d	\0 ËAÈ\0@–ƒ%\0€,!K\0\0YB–\0\0²„,\0d9Y\0Èr²\0å d	\0 ËAÈ\0@–ƒ%\0€,!K\0\0YB–\0\0²„,\0d9Y\0Èr²\0å d	\0 ËAÈ\0@–ƒ%\0€,9½,×ëõr¹$K\0¸L¢€ˆ€,É\0@–GÉ2ÉuÙn·›Íæíí,à2‰\"‚è Rˆ\ZÈr_–¹ƒh²\\­V™³~yyy~~~zzz|||xxø)\"\"³K†÷òê3àgØÏà4YF\nd¹/Ë½™ØæË×××Åbñ,\"\"³N†úøÍ”5K–úòýý}êËãË]~‰ˆÈL³Ü%þÔ”ÑÁñ¦œ½,sQ¾Üì²Þå·ˆˆÌ4ë]6»”)£²<È—Û]þÊ?öêàDa(\0 `ÿ\rm!%©dC¢ò…\\¨\'ÿL0ÿá;Sþv–×—OÇ°0c8‡¦üù,¯//\08/5e›!Ë—€)ÝK›\'K\0x, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, È\0‚, Èò¾ïû¶mëºþ\rË²ÜnöìçÕ”0àø?÷Ö)ea!ÉBÊÆBÙ(ÉB²\"IV‰ÐM±°P²…®…%F#cfÞût2s¼s¸sÂ{ï|ÖÓ˜wÞsžï¿9ŽÃô8N³Ù–P.—kµZ§ÓY,¢(âË“w\n>nµZÁÍüõ©ÝnO§Sžç1ý†‡F£T*5›MX×ápÀ\ZFÑÿKçããÝât:aD’’Óï÷RÙl_)\nŽ+±X\'“É8¤¶Û-&ƒÁ\rÃÎb± [t:]0„YeÈ	HÇoÂã*•ÊëwŠÎv¹\\ˆÀívW«UA0Áñx„Kr\\™ÏçXË²©T*…\Z<BE£QøÃ@·øÐý~GR·4†”År¹\\Âÿ<º¤h4\Zá/`\\\"©P(„¯$U¯×±\"h’Z¯×˜ ŸÏËãAî×çQq‘„›ð x<þú\"èõzÐt“ÉÔívñ-›ÍæëÁðžŠÉà©Iùý~üs òü“…ÃáóùLËÒ4\ZºÐK˜¿²‡keÐ¤áp¨>–pˆ–úXÂlºyÿ ÔÅò9;uQ,Ñƒà%•P¹H$òª¢ŒÇc½^a·Û†yÿ¥i4Ô¡&–Ç‘‡ò†gs•±6›M5±E‘ü¦õ}/)Šåsvê\"•J¡½$´Z­çe0 ¿7ŸeÙw^šFC#jb™N§Ñ-f³Ùëõú|>ÒO€ÑhT},A\"‘PË\\.‡à%Ìjµ\ZF…ñÇóüËc™L&ßj§Àh4R¨¯é“Â—Þ“ÉDVÒív;ü‡½ów‰c‹âø?wáUél,/G!MB0URäW“Bš„Dl‚ØXˆ…Z‰Š´ÕÂBÁJˆÎûÀ{,Îž™sgfg†¹û¾Ÿ*˜ÝuïÞõ~æž{Î™ÂtÏÌÌ„8ó…¹sçN(annŽæÐ„H”ddi—ì2vÖu|||ïÞ=»h²«›\\–À¯™,	K†\"=zDøñvœ–ÄŸÂ³·/_¾t*KÎGÿŽÁ–qP3ÅÇ5;;üp}}ýöK‘ˆkðCk”²\\$^°7£¼ÿ>ñùóçÛûo’t¸øE¬­­\rshB$J\Z²$?>€’`©•\rö­È’ï¤,_¾|YýÄˆÕý#’.dÉ‡ÜLQ…RxhW(u>=¼âl.}£\09ÏÝ%*6¾\0eyI‹‹‹…»Ï*M²b\ZdIYž]œ²Š?òlll´\"KxöìY]Y²²‘ÀÇgåœ‡XÃ—eŸ3Å¾<äaS›3¥ñ¥usäYÑ(Àþ¸£ ®`ØÜÜÌÊaÇ-j\rM²b\ne	¦–Ñ£-Y‘ÒZ²¤Ö0¨œË\\^¼xòÌÏÏ§(ËŽfŠ–èÔXìfãV7\nçˆô‘èÚ(œéÚHi4©ÊF¿	]Ôšd)DÚ²$¡0ÐÄµsÿ²´ªóeiÿ÷ÁƒY¢”¿óPB7|Yö6S«««6PiíæòwžbŒâñêÕ«NÂ:9«œj[ÿÕšd)DÚ²„²ä@²9(iØÛÛãâº7Y’ØÉ\"[Q–>y²F_–½ÍÔ?BŠ÷[?,trg£´^1r}}ÅØßß†C“,…H[–!C–ã×¯_óOšI‹²$±‚]‹ãòeI¶Ž}Á¡Éf\\ÈQ\ZÔL‘/j+[Z—%£¦-ŽÝÂžžžvdú¾:)»þ¦9V7šd)DÂ²$Ig€PÎüŽŽŽZ‘%Ë]Îƒ‚„*²´½l\nÛr®¬¬Ì»P¸Ò©,}HÔLÑr6äYZZÊ´Ìw!œëË’—;V`ÄÉ»0\nÝCž§OŸf.Î7¶ÙÐ$K!R•%PSaCš><[‘å¨üÃtGe¬\\UÒ:ìIg²ìg¦èëòðøÌ@£ƒÃ—%?çÎ0%M*âF!¿w!Æí¹còðíÊªas}¹Vh64ÉRˆ„e	ÄšÈx$*Xwž\\–œ´ñ{mšbT–„¶lNÿtË²‡™¢ö&ä¡sP²U¹6©ˆ%>­pÿþýÑãiÂò<þ¼qã\nB\ZM²\"aYŽbòDHÿ£éW¨\0\rt&—% ¹Â£¾,ie`Ó(†&KŒ>ëB‹ŸAÍ”í0ðæÍ›îd	Ož<±M*ˆ¨·+KæÑ™w§h§ÙÐ$K!Ò–åXÏ3jûè¼Êj^Ö”ÅzBYúÙ+˜À‘%©³¶b²,ÙK%‘\rÛÏL‘`åTLŽøøñc´{EY’,ÃÖÍ6jW–$ÙhÿÍÍM•{^Oœdh’¥Ó#Ë±Òìoß¾çgmÉ’Õ‡+ýY:{ –õ•\0¼NÒ²lw¦ˆñZ©P7™¹ØnJl¡|YŽ¥C+²ôÛs‘‘Å ˆmûM84ÉRˆé”eYQÄ¶d	ççç¬ËQYúw[dù«[cNDqjd9ùL!•hSËöö¶½õ´ow^âF¡<ãÏïÞ½Ë <nÏ¢ánòZíÕUÝ¡I–B¤-Kv!Ý‚½SŸGn‚í!Ð¢,FQYúËzô÷lO:‡/Ë>g\n©Ø½”_¿oƒ·oß¾õbcˆºwj”OŸ>Õí¸¼¼ôYl04ÉRˆ„ei‹ê¾ÿž•ðõë×‡ü…ve	,²e	4PmìXÓÌ‡/Ë>gŠÊÔÂ«²A…Å²”vT7Êèê‡XnëFñûë²ç¾¸¸ÈŠ888àý8ÍÿêM²\"UYR`×Â›xÅj€ÿj?ÁÇpuuÅúUQ–”cÚw¨ele¿¼¼´¾úÝ$Ñî®Ï™â5Ù	z…Eì¨’#½ÂGFâ|€Ý…SÌÂê±½ {J>Æ²ZÉfC“,…HU–Ü+8Á\'y¬Åü…³ÎÚBu€“““Öe	‡‡‡Ž,&p6öHñ	‹W™}‰.\"Q÷MÆáEèÌâ/ˆ>ÔËg¦F›ªPÝÛ9´ã´ïîÝ»¡žÞÌ(À‹wg¾?(°ì“äÛB·?Þ€\rDp~ÉEÀ0‡&D¢¤!Köô±i­ËÒÞw×—%‹Ëw¨Œ½—á„²ÞÃ$²¤\rúfÊ_Ù}lwßÆFáò…	mÝ(&/¬	ÜC{ÈC\"E’‘%Àt­5aWAœ³;Y7»(“¥ÝuUô¥Í„LH–ÝÎ”g™»@Ç!~KI]£Ø}m§FùõëW¨	yÚtà¹šÉ‘Œ,e‘¦ÒÁÁäz˜TÌöeIT\"œV–e®¾²cÖ­­-ž•–,»ž)áe§S=CEB777“H_êÔ(”?Ú:%\'žÿïw5‰¡	‘)É€gN¼¢UÞ£[‚ŒA†¿Ó5-äÁpu«÷¥¿2A\'SÔ©‚àM6“¥ùjðóçÏAÍ”Íä$$ë$sÂÜÜàœ;W7(pd\Z…:mœl2 ™÷öâ¢!­¡	‘éÉr´‚°:pñËÉ×Èì´øEîÿÝ\"1Âúú:…‰>| e°ãÁ»4=È¦ˆžgŠ‚ÝÝ]Ò©Økòë¸ªÀñÔ‡ RVÿ,e()a·ÍGÇ è®ÎÇH¾BdEeBˆrþ×²B!¢H–B!DÉR!„ˆ Y\n!„$K!„\"‚d)„BD,…Bˆ’¥BA²B!\"H–B!DÉRüÃ¾Ýå¦\rDÝÿC¨HC_Ò#Æá¯#F ¤ÝVð\0ö9º+p¤ûeì€€X@@,  –\0K\0ˆ%\0Ä\0b	\0±€€X@@,  –\0K\0ˆ%\0Ä\0b	\0±€€X@@,  –\0K\0ˆ%\0Ä\0Ãå€ž:<ª§‰åþ‹\0½ðøÕ|‚X^\räv»Ý\0Ðe¥ïN3™ËËLnŽ>Oº®Ë\0<¹®ë>O6G—É<Üh±¼<MÖL¶mû{6›ŒÇ?F£ÑË‹1Æ˜LYée±—õÞ¶mMæîè½ì},÷GçLæœgïïùg6Æs¯)«>ç\\“y‡^ö;–_K9Nësüóñ±^¯ùÒ\0ÿ»óËb/ë½îù²ðï×ËaÄòòLùs2)Oó\0@O•%_VýåùR,ÿéX™snš¦þ¯¡”\0½WV}ÝùMÓäœo>\\ö=–õìjµúõöVß¾\0€ú>¶,ÿ’€ú2V,¯¸<V.—Ëñë«c%ÀpÔÃeYþ%çÃ¥X~ûµ²<¯ÅbQ%âFÀ@ì÷ûú{’’€‚Û¾\\ –)¥¶mëËë\0ƒQ7I@JI,ƒ–)¥ù|.–\0CS7I@e‰‚X^ÿ`Ùu]J©i\Z±šó…Ø”RÉAýl)–ßÞîK€:Ç²ÞñK±@,Å\0±<K€¿ìÙÏNAÀñ×áì«ø>ƒÐ–ÖþÑhrhˆ)jAÁ”hBl<A%v•\ZLI¨¡©[©\Zã8Ò„,nñ·Ò\rÝÝ~?™Ó²K&™ý6)ˆ¥€X\0ˆ¥€X\0ˆ¥€X\0ˆ¥€X\0ˆ¥€X\0ˆ¥€X\0ˆ¥€X\0ˆ¥€X\0ˆ¥€X\0ˆ¥À§±üõíÄ­¡NýøyâÊP\00¬ˆ¥cÙ¾>Òÿøž¾©N…V®Ý*Œô9mÞP\00¬ˆ%±$–\0@,‰%±\0by!bI,€X\nˆ%±\0b) –Ä\0ˆ¥€XK\0 –bI,€X\nˆ%±\0b) –Ä\0ˆ¥€XA,õÒ”·¶^.-=Íåf2O²ÙçÅµµf£¡þ©qp°W«éñçNÏó×lûœ¿ý©ÃfS¹Ê4Mýo­Ãù[ïóÑ‘õÁ¯ívVÊ=òâêc››™ÑÇöÙÜÜ«ååúþ¾ò0bI,ý\ZËÖñqvz:<6\Zí9n‡ÃoŠEux$Ò½ín\"¡<Ï_³½ÄüõJ}ª×Õyz»OÝO¥”«æs¹¿vË{ÃPÎÜ‰Ç­æƒ´RWc¥P°Ø×««¶ýà\Zb)!–åf©ÔÍ¤8ô«Í4M¿çÇ_³ý¯ùïÕjú¢þSi}}€±|œÍ*›M}3±ì‡Q©ô<ªªUÛ~p\r±Ë@Æ²º³Óó°ÅB¡Èø¸ýz*ÓËçëüøk¶Îçÿqw·{}à±Ô;ÇÉ‹ïE>O,]ÙÖ¯³ú³ÒkÝétÎö±$–ÄÒ‰ÉIë;N¿­¾´ZÖ_1+ÛÛ÷’IëœŸUç=H§£zd¦¦”çùk¶Îço”Ëgkôvcc€±Ôãa(I2\ZµÇ2H+¥ÔoöÎî%Š(\nàyô(\"~¤b*º¢lJJ«›këG=øQ„–†©¡mn(Âô£ÃiÎ»ÛÌ,,Ë=ÜwæÎý¾çwï¹gÆÎ\n\ZUšãÐëkßx(N,[H€eïÁjRz\\?ž—JzZ6›á_rv…t-,KÓÓ‘W8E#š–AÚ–ßÍ¦4ÝôÄW,,,;\"ËKK2ðzõÄ¤ã0ÀvíÜÒ%°d!Õ¦%Gë\0Ëü~ÈÒtåùù\0Ë\0Ë\0ËNÉÌä¤L\'N8Zž0Y¥&+Ü_…“’(E\Z3¶²²Â³doÊxˆŸ%gš÷÷÷2~pXX_[#…ƒ½=<x£bJÛÑQgþ–a\"ÄøÃÉG¸¹¹I+ÿíí-?ßíìH½©Õâ84o\Z,¹ur|¼V©,•Ë,•¾œœä‡åÌÔ”ßká=<0g\\!Ôb«^çY†(‡sççÎhMÕ¿qâ;[[Ôýíö6Ýä\\ ^]^2hYS¾Z^æ­*žÚ2°ÙÔªÕtÅs–?sŽR—oÒt¼î×Žº´y%ÀÒ/–½K^É’éôzuÕ™7·ûû9=âýËýÝ]çÁg¿ËãûÕÕÓ±1»à(ôg£ÁŠ8þI\"NeŠg<“btÔºìâÝ`4cK±¥->G¡¢üwww6JÖiå§GøéÀÀÂ’ŒxSÈF&Îûýý<°Ô†ýÙ©©(EÎÏÎ$\ZœÓ°l\\Á< ‚\'š­§¡¶\"Ä”×*‰GxOQG†.N7P™gŽ0AÒ<æÀ§áAÆ¹hcj“¬o<ä–\0K¿Xö ,yKÐXÉî_Ê†UT€\r>À\Z]ØëÐ•ÕÀ\n:_i‹ÏÑ¢ŽÀ°÷ûýC\Z»»ÏfgÓÊ_J‡%u‘Ú‰ò9C½VËKö:TÙZbí*M¼7?eð†e—ïï#;\'`ôÒÍfÍäÄÁI®±§°2ÔÓÂøÈˆn“L9¶†%Ÿ&ð‡Ü`é—\0Ë„%û§Äæ	Ä¢·ºBðC:‰ôQ\nìØŒd*,íòœJš¢”TEÀ²ø1¦ÉSlÇÌ°07—ˆ\0•­UÓ–ã6\r«(s…ÀzÈS;êÛä–\\E™a¹^­ÊOV‘KhUÙÄg€%j$Á{†(‰&†Ö6ÃXuT‚Á<EÊøå²°“‹ÖTÀx k=Bà\";~Š”È—3ˆH$kŽ£CCt.í£säJ^..úÆC~	°ôK€eïÁ#˜µÈ1Õ9¢§2ã‡9¯Õçrëëé)WÚ‡%)ó¸èJÎ™ôÝíÍÍ\"`Y|Ž|‡L¡=we?!Û¬DT­¨BÊ`ËŸÁÁGú÷Óá¡¤‰\'ýý—Ì°Ô^\'3.K,‡£*g€¥vL#Ô76´mV/Aà\rjÇ	KpËRã\'£°Åq0ÆêEn—>Ú€,·hL¹Ž‰-§Ñ®·þ’Wž­ƒöÕàà``ÙY©V*–	µ‚õ×ƒÿÂzS/{-tù(×ý°Ðjí#Û)m¤ÊËâs´Ù‘¾Õt‰€\'ˆž/Ò>“ãã\\)\n–$k¿¶ZSÇxd—–\\Á´n-±ö5¤¾>~¶KaP±ŸÖK[¥Ñ,–@ÿÛ,ÎÃiü¼t3Ši”’{ìíäEd!OŽ–ÿH€eQ°„sùƒÀ²üñA!!ê2Á1áÉàà£?ì;JA†Í½ˆ±gò:\"\"^ÀÀ#FF\"b®xÝÙ@#Áñƒ…Ÿ\Z«·vè‡ºKì£·kçU_×£{<)]Æe†øñæƒrR/¥˜s`É‚|É2Q5À:gÂ²½FëèXDYW5ª}y~¶+°T„e29O¦T¨–À’ÚZÏ*‰¢‹4Ë€¥½:±óJLÒÃ’ã\Z)×J½«GZœÒF#mˆ‚²¿˜Á–Sé°ìòë²\\.¹{I–KÅò§9øáuPç©Lt°”“çÍ®|”LX¶×ÈÌuK>OŸS²¨ru‹×•¤,ÙårXêÊXK„õ\\Kbë\"±8‚úŠÉ0°d©˜úZpƒ2l»§–ËÔ˜ÏK‡ÅÂ7Ð Æ§™ŸVaXC>>qÇ¹ŽÆË©tXvù;á4±f,·HHò›5qÅ‡}Þ.†%¡§`®žf¡äÃ²½F…à¨Ëð¶_—]oÿ?¾ð¶,y±ñ\\ð¢–ÈÅÙ™Ï¶\"°ÓîT,íÜŒ™•h–É\\íºÂGI` Þ›«6·ª˜«¤±Ãr*–5äýókÿj(ßŽî>Æ•ÜVØÿéó,×Ý¨”ª~ÕÞ±±QSãóÓÓ ºŠa‰ánËö\Z5©Q^MVáÐ³îÞbW…Ä¶€¥\",ùUSXúYIü1Eã¢Ðy°ärR{:Ì€%#’8lÀÕ¾qôã/ZÊÁÔƒß8¤$#ˆ”kì°ü!–u`¹w¹(ß&°¼>(Ü¶–eedÓ£FÜU-ãˆ%AÈ–TÌ·…e{d@u4©é„òóªÁÃý=Ÿ°F„;ÔÅ°ÔÞµ‡%%->GÍ­\r,çÁ’ÿxc1,ãL\'_9uNÜ¤ÕÏ²ÆcŽkå(.ÔØa9‘Ë±Ã²±0÷\\“±´Ö],v²qÚØ¨1ŽGÍrv–\Z:h\rOLªæ“È”ká…1¥hë`©}T$ÖŒô‘XZ\ZÑmEXâçÅ®§N×6ËÝ‘œ&\0«f~\Zk‰ÆË©tXŽc‡eS¡JP÷önœ!,\"c 9>JøÙyXZr|¬ü–¬˜­÷A^—Ž3óU¶–Dïm$–ßîu,ýpÞ^¿Ù;»Þ¨(€þÃþCúJ?úŠT•öõ•B¥Q…\"HCJ 1Gq5›ÙÌ]â’µÏÑ¨¢«Ýµc{ïñ\\ÏÜ9èÌpeŒ7·)«Ë’sºJŸ•qI+ŠæD3\ZŽ!9q—yõ1[T–(ËaP–WcÙëCCúÚ“¬gY×ÜúëÙ³Îœý9È’ÉïõÎø7éÊv&	9Øz¶É†Ê’Ÿy]\'–Y1!¦©\\Z–¿T§SÉ6üŸMeY×Ë%1>\\@}ú¸ÈË‹Ô(gø+Ê¶||;“Šñ\\c¶¨,P–ƒ²¼Zâ—ÖRÏooiœÁ~P‹ŽE}laòûLdI0­ÇzD/³~ÃÒG\\ýýo+ÍÆ<Âk”e{wEv2õÊ‹—–%æHÇŽ!žfeÍ¾,c]¼è;SO©L+æu÷1[ìË2¿Æ£,û(Ë‰É²-ÀÍã´2ì¢åÉÎNJâyL\ZÔ8Ýñ:ŸÃ\"TŒãõ™È2B^§,jì”ïì;¡“ŽìM%¹úòz§^ü%*øð·ôËÏRT¡Ù\\.KîWèõ¶¹“ \0í0%Žjÿƒä„ã\rÌ \Z³Å®,óëa<Ê²²œ ,¼Ãp¢ƒ/¸á%Ä\0$§D™‚H¨6iÕ$|G¦7²Oäâ(›Gö¬|ç¬dM/\nô?nm{³VßŠ¥Õ¥_ÉÂqšÇ×%Ë¶RÀ#Ëº\\»n9ÕàêÜ&wxÄœT–ÁÏ÷îÕßLÊ·–to×[&1SÿçŠæs\"jÁóÌrÌû²Ì¯‡Ñ(Ë>Êr‚²ÆÁF8[±1….\rßI°ô#å8mYFßâ¢:AÜCœ[}\"Ýÿvêz»ZÓuÉ²­!@ûîöíÆÉÞ9“’åOãbn«­¦²¬ýÄFÛ…YÚ•gØ%Þ\\ßÄ\\äð4\\r0ç^çûùàˆ-&²Ì¯‡Ñ(Ë>Êrš²,·½érz’H\n%á»!Ölj·ÕÄ‰Ó–eùxçy[‚­°Ì÷¿]¥¤YÉä:eÉÐ’zÈ\rŽ”e˜€é›kÓüþàA:u¤…ÐD\n$-’Ì´yšNQ‚èáñ¶1[Le™_£Q–}”ådeYN\rýEn„;?òŸîÞ¥æg\'Èv1>æÇKôñ‹ýþÎâf=j‘­·ðZ©|Ý{ò½½ú-¶‰Ö(ðÝ€ƒë,Óýo;FtêÔ:ÿ^}Ï9/œrxò\Z›£2Q§ü/ºê=g½ª¯º®Èv.]§I´Õ_yg5Ü,Ñ¶ß\\ö¤ž4Õ®.‚ïëã_êá\'ÀT–5n±®ÁK’ú×Ãh”ee9eYÖ¡Ä,Ï„p\'3üx¸BÕ•ˆ€WADRòuƒ¬	ªåÑccf\'t˜:ôÈ¹h)²A•]nËøßõ~3¿¾œ§øÑ)ìÃÄÌó~>ÅgYº•W.½ÅI^ÊRYn¼,×£{¸›&}Ä¨„R°­…ÎÓÂÐP™ÊRY*Ëå3©ØÚZzMva_™ÊRY*Ë…aÙ&˜²ñ_¨ê\"\"3@Y*KeYÕÀ«åG˜9Àâ½ßÞºU,Ô%‘y ,•¥²\\€âe€_¯•	\"2”¥²T–K*Ð2r§­{³ù¨Rdf(Ke©,—s||ÌxŸßîßGœÌ°dN£ü)§7ˆÈüP–ÊRYŠˆ(Ke©,ED”å…(Ke)\"¢,”¥²Q–	+Ëo~=ßB–xn|S–\"2g”åee)\"\"³AY*KQ–ÊRDD”åE(KQ–	ÊRDD”e‚²e™ ,EDDY&(KQ–	ÊRDD”e‚²e™ ,EDDY&(KQ–	ÊRDD”e‚²e™ ,EDDY&(KQ–	ÊRDD”åFÈò‡9d¼>ˆˆÈ àö	þÊ2—å‡ŽŽŽ8R=â¨\"\"2ø„}‚?\n@è@Y.‘%p\\NNN8FoÞ¼ùóéSŽÚ«ýýADDf\0Ÿ°OðGˆ\0 Ô ,ÏË’;ˆ\"Ë·oß¾xñ‚£fçRDd”n%àŠ,‘‚²¼P–²ÃÃÃƒƒƒ\';;8þ«/ED&A>>ÁðŠ²\\iŒÝðýýýíím_ÉÇrìï#\"2éö’}¥ð	ûÿuŒî™´,ã±åû÷ïé†¿~ýzoooçÌ—6›Íf›p#Ôð	û,•årYFç²<¹¤?ÎáÛÝÝÝ~ü˜ñÄ7óÛl6›írÀNx\'Èê	øåiet+•eþä²$cKÿ’ŽùË—/Ÿ?þ÷»\"\"²á”xN`\'¼äKŸ²$`×ð´r&²,ÉØè_’ÂæŽãÕ{\"\"2	JT\'¼ä£OY°Êò«}Iòš{wïÞkþ#\"\"“ 8’ðN\'Ô¯Ó”“—eíËZ™Œ˜:úÂ¿\"\"²áDH\'¼×š\\)ç Ëðet1áä@úODD6‚yöÊµ˜r&²_†2Ÿ>}ú(\"\"“€áý´bÏ|dY8mø_DD&Áé7S“&ËàTDD&ÊpSÙ<YŠˆˆ¬ˆ²IP–\"\"\"	ÊRDDdøÌ®ý»$ÇïhujjhphðŸpˆ†ˆ\Z\"!ÚZZkhL\Z\Z£Újhi,š„†ˆ††žÐ‡²@ÍxåžôžG}ôTîô¾ÏÁ—ç0Ã>AïßáøÜÏíç½ŽX\0  –\0\0ˆ%\0\0b	\0€€X\0  –\0\0ˆ%\0\0b	\0€€X\0  –\0\0ˆ%\0\0b	\0€€X\0  –\0\0ˆ%\0\0b	\0€€X\0  –\0\0ˆ%\0\0b	\0€€X\0  –\0\0ˆ%\0\0b	\0€€X\0>Šë8Ži*K\0ø,\\Û®Äb…ííüêªþ>8h¦RêÃ´«Õï##ß††Ì½=b	\0ƒÎu[[‰@ÀKW×JOL4îïÕûxÑm$“­RIu¨^\\è[d¦¦ˆ%\02×¶³‘ˆ_ÇäøøÃÌL*Žë‰·Q=;Sï /UÜÝíz›Ÿ¿…ªçç\nÄ\0™ê(ÞƒÖõµ?o[Ö¯ÍM¿—ÎÓSb	b	\0ŸN3“ñsØL§Õ¹•}Àãâ¢ê­U©8Åbcé¶ZN¡ðöo…lÃP®«^å˜fÛ²Ô \"–\00ˆŒ\rÝÂ¿§§½\"”\n‡õ1íZMëñx\"ðV«T2÷÷oFGýâæ×ÖÚõºúï6ìü+TŸÕH&;÷–ONº^vv2ÓÓ:±ÞÅ,-Ub1õ\\6ñÎ5Ö×­««ôä¤‹‡ÙY;ŸWÏÙ¹\\vnÎ’›±1ï9ÝfSõ\r±€¯ë.ÒñP½•ŽtcÊÇÇzR»¼Ô“ŸËËz£s=.,tý¦ìZõD¢sïŸÃCås]ïtoøbýcßŒU‚0ìKY‰`kåCXŠ`/6\"Š‚ZØZXÙYXˆˆ…M0IõH41‰è%p!—Í/s,Ëw \\!Ç|l!ë0{ÝÇÌìF>¡ðLÒý#íR²}>ËÈ¯ÅB¿ªÓYòz°,†aÂimüï²RØ®RÑd‰µŠÇQö¡\rkÎfÈC›ûFC>á-g³VÃo,ÑK–(ø\rçr \"-’ãÚ4§SM–Xxr\Z=[Ù4Þ•Ë25%U¨$iä<t:öÞë‰€`Y2Ã„“ßãÑQKµ*|°m\n3òyM–F•j•ÄÂˆ¾3K]–dVJ‹«PÀô\"ó1•rËR{zÒsíã÷õºPÀ+ÒçbE³–%Ã0L8ùÙnI$ý¾ð}Z„=¥Óš,Ý®‰ú’þ²Öëke)Óº‡Žoí6õW5Y®b1!QjSLCåT!ÑË\'Ý6,K†a˜›Ã6M’ÓK©$¼ù³,\nC“S³š9Ÿ{U«ÇáðZY\"À©J]œ\'Ç£†¡Êr“Éh‘¯Í¦6…E÷;´î	Ü	º´sm[Ë’a&¬BpõTxó½\\ÊN¦&Kz|éV _+Ëm6K% pam6tâi<Vei\nº,[­EäŸ½;Xi#\n(ün‚oã3èÎ‡péB7‚oàHÀlé\"J#fl%Ãí+?37‡Yèx>\\„4MÛÕé¹ÿËÎ›ùBnü°Üœô†¥±”¤ùúqt”o=¦~Û««÷PÝÝ±¬‹ÔÛy^noÇÆ’¤ÅÊ²÷êîÓÓ¸X†¦aAÉ¨Wn#™Ì½¤IKIš1&\Zs6~]\\ôm\"<¹aÌ\\±ü}y™ºªûûüKq06–Ä¬oÁÊÍÑèèøX–êå2/4ÙŽ”&a,%iÆØh\Z£‡¬ÞÏÐ‰yÿõÙYB7–4i¿Û¥Ð4ñy^Qd\ZäãXòU1¾Y”ƒÍTåØXÒlÆH8·¯x™|16MÄXJÒœ1D³ü¼ŽsmxØŠÅ˜ß/æ,©#‘¤ñÏjÅMÇ÷²žž¦ÆÿóÅ^ÖŽ,Oûb‰Ÿ\'\'ù6ççÜ§¤ÖÕbfærl,Y¤æß»:>~[¯ó›ìKâ[–&a,%iæb¿hT3g,Jù÷ñ1¡Ë8[.>ÖÎ\'‘K-< ³ývõÅ’”2\"yøñØË±±Elïë‰>¼˜îÆR’¾Î†eíUô‰˜±Fl?‡²ˆ|~æ\"g”5Ïbr›ópF…\0âhÖúá!by8åÙTŽm8|†|n¯¯S—dciXÜ…XþÞiÿo€CõöÛmšŒ±”¤oƒ)F&\Z_nn˜’¬—Ëæõ5e=±Ì½aÉÓK8}àM³ßíøICbc-+¿|ÙvM]smùm³IŸ•±”¤ùèÄR0–’$c9ÀXJ’Œå\0c)I*4UÅ¸?Ÿó„Õ¯ËXJ’d,%I2–’$ý—±”$i€±”$i€±”$i€±”$i€±”$)ýc¿ŽQ€\0_îA .uú4ér„l¬o V\"h#(Ø‰• ˆØˆXÙ(ˆˆ‚èÛ×>0Ž®Ûdù¾Ã4?sX@@,  –\0K\0ˆ%\0Ä\0b	\0±€€X@@,  –\0K\0ˆ%\0Ä\0b	\0±€€X@@,  –\0K\0ˆ%\0Ä\0b	\0±€€X@@,  –\0K\0ˆ%\0Ä\0b	\0±€€X@@,  –\0K\0ˆ%\0Ä\0b	\0±€€X@@,  –ÿÆn·›Ífý~¿Ùlöz½Éd²^¯Ïçsú€ý~?ŸÏƒA«Õêt:Ãáp±Xd3S\0~§_ËF£ñž—E(ý[›Í¦R©¼¾¾&—<==‹Å,xé=‡CVÜ···ä’çççïïïë;Çã÷¼Z­våår9T«Õ÷¼Õj•ð_Æòëë+Éëv»éýN§S©TJnóññ‘=šé\rêõz–ØäŸŸŸËå2½¤Ýn\'y…BáÁ#d…Nò–Ëe\n€X^y(³×*¹ÇËËËt:Mv<óAŠeYFÄ27*‹ŸXü@,ïŒåv»ýÃÞ½¼R×†qÿçî¹2Pd` %ÊÀ¡ää”˜ˆÉ3#R¤$‘SIIr©­—vî÷×.Ú«k­µ—µ=ïÓ›ïgèÉ¶{&ßÖ}¸Vii©Keß‡ÑN¤ž>‘°—ÅÇRª««õ¸L, ±üf,;;;c«ªªbRªÒ±o,,,8‰Ø¤Ôg–••¹%%%Úæ,>–255E, ±üN,×ÖÖ\\˜öööóóóüuÚ‰‰	f``À]__»0:U›¿N«ƒ?¡%ÖßJKKÏ©Ä\0bùX†|Í;k\ZpppzZçööÖçéééqÆèè¨óüü\\QQacµ›.–ö9UëÌÄ\0|±L\ZË“““øªYº%éŒ¹¹¹üçEÔ¦¦&íîîÎGGGébiµ¶¶K\0\"–‰c9>>n73™ŒÕÜÜì‚*++ý§\rghø€ÕÝÝmœ:––Ö{‰%\0ä!–ŠeÚ5X]µô…loo;ãþþ>*BõõõInyþ”Íf‹Œ¥\r6±€/Ä2i,“‡‘ø…Vmgúœ††¤‘@>•\"ciõÍ‰%\0äKÅ2ÙõJg˜‹‰ájkk]æÇú{Zgooï¿¥þ¨Šn·c‰%\0äËd±¼¸¸°–>™¶¶6¤‹•>Gâ‚.//½±¼¼<KÏ¸ÅÄRt5«Ý: D,@ˆe¢XêÙËiÓ\'Óßßuý?|;Ó°sÕíNg‘±½Ä¢–?>>K\0 –‰byzzjçõ¤ú£—xø»øy||ü·bùúúj1i±\0b™(–OOOÎðÉØS<Zóô9\Zà‚VVVþV,E©º@,€Xöññámd&ùE=ƒº ¯RêÐ©½1™0–vŽAñ±}gh>-±\0bY˜š—âš‡ÞÌs‹Q+´v$¬7ì =¤Ïù©XªîzNu±\0bYXWW—ÒÅ¥ÅÇ\Z¶óW¿~kiiÉê«e§´ýT,åááAG{ˆ%\0|\"–‰c¹¹¹?ÎÒ¤¶øWŽ´´´øvñÖîtKY__\'–\0ð‰X&Že6›µ‡Wõ“ÃÃÃ¨3Avæ€=ïÚÛÛëŒ™™™¨ÐÑÑQg¼¼¼KcppX@±T,ÓýH\'¦—z¾TJ}žÐ76×ÔÔø ]d´\r2Ð]Ÿ\'“Éè‡ÎèëëóòÓ±|{{+//\'–\0à‰¥eïS~µSK ÁH²Ñ¥nYD^Uonn|@à\0ª¥?§Ô¸\0u+êë)¢?KëììŒX€\'–Ih¤¸éG\Z:Î5l½´´Ô¥¢ÍE/ÅÇ2Âââ\"±\0bù½XÊîî®9,ZØüü¼vuu•¢—CCCÞ(>–ö•œÄ\0ˆå÷b)ª‹Y¤²æ¦ðüü¬K–.•ukkËËŸ¥¾˜{‰%\0ü–X¤Ž¥}óÚÚZ`”¡Æ………Àžb!Êj]]‹¦ÏÉÉÉ÷÷wA×Hl,ãÿ”Ã‚¯°&–\0ð[bù\'(«««\Z ªK*Óìì¬ïìläÔW}æôôôÈÈˆøè3µŠ«b=<<x\0ÀÿÓ¯Ž%\0\0Ä\0\0b	\0@4b‰Ù¯c‡a\0ˆ¢÷¿@D\ncˆLp‘7ÖvñÙ~Š¸ñ{Ì	$ÐG\0b	\0X@ –\0ˆ%\0b	\0X@ –\0ˆ%\0b	\0X@ –\0ˆ%\0b	\0X@ –\0ˆ%\0b	\0X@ –\0ˆ%\0b	\0X@ –\0ˆ%\0b	\0X@ –\0ˆ%\0b	\0X@ –\0ˆ%\0b	\0X@ –\0ˆ%\0b	\0X@ –\0ˆ%\0b	\0X@ –\0ˆ%\0b	\0X@ –\0ˆ%\0b	\0X@ –\0ˆ%\0b	\0X@ –\0ˆ%\0b	\0ÁAc¹®ëTëµ”sßŸºÎÌÌ¾`ç¾¿–2Õº®ë¶¯Ærªõ3¯ÙÌÌöÚTë¶££År†×9Ž·û¼´G{þünffö{´ç¼´ñvÿç‡aÛË¡bùúS–K™—ö™7mffïo^Z¹”S÷Ç¾Ýµ´\r†þÿ?iŒƒ±ƒmG$›ƒ²Y\rÆïŠQ´j|à…êQ_›THÌus#úæ¤ðÜ}ú±½ýr:±lš&½ÖPJ’|÷Æ¨O3;Ÿ_N\'–i­Œõ|˜Ï+Ir»ÆÀßÚr9Xþ)Kk%INÇ´\\Æðoû3X¦_‰øFINÄøé÷$m¦Ëôæõ0ŸQ’ä[˜&Û±$I¾WÅR,I’bùŒX’$Å2ƒX’$Å2ƒX’$Å2ƒX’$Å2ƒX’$Å2ƒX’$Å2ƒX’$Å2ƒXŽÆzq3û?/ƒ¢ ÉÍ,Ë 1FÄ²b9ëÅL’ìŸÌ&bÙ±‡³Ø)‹¢ªªårÙÀ†Äè¨ªª,Š&bÙ±…i­TJ\0}z™–K±ì‚XŽÂôJ\0=H“D,» –£P,ˆ¥XR,¬C,Å’b	 ƒXŠ%Å@±KŠ%€b)–K\0ÄR,)–\02ˆ¥XR,dK±¤XÈ –bI±A,Å’b	 ƒXŠåÆ7GW÷õåÝáâ6.N®_6Gâ`‹¸Õ0ë(–\0^\"–bùÚÈ…«XîŸ5ÿê‹Yuzp~½êeü]s|UÊ8ãxÜ$Åruÿa–R,ˆ¥Xn°PÆ:¸;¯¿ÿ,w¾~û¸óåÃ§ÏqÿîîÕ‘Àõ±Œüýøõ;ŽÄÁ8žÎÆ\rã¶_1ÅÀ;gÖ“V„á_íðÂ]Ù7EdÇ\rÅ\\P«GEmA­µ­µ´uI­½hb}r¾”pQÁza(7_Èñ03çÆäÉ;3¥À²Ò)!°ðíçû—«›éhlÂõöyÝ½ 4:Omì¼=ýóJRR¾\"€\\‚I!‘tŠPŠ›”¥¸\n®M)°‰DKeõî+Î_˜L½êŠº\\Ýf‹Å`4r,VkwÛç.®mâ//K‡,EJr—Ö50I0)*×d6SŠ‚”%€àšíÇ\n,E\"‘ÀR`Y¬:küpù*`su÷tuuµ···êêèè0™LV›mdlRÛË¦F˜¥ÃŸÜä+lv»Ñh$¥­­\\ŠPÊ©ó’~,aÄ×¦¹XŠD\"¥ÀòÑSÞQþ‚)#`o---Íºššš¸†yðÒ%–i¨*s©6fùdñÇ9=¿è	“Íe\"]ñ’â<‚q–\"‘¨^%°|¾j–ê|¹»ß?ÊÅóV«\r_X\"¥Ñ`0º=Þ‰éÙã³Âùõ³¯·ÇgŸ¹Î]\\q\r,gæ— )¶X–§sk-+Åy’‘HT¯X>_ÿ,1|»\'ãS	Æ‚e–1Š°ãúæ8Ï¡éÊ“Iäª–¦y»wp²´¶9<:æp8;:;•1-‡%PŠóT°L§Óš¦mooWËf³š®ûûû¢Hô\"º½½Õt\nu‡?u\'—ËEåX\n,«Î,aœšMÚíŽNvp®D;ð‰ãœœ™ÓöÖ¶ö¦ç’¡p¿Gß•eãuh$6·˜Jg“«Áp?‘Ê\\ªtJ©ôxbGð ú›Y6üÖÃÃC…°ÆÆFv}}]‰^D™L¦AW\"‘PwnnnÔ·Û]•K`)°|Ê‚?#\0½þ\0¼dÊHëµY—š8F‡:›˜b6i³Ù&S—ÁÀ\'ë¯CÑ…•u¶aÉ*¨f,˜¤é÷ùü¼@BÏ¶.|–¢š•Àò/$°X>–ìédÞŽÅg¡°ÃéT±0×pd`v1ùÄKÒ’U»²-ºˆt¹º££ÐëWƒÁ€¡ä+JQ²çUK¥ÀRô’Êçó­ºè»\n,«H`)°¬zÔvëùÕ;8¬¼†\"¼@BïÔl¶àÇã3»XN,ŸJTÐhw8c“Ó[¯™kF†°§JŠÐ˜¥ eyo„GÔæ/,Eÿ–J`)°¬|Ê_—<È§6w0‚ðÒãõ¹=}¬í,,¯A;(è†­6–F–O%1šðrp$¦íb@IïíóÒz\r÷rý«½s‰#	âø_-!„8’jâs£®1j|¬ºê&Æh|ë™dOÍy>9<_è!xà[Dïƒ_æzœÝuo	º˜ÜžÚªž™M¦ª«;Ä,Æïìº‘»\0Ë‹‹‹½½=Ê1r/ÜØßßÏQùàààøø8êìåå%®OOO3Q?ÿ¾–³³³½cüüü<ÜŽì`0«…““4u{ó¾ŽÝ‡¬ÂcrúVˆ~þæ ¹³³ƒ”=,ÿŸxXzXæ@JÂJ–‚\ZÂ6Ö°ÃÀ›æÉ’±_ÓßVþ\"@$Ê¤®4Ëã%;Lý6?2õ5õaÒY¾Ž¾…AÌbw–—ß–ÕÐÐÐ“\'OdäÞ½{ÔX}ùòåF#kkk¥¥¥÷ïß—2YñÕÕUG-•JáŽä##ÖL¹¸¸˜ŠÜååeN!ÛÛÛ‹‹‹XÃˆ)ÐØÓÓ£«püVVVÚ%Hèöôô´3p?~üµ©©)Ê/c±˜ºJBbrrÒÔ8ËGÙáMå_jkk>|(M®hllì¶ŒäÓ+yðàœ€.ŽfYY=ûöíÂÂÂ£GìöÖÔÔ€¢ Z^ý,üÍáÂåZLMÊ<© \Z¿\r<\"ããã–YÅÃÒÃ2ÓÁÿ\rÉ@\Z«;(äs@‘˜’Ê\n_á¥ò«ÌAZd)1RRéÓšH²Œ„lmk¢«²*VU#¾¤\Zƒ˜Å8.p„;Yª±¥¥¥(B¦Ai«½½½QÊ]]]AåÆÆFkçÕFFFfffìïÖÖVµ;®s!mmmEÑÒÐÐ Í££#\rÄbpP u¸e\'ªž•G \ZŽ®r‚oa2,ð#ü€ôâ\"	Ã2~ðæ\0]žQQ´€[_à“ŸxXzXFÛÿœüñçæàè¤mtÇn®¿\\oë\nüì€Ž0’ä*ììNO»ZL	;ù\\4¦&{ß“€-.)¥‘¯c\náoŒãG¸Ã©‡%²²²b-DŸ>}â#áB]]¢¦€#È\'ÆhÆÁöööð)XJzltf¼,…F¯ááá/^¨qnnN¦Ö××ÕÚÐ	VXT\Z¯wwwƒ<\0ªd2911Aøk-zH,ÕÙÙIÇd\\N1(M¾‹;¢=@¢P,çS*DÃÑ6Çi°3¬5? uÞbÄ°å<úYÀ›300 ŸM__—––x‚DÃzÜ\\»‡eâaéay,­ï\0BPGIÃ4‹]YOI\\È. Ž‰Ì’’øg±èóO½º:–èêa‚ñÏ3ÌSZªö§€X.p„;œzX\"ÝÝÝÖb)8	c¨3Ô2¡¨ñW$SžMC\'jaX¦Ói#‡EHKÅ£AS¸Ó0\Znu®¨¼¼ÜN\r†y@ˆF$nÙP®JFøÛ\ZyëR£ÈÍÛ€EÌŠu•oŒz%x“®L$ê¤ž\Z–EVÃ?ý-aËyô³P7/Ê÷nmm9i^ee777=,óKËÈƒùH–N²>(j3àÆ°OŸ>rñ×oØ£\'ýû2ë)Y®eå%Tû\\ŸêNõMÏÌO~».j`*ÅX‹	Æq#ÜáÔÃinn¶b;§NŒ1éEÝ¿µ `šõõõR§I•W,™ht”¥âì%´±±æÖ«W¯ÙÍuuá`—üp˜Æ	8QrÒ±œl*Ñ>2™ª9Ô`ÑŠF¥©¯2Šbßð0fÅ\'\"3çåg¶œG?usøñ0ÍLçe6(ü<ÌY\nËÛ‹‡¥‡eôA\rN]ü5Ã\nx3@JøH£ePëê†&¦)jeg;ò±ÌAÖÔÆ¯K^ë‰)9µ¸¶ž_îý0@Î–å%D–ARÊ\ZŽp‡SK\'Èc„ŽQqŒàÇØ>KŽâGŸ”`,)0qNQ)j§xÑ¹Ê(P–&Ù`Ó\'DDbç+?~´SïÞ½sN©šFÛš&/7ºÎÜIáP·Å|Qý\ZsYóèganN´ðìCUÌEbÖÃòöâaéa}”WV1¿hYÓ0)Ÿ={Á!ûïL¥¿;’Dí~ßßÜ– l‚Ö¿ijëHRòJ°HpÉœ%ÉXV›0[i¼—á§?$,3oúªì™ˆHÞŒN_W˜ó,¦”¬å äEX‚Æ(XvttD]Ëi?<<dvJQ ®‘7›F%Eµ:^b³ƒâÀ(Ê&YùA2ª\'EšššXf­Ê£Ÿ…¸9ît)ßâ}…„RôÞŸ<,o-––Ž§d_¯Ii`ògÊrªb5ÌV’€žüÌz¨ÙÔÒÝH­lEU5GeuŒà’&ìWL}°­Õ-ô$O«øò?‹LØÙçùó	–š(b9c†µŒ(„ÇbøªøÌ‘ŠŠ\n›ƒTx‘U9Á’òœ(XR’–ê9Xue…%Û<p“¢¢”x ’U2,šTJùåË—Q‹p”©v`y•Mòèg¡nŽÙÑl±ÄÃ² âa™Yþ´y½á±²\0\0\0\0IEND®B`‚');
/*!40000 ALTER TABLE `ost_file_chunk` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_filter`
--

DROP TABLE IF EXISTS `ost_filter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_filter` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `execorder` int(10) unsigned NOT NULL DEFAULT 99,
  `isactive` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `flags` int(10) unsigned DEFAULT 0,
  `status` int(11) unsigned NOT NULL DEFAULT 0,
  `match_all_rules` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `stop_onmatch` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `target` enum('Any','Web','Email','API') NOT NULL DEFAULT 'Any',
  `email_id` int(10) unsigned NOT NULL DEFAULT 0,
  `name` varchar(32) NOT NULL DEFAULT '',
  `notes` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `target` (`target`),
  KEY `email_id` (`email_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_filter`
--

LOCK TABLES `ost_filter` WRITE;
/*!40000 ALTER TABLE `ost_filter` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_filter` VALUES
(1,99,1,0,0,0,0,'Email',0,'SYSTEM BAN LIST','Internal list for email banning. Do not remove','2026-02-19 18:15:04','2026-02-19 18:15:04');
/*!40000 ALTER TABLE `ost_filter` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_filter_action`
--

DROP TABLE IF EXISTS `ost_filter_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_filter_action` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `filter_id` int(10) unsigned NOT NULL,
  `sort` int(10) unsigned NOT NULL DEFAULT 0,
  `type` varchar(24) NOT NULL,
  `configuration` text DEFAULT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `filter_id` (`filter_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_filter_action`
--

LOCK TABLES `ost_filter_action` WRITE;
/*!40000 ALTER TABLE `ost_filter_action` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_filter_action` VALUES
(1,1,1,'reject','[]','2026-02-19 18:15:04');
/*!40000 ALTER TABLE `ost_filter_action` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_filter_rule`
--

DROP TABLE IF EXISTS `ost_filter_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_filter_rule` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `filter_id` int(10) unsigned NOT NULL DEFAULT 0,
  `what` varchar(32) NOT NULL,
  `how` enum('equal','not_equal','contains','dn_contain','starts','ends','match','not_match') NOT NULL,
  `val` varchar(255) NOT NULL,
  `isactive` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `notes` tinytext NOT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `filter` (`filter_id`,`what`,`how`,`val`),
  KEY `filter_id` (`filter_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_filter_rule`
--

LOCK TABLES `ost_filter_rule` WRITE;
/*!40000 ALTER TABLE `ost_filter_rule` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_filter_rule` VALUES
(1,1,'email','equal','test@example.com',1,'','0000-00-00 00:00:00','2026-02-19 18:15:04');
/*!40000 ALTER TABLE `ost_filter_rule` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_form`
--

DROP TABLE IF EXISTS `ost_form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_form` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(10) unsigned DEFAULT NULL,
  `type` varchar(8) NOT NULL DEFAULT 'G',
  `flags` int(10) unsigned NOT NULL DEFAULT 1,
  `title` varchar(255) NOT NULL,
  `instructions` varchar(512) DEFAULT NULL,
  `name` varchar(64) NOT NULL DEFAULT '',
  `notes` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_form`
--

LOCK TABLES `ost_form` WRITE;
/*!40000 ALTER TABLE `ost_form` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_form` VALUES
(1,NULL,'U',1,'Contact Information',NULL,'',NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03'),
(2,NULL,'T',1,'Ticket Details','Please Describe Your Issue','','This form will be attached to every ticket, regardless of its source.\nYou can add any fields to this form and they will be available to all\ntickets, and will be searchable with advanced search and filterable.','2026-02-19 18:15:03','2026-02-19 18:15:03'),
(3,NULL,'C',1,'Company Information','Details available in email templates','',NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03'),
(4,NULL,'O',1,'Organization Information','Details on user organization','',NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03'),
(5,NULL,'A',1,'Task Details','Please Describe The Issue','','This form is used to create a task.','2026-02-19 18:15:03','2026-02-19 18:15:03'),
(6,NULL,'L1',0,'Ticket Status Properties','Properties that can be set on a ticket status.','',NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03');
/*!40000 ALTER TABLE `ost_form` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_form_entry`
--

DROP TABLE IF EXISTS `ost_form_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_form_entry` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `form_id` int(11) unsigned NOT NULL,
  `object_id` int(11) unsigned DEFAULT NULL,
  `object_type` char(1) NOT NULL DEFAULT 'T',
  `sort` int(11) unsigned NOT NULL DEFAULT 1,
  `extra` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `entry_lookup` (`object_type`,`object_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_form_entry`
--

LOCK TABLES `ost_form_entry` WRITE;
/*!40000 ALTER TABLE `ost_form_entry` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_form_entry` VALUES
(1,4,1,'O',1,NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(2,3,NULL,'C',1,NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(3,1,1,'U',1,NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(4,2,1,'T',0,'{\"disable\":[]}','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(5,1,2,'U',1,NULL,'2026-02-19 23:31:44','2026-02-19 23:31:44'),
(6,2,2,'T',0,'{\"disable\":[]}','2026-02-19 23:32:15','2026-02-19 23:32:15'),
(7,2,3,'T',0,'{\"disable\":[]}','2026-02-19 23:41:05','2026-02-19 23:41:05'),
(8,1,3,'U',1,NULL,'2026-02-23 16:21:15','2026-02-23 16:21:15'),
(9,2,4,'T',0,'{\"disable\":[]}','2026-02-23 16:23:43','2026-02-23 16:23:43'),
(10,2,5,'T',0,'{\"disable\":[]}','2026-02-23 18:30:16','2026-02-23 18:30:16');
/*!40000 ALTER TABLE `ost_form_entry` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_form_entry_values`
--

DROP TABLE IF EXISTS `ost_form_entry_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_form_entry_values` (
  `entry_id` int(11) unsigned NOT NULL,
  `field_id` int(11) unsigned NOT NULL,
  `value` text DEFAULT NULL,
  `value_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`entry_id`,`field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_form_entry_values`
--

LOCK TABLES `ost_form_entry_values` WRITE;
/*!40000 ALTER TABLE `ost_form_entry_values` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_form_entry_values` VALUES
(2,23,'KI Helpdesk',NULL),
(2,24,NULL,NULL),
(2,25,NULL,NULL),
(2,26,NULL,NULL),
(4,20,'osTicket Installed!',NULL),
(4,22,NULL,NULL),
(5,3,NULL,NULL),
(5,4,NULL,NULL),
(6,20,'Login issue',NULL),
(6,22,'Low',1),
(7,20,'ES GEHT NICHT',NULL),
(7,22,NULL,2),
(8,3,NULL,NULL),
(8,4,NULL,NULL),
(9,20,'SSO ERROR',NULL),
(9,22,'Emergency',4),
(10,20,'Screenshot error',NULL),
(10,22,NULL,2);
/*!40000 ALTER TABLE `ost_form_entry_values` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_form_field`
--

DROP TABLE IF EXISTS `ost_form_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_form_field` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `form_id` int(11) unsigned NOT NULL,
  `flags` int(10) unsigned DEFAULT 1,
  `type` varchar(255) NOT NULL DEFAULT 'text',
  `label` varchar(255) NOT NULL,
  `name` varchar(64) NOT NULL,
  `configuration` text DEFAULT NULL,
  `sort` int(11) unsigned NOT NULL,
  `hint` varchar(512) DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `form_id` (`form_id`),
  KEY `sort` (`sort`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_form_field`
--

LOCK TABLES `ost_form_field` WRITE;
/*!40000 ALTER TABLE `ost_form_field` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_form_field` VALUES
(1,1,489395,'text','Email Address','email','{\"size\":40,\"length\":64,\"validator\":\"email\"}',1,NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03'),
(2,1,489395,'text','Full Name','name','{\"size\":40,\"length\":64}',2,NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03'),
(3,1,13057,'phone','Phone Number','phone',NULL,3,NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03'),
(4,1,12289,'memo','Internal Notes','notes','{\"rows\":4,\"cols\":40}',4,NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03'),
(20,2,489265,'text','Issue Summary','subject','{\"size\":40,\"length\":50}',1,NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03'),
(21,2,480547,'thread','Issue Details','message',NULL,2,'Details on the reason(s) for opening the ticket.','2026-02-19 18:15:03','2026-02-19 18:15:03'),
(22,2,274609,'priority','Priority Level','priority',NULL,3,NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03'),
(23,3,291249,'text','Company Name','name','{\"size\":40,\"length\":64}',1,NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03'),
(24,3,274705,'text','Website','website','{\"size\":40,\"length\":64}',2,NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03'),
(25,3,274705,'phone','Phone Number','phone','{\"ext\":false}',3,NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03'),
(26,3,12545,'memo','Address','address','{\"rows\":2,\"cols\":40,\"html\":false,\"length\":100}',4,NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03'),
(27,4,489395,'text','Name','name','{\"size\":40,\"length\":64}',1,NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03'),
(28,4,13057,'memo','Address','address','{\"rows\":2,\"cols\":40,\"length\":100,\"html\":false}',2,NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03'),
(29,4,13057,'phone','Phone','phone',NULL,3,NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03'),
(30,4,13057,'text','Website','website','{\"size\":40,\"length\":0}',4,NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03'),
(31,4,12289,'memo','Internal Notes','notes','{\"rows\":4,\"cols\":40}',5,NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03'),
(32,5,487601,'text','Title','title','{\"size\":40,\"length\":50}',1,NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03'),
(33,5,413939,'thread','Description','description',NULL,2,'Details on the reason(s) for creating the task.','2026-02-19 18:15:03','2026-02-19 18:15:03'),
(34,6,487665,'state','State','state','{\"prompt\":\"State of a ticket\"}',1,NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03'),
(35,6,471073,'memo','Description','description','{\"rows\":\"2\",\"cols\":\"40\",\"html\":\"\",\"length\":\"100\"}',3,NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03');
/*!40000 ALTER TABLE `ost_form_field` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_group`
--

DROP TABLE IF EXISTS `ost_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(11) unsigned NOT NULL,
  `flags` int(11) unsigned NOT NULL DEFAULT 1,
  `name` varchar(120) NOT NULL DEFAULT '',
  `notes` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_group`
--

LOCK TABLES `ost_group` WRITE;
/*!40000 ALTER TABLE `ost_group` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ost_group` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_help_topic`
--

DROP TABLE IF EXISTS `ost_help_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_help_topic` (
  `topic_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `topic_pid` int(10) unsigned NOT NULL DEFAULT 0,
  `ispublic` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `noautoresp` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `flags` int(10) unsigned DEFAULT 0,
  `status_id` int(10) unsigned NOT NULL DEFAULT 0,
  `priority_id` int(10) unsigned NOT NULL DEFAULT 0,
  `dept_id` int(10) unsigned NOT NULL DEFAULT 0,
  `staff_id` int(10) unsigned NOT NULL DEFAULT 0,
  `team_id` int(10) unsigned NOT NULL DEFAULT 0,
  `sla_id` int(10) unsigned NOT NULL DEFAULT 0,
  `page_id` int(10) unsigned NOT NULL DEFAULT 0,
  `sequence_id` int(10) unsigned NOT NULL DEFAULT 0,
  `sort` int(10) unsigned NOT NULL DEFAULT 0,
  `topic` varchar(128) NOT NULL DEFAULT '',
  `number_format` varchar(32) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`topic_id`),
  UNIQUE KEY `topic` (`topic`,`topic_pid`),
  KEY `topic_pid` (`topic_pid`),
  KEY `priority_id` (`priority_id`),
  KEY `dept_id` (`dept_id`),
  KEY `staff_id` (`staff_id`,`team_id`),
  KEY `sla_id` (`sla_id`),
  KEY `page_id` (`page_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_help_topic`
--

LOCK TABLES `ost_help_topic` WRITE;
/*!40000 ALTER TABLE `ost_help_topic` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_help_topic` VALUES
(1,0,1,0,2,0,2,0,0,0,0,0,0,1,'General Inquiry',NULL,'Questions about products or services','2026-02-19 18:15:03','2026-02-19 18:15:03'),
(2,0,1,0,2,0,1,0,0,0,0,0,0,0,'Feedback',NULL,'Tickets that primarily concern the sales and billing departments','2026-02-19 18:15:03','2026-02-19 18:15:03'),
(10,0,1,0,2,0,2,3,0,0,0,0,0,0,'Report a Problem',NULL,'Product, service, or equipment related issues','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(11,10,1,0,2,0,3,0,0,0,1,0,0,1,'Access Issue',NULL,'Report an inability access a physical or virtual asset','2026-02-19 18:15:04','2026-02-19 18:15:04');
/*!40000 ALTER TABLE `ost_help_topic` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_help_topic_form`
--

DROP TABLE IF EXISTS `ost_help_topic_form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_help_topic_form` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `topic_id` int(11) unsigned NOT NULL DEFAULT 0,
  `form_id` int(10) unsigned NOT NULL DEFAULT 0,
  `sort` int(10) unsigned NOT NULL DEFAULT 1,
  `extra` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `topic-form` (`topic_id`,`form_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_help_topic_form`
--

LOCK TABLES `ost_help_topic_form` WRITE;
/*!40000 ALTER TABLE `ost_help_topic_form` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_help_topic_form` VALUES
(1,1,2,1,'{\"disable\":[]}'),
(2,2,2,1,'{\"disable\":[]}'),
(3,10,2,1,'{\"disable\":[]}'),
(4,11,2,1,'{\"disable\":[]}');
/*!40000 ALTER TABLE `ost_help_topic_form` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_list`
--

DROP TABLE IF EXISTS `ost_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_list` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `name_plural` varchar(255) DEFAULT NULL,
  `sort_mode` enum('Alpha','-Alpha','SortCol') NOT NULL DEFAULT 'Alpha',
  `masks` int(11) unsigned NOT NULL DEFAULT 0,
  `type` varchar(16) DEFAULT NULL,
  `configuration` text NOT NULL DEFAULT '',
  `notes` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_list`
--

LOCK TABLES `ost_list` WRITE;
/*!40000 ALTER TABLE `ost_list` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_list` VALUES
(1,'Ticket Status','Ticket Statuses','SortCol',13,'ticket-status','{\"handler\":\"TicketStatusList\"}','Ticket statuses','2026-02-19 18:15:03','2026-02-19 18:15:03');
/*!40000 ALTER TABLE `ost_list` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_list_items`
--

DROP TABLE IF EXISTS `ost_list_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_list_items` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `list_id` int(11) DEFAULT NULL,
  `status` int(11) unsigned NOT NULL DEFAULT 1,
  `value` varchar(255) NOT NULL,
  `extra` varchar(255) DEFAULT NULL,
  `sort` int(11) NOT NULL DEFAULT 1,
  `properties` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `list_item_lookup` (`list_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_list_items`
--

LOCK TABLES `ost_list_items` WRITE;
/*!40000 ALTER TABLE `ost_list_items` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ost_list_items` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_lock`
--

DROP TABLE IF EXISTS `ost_lock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_lock` (
  `lock_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `staff_id` int(10) unsigned NOT NULL DEFAULT 0,
  `expire` datetime DEFAULT NULL,
  `code` varchar(20) DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`lock_id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_lock`
--

LOCK TABLES `ost_lock` WRITE;
/*!40000 ALTER TABLE `ost_lock` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ost_lock` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_note`
--

DROP TABLE IF EXISTS `ost_note`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_note` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(11) unsigned DEFAULT NULL,
  `staff_id` int(11) unsigned NOT NULL DEFAULT 0,
  `ext_id` varchar(10) DEFAULT NULL,
  `body` text DEFAULT NULL,
  `status` int(11) unsigned NOT NULL DEFAULT 0,
  `sort` int(11) unsigned NOT NULL DEFAULT 0,
  `created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `ext_id` (`ext_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_note`
--

LOCK TABLES `ost_note` WRITE;
/*!40000 ALTER TABLE `ost_note` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ost_note` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_organization`
--

DROP TABLE IF EXISTS `ost_organization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_organization` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL DEFAULT '',
  `manager` varchar(16) NOT NULL DEFAULT '',
  `status` int(11) unsigned NOT NULL DEFAULT 0,
  `domain` varchar(256) NOT NULL DEFAULT '',
  `extra` text DEFAULT NULL,
  `created` timestamp NULL DEFAULT NULL,
  `updated` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_organization`
--

LOCK TABLES `ost_organization` WRITE;
/*!40000 ALTER TABLE `ost_organization` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_organization` VALUES
(1,'osTicket','',8,'',NULL,'2026-02-19 17:15:04',NULL);
/*!40000 ALTER TABLE `ost_organization` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_organization__cdata`
--

DROP TABLE IF EXISTS `ost_organization__cdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_organization__cdata` (
  `org_id` int(11) unsigned NOT NULL,
  `name` mediumtext DEFAULT NULL,
  `address` mediumtext DEFAULT NULL,
  `phone` mediumtext DEFAULT NULL,
  `website` mediumtext DEFAULT NULL,
  `notes` mediumtext DEFAULT NULL,
  PRIMARY KEY (`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_organization__cdata`
--

LOCK TABLES `ost_organization__cdata` WRITE;
/*!40000 ALTER TABLE `ost_organization__cdata` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ost_organization__cdata` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_plugin`
--

DROP TABLE IF EXISTS `ost_plugin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_plugin` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `install_path` varchar(60) NOT NULL,
  `isphar` tinyint(1) NOT NULL DEFAULT 0,
  `isactive` tinyint(1) NOT NULL DEFAULT 0,
  `version` varchar(64) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `installed` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `install_path` (`install_path`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_plugin`
--

LOCK TABLES `ost_plugin` WRITE;
/*!40000 ALTER TABLE `ost_plugin` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_plugin` VALUES
(1,'AI Reply Assistant','plugins/ai-reply-assistant',0,1,'1.0.4','<p>Generates AI-powered draft replies as internal notes using OpenAI. Supports PII redaction, department/priority filtering, rate limiting, knowledge base integration, and manual AI draft generation. Developed by BS Computer (bscomputer.com) & BSC IT Solutions (bscsolutions.rs).</p>','2026-02-19 23:26:39');
/*!40000 ALTER TABLE `ost_plugin` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_plugin_instance`
--

DROP TABLE IF EXISTS `ost_plugin_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_plugin_instance` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `plugin_id` int(11) unsigned NOT NULL,
  `flags` int(10) NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL DEFAULT '',
  `notes` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `plugin_id` (`plugin_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_plugin_instance`
--

LOCK TABLES `ost_plugin_instance` WRITE;
/*!40000 ALTER TABLE `ost_plugin_instance` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_plugin_instance` VALUES
(1,1,1,'Ollama',NULL,'2026-02-19 23:38:31','2026-02-23 16:20:32');
/*!40000 ALTER TABLE `ost_plugin_instance` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_queue`
--

DROP TABLE IF EXISTS `ost_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_queue` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) unsigned NOT NULL DEFAULT 0,
  `columns_id` int(11) unsigned DEFAULT NULL,
  `sort_id` int(11) unsigned DEFAULT NULL,
  `flags` int(11) unsigned NOT NULL DEFAULT 0,
  `staff_id` int(11) unsigned NOT NULL DEFAULT 0,
  `sort` int(11) unsigned NOT NULL DEFAULT 0,
  `title` varchar(60) DEFAULT NULL,
  `config` text DEFAULT NULL,
  `filter` varchar(64) DEFAULT NULL,
  `root` varchar(32) DEFAULT NULL,
  `path` varchar(80) NOT NULL DEFAULT '/',
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `staff_id` (`staff_id`),
  KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_queue`
--

LOCK TABLES `ost_queue` WRITE;
/*!40000 ALTER TABLE `ost_queue` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_queue` VALUES
(1,0,NULL,1,3,0,1,'Open','[[\"status__state\",\"includes\",{\"open\":\"Open\"}]]',NULL,'T','/','2026-02-19 18:15:04','0000-00-00 00:00:00'),
(2,1,NULL,4,43,0,1,'Open','{\"criteria\":[[\"isanswered\",\"nset\",null]],\"conditions\":[]}',NULL,'T','/','2026-02-19 18:15:04','0000-00-00 00:00:00'),
(3,1,NULL,4,43,0,2,'Answered','{\"criteria\":[[\"isanswered\",\"set\",null]],\"conditions\":[]}',NULL,'T','/','2026-02-19 18:15:04','0000-00-00 00:00:00'),
(4,1,NULL,4,43,0,3,'Overdue','{\"criteria\":[[\"isoverdue\",\"set\",null]],\"conditions\":[]}',NULL,'T','/','2026-02-19 18:15:04','0000-00-00 00:00:00'),
(5,0,NULL,3,3,0,3,'My Tickets','{\"criteria\":[[\"assignee\",\"includes\",{\"M\":\"Me\",\"T\":\"One of my teams\"}],[\"status__state\",\"includes\",{\"open\":\"Open\"}]],\"conditions\":[]}',NULL,'T','/','2026-02-19 18:15:04','0000-00-00 00:00:00'),
(6,5,NULL,NULL,43,0,1,'Assigned to Me','{\"criteria\":[[\"assignee\",\"includes\",{\"M\":\"Me\"}]],\"conditions\":[]}',NULL,'T','/','2026-02-19 18:15:04','0000-00-00 00:00:00'),
(7,5,NULL,NULL,43,0,2,'Assigned to Teams','{\"criteria\":[[\"assignee\",\"!includes\",{\"M\":\"Me\"}]],\"conditions\":[]}',NULL,'T','/','2026-02-19 18:15:04','0000-00-00 00:00:00'),
(8,0,NULL,5,3,0,4,'Closed','{\"criteria\":[[\"status__state\",\"includes\",{\"closed\":\"Closed\"}]],\"conditions\":[]}',NULL,'T','/','2026-02-19 18:15:04','0000-00-00 00:00:00'),
(9,8,NULL,5,43,0,1,'Today','{\"criteria\":[[\"closed\",\"period\",\"td\"]],\"conditions\":[]}',NULL,'T','/','2026-02-19 18:15:04','0000-00-00 00:00:00'),
(10,8,NULL,5,43,0,2,'Yesterday','{\"criteria\":[[\"closed\",\"period\",\"yd\"]],\"conditions\":[]}',NULL,'T','/','2026-02-19 18:15:04','0000-00-00 00:00:00'),
(11,8,NULL,5,43,0,3,'This Week','{\"criteria\":[[\"closed\",\"period\",\"tw\"]],\"conditions\":[]}',NULL,'T','/','2026-02-19 18:15:04','0000-00-00 00:00:00'),
(12,8,NULL,5,43,0,4,'This Month','{\"criteria\":[[\"closed\",\"period\",\"tm\"]],\"conditions\":[]}',NULL,'T','/','2026-02-19 18:15:04','0000-00-00 00:00:00'),
(13,8,NULL,6,43,0,5,'This Quarter','{\"criteria\":[[\"closed\",\"period\",\"tq\"]],\"conditions\":[]}',NULL,'T','/','2026-02-19 18:15:04','0000-00-00 00:00:00'),
(14,8,NULL,7,43,0,6,'This Year','{\"criteria\":[[\"closed\",\"period\",\"ty\"]],\"conditions\":[]}',NULL,'T','/','2026-02-19 18:15:04','0000-00-00 00:00:00');
/*!40000 ALTER TABLE `ost_queue` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_queue_column`
--

DROP TABLE IF EXISTS `ost_queue_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_queue_column` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `flags` int(10) unsigned NOT NULL DEFAULT 0,
  `name` varchar(64) NOT NULL DEFAULT '',
  `primary` varchar(64) NOT NULL DEFAULT '',
  `secondary` varchar(64) DEFAULT NULL,
  `filter` varchar(32) DEFAULT NULL,
  `truncate` varchar(16) DEFAULT NULL,
  `annotations` text DEFAULT NULL,
  `conditions` text DEFAULT NULL,
  `extra` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_queue_column`
--

LOCK TABLES `ost_queue_column` WRITE;
/*!40000 ALTER TABLE `ost_queue_column` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_queue_column` VALUES
(1,0,'Ticket #','number',NULL,'link:ticketP','wrap','[{\"c\":\"TicketSourceDecoration\",\"p\":\"b\"}]','[{\"crit\":[\"isanswered\",\"nset\",null],\"prop\":{\"font-weight\":\"bold\"}}]',NULL),
(2,0,'Date Created','created',NULL,'date:full','wrap','[]','[]',NULL),
(3,0,'Subject','cdata__subject',NULL,'link:ticket','ellipsis','[{\"c\":\"TicketThreadCount\",\"p\":\">\"},{\"c\":\"ThreadAttachmentCount\",\"p\":\"a\"},{\"c\":\"OverdueFlagDecoration\",\"p\":\"<\"},{\"c\":\"LockDecoration\",\"p\":\"<\"}]','[{\"crit\":[\"isanswered\",\"nset\",null],\"prop\":{\"font-weight\":\"bold\"}}]',NULL),
(4,0,'User Name','user__name',NULL,NULL,'wrap','[{\"c\":\"ThreadCollaboratorCount\",\"p\":\">\"}]','[]',NULL),
(5,0,'Priority','cdata__priority',NULL,NULL,'wrap','[]','[]',NULL),
(6,0,'Status','status__id',NULL,NULL,'wrap','[]','[]',NULL),
(7,0,'Close Date','closed',NULL,'date:full','wrap','[]','[]',NULL),
(8,0,'Assignee','assignee',NULL,NULL,'wrap','[]','[]',NULL),
(9,0,'Due Date','duedate','est_duedate','date:human','wrap','[]','[]',NULL),
(10,0,'Last Updated','lastupdate',NULL,'date:full','wrap','[]','[]',NULL),
(11,0,'Department','dept_id',NULL,NULL,'wrap','[]','[]',NULL),
(12,0,'Last Message','thread__lastmessage',NULL,'date:human','wrap','[]','[]',NULL),
(13,0,'Last Response','thread__lastresponse',NULL,'date:human','wrap','[]','[]',NULL),
(14,0,'Team','team_id',NULL,NULL,'wrap','[]','[]',NULL);
/*!40000 ALTER TABLE `ost_queue_column` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_queue_columns`
--

DROP TABLE IF EXISTS `ost_queue_columns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_queue_columns` (
  `queue_id` int(11) unsigned NOT NULL,
  `column_id` int(11) unsigned NOT NULL,
  `staff_id` int(11) unsigned NOT NULL,
  `bits` int(10) unsigned NOT NULL DEFAULT 0,
  `sort` int(10) unsigned NOT NULL DEFAULT 1,
  `heading` varchar(64) DEFAULT NULL,
  `width` int(10) unsigned NOT NULL DEFAULT 100,
  PRIMARY KEY (`queue_id`,`column_id`,`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_queue_columns`
--

LOCK TABLES `ost_queue_columns` WRITE;
/*!40000 ALTER TABLE `ost_queue_columns` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_queue_columns` VALUES
(1,1,0,1,1,'Ticket',100),
(1,3,0,1,3,'Subject',300),
(1,4,0,1,4,'From',185),
(1,5,0,1,5,'Priority',85),
(1,8,0,1,6,'Assigned To',160),
(1,10,0,1,2,'Last Updated',150),
(2,1,0,1,1,'Ticket',100),
(2,3,0,1,3,'Subject',300),
(2,4,0,1,4,'From',185),
(2,5,0,1,5,'Priority',85),
(2,8,0,1,6,'Assigned To',160),
(2,10,0,1,2,'Last Updated',150),
(3,1,0,1,1,'Ticket',100),
(3,3,0,1,3,'Subject',300),
(3,4,0,1,4,'From',185),
(3,5,0,1,5,'Priority',85),
(3,8,0,1,6,'Assigned To',160),
(3,10,0,1,2,'Last Updated',150),
(4,1,0,1,1,'Ticket',100),
(4,3,0,1,3,'Subject',300),
(4,4,0,1,4,'From',185),
(4,5,0,1,5,'Priority',85),
(4,8,0,1,6,'Assigned To',160),
(4,9,0,1,9,'Due Date',150),
(5,1,0,1,1,'Ticket',100),
(5,3,0,1,3,'Subject',300),
(5,4,0,1,4,'From',185),
(5,5,0,1,5,'Priority',85),
(5,10,0,1,2,'Last Update',150),
(5,11,0,1,6,'Department',160),
(6,1,0,1,1,'Ticket',100),
(6,3,0,1,3,'Subject',300),
(6,4,0,1,4,'From',185),
(6,5,0,1,5,'Priority',85),
(6,10,0,1,2,'Last Update',150),
(6,11,0,1,6,'Department',160),
(7,1,0,1,1,'Ticket',100),
(7,3,0,1,3,'Subject',300),
(7,4,0,1,4,'From',185),
(7,5,0,1,5,'Priority',85),
(7,10,0,1,2,'Last Update',150),
(7,14,0,1,6,'Team',160),
(8,1,0,1,1,'Ticket',100),
(8,3,0,1,3,'Subject',300),
(8,4,0,1,4,'From',185),
(8,7,0,1,2,'Date Closed',150),
(8,8,0,1,6,'Closed By',160),
(9,1,0,1,1,'Ticket',100),
(9,3,0,1,3,'Subject',300),
(9,4,0,1,4,'From',185),
(9,7,0,1,2,'Date Closed',150),
(9,8,0,1,6,'Closed By',160),
(10,1,0,1,1,'Ticket',100),
(10,3,0,1,3,'Subject',300),
(10,4,0,1,4,'From',185),
(10,7,0,1,2,'Date Closed',150),
(10,8,0,1,6,'Closed By',160),
(11,1,0,1,1,'Ticket',100),
(11,3,0,1,3,'Subject',300),
(11,4,0,1,4,'From',185),
(11,7,0,1,2,'Date Closed',150),
(11,8,0,1,6,'Closed By',160),
(12,1,0,1,1,'Ticket',100),
(12,3,0,1,3,'Subject',300),
(12,4,0,1,4,'From',185),
(12,7,0,1,2,'Date Closed',150),
(12,8,0,1,6,'Closed By',160),
(13,1,0,1,1,'Ticket',100),
(13,3,0,1,3,'Subject',300),
(13,4,0,1,4,'From',185),
(13,7,0,1,2,'Date Closed',150),
(13,8,0,1,6,'Closed By',160),
(14,1,0,1,1,'Ticket',100),
(14,3,0,1,3,'Subject',300),
(14,4,0,1,4,'From',185),
(14,7,0,1,2,'Date Closed',150),
(14,8,0,1,6,'Closed By',160);
/*!40000 ALTER TABLE `ost_queue_columns` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_queue_config`
--

DROP TABLE IF EXISTS `ost_queue_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_queue_config` (
  `queue_id` int(11) unsigned NOT NULL,
  `staff_id` int(11) unsigned NOT NULL,
  `setting` text DEFAULT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`queue_id`,`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_queue_config`
--

LOCK TABLES `ost_queue_config` WRITE;
/*!40000 ALTER TABLE `ost_queue_config` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ost_queue_config` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_queue_export`
--

DROP TABLE IF EXISTS `ost_queue_export`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_queue_export` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `queue_id` int(11) unsigned NOT NULL,
  `path` varchar(64) NOT NULL DEFAULT '',
  `heading` varchar(64) DEFAULT NULL,
  `sort` int(10) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `queue_id` (`queue_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_queue_export`
--

LOCK TABLES `ost_queue_export` WRITE;
/*!40000 ALTER TABLE `ost_queue_export` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ost_queue_export` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_queue_sort`
--

DROP TABLE IF EXISTS `ost_queue_sort`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_queue_sort` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `root` varchar(32) DEFAULT NULL,
  `name` varchar(64) NOT NULL DEFAULT '',
  `columns` text DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_queue_sort`
--

LOCK TABLES `ost_queue_sort` WRITE;
/*!40000 ALTER TABLE `ost_queue_sort` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_queue_sort` VALUES
(1,NULL,'Priority + Most Recently Updated','[\"-cdata__priority\",\"-lastupdate\"]','2026-02-19 18:15:04'),
(2,NULL,'Priority + Most Recently Created','[\"-cdata__priority\",\"-created\"]','2026-02-19 18:15:04'),
(3,NULL,'Priority + Due Date','[\"-cdata__priority\",\"-est_duedate\"]','2026-02-19 18:15:04'),
(4,NULL,'Due Date','[\"-est_duedate\"]','2026-02-19 18:15:04'),
(5,NULL,'Closed Date','[\"-closed\"]','2026-02-19 18:15:04'),
(6,NULL,'Create Date','[\"-created\"]','2026-02-19 18:15:04'),
(7,NULL,'Update Date','[\"-lastupdate\"]','2026-02-19 18:15:04');
/*!40000 ALTER TABLE `ost_queue_sort` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_queue_sorts`
--

DROP TABLE IF EXISTS `ost_queue_sorts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_queue_sorts` (
  `queue_id` int(11) unsigned NOT NULL,
  `sort_id` int(11) unsigned NOT NULL,
  `bits` int(11) unsigned NOT NULL DEFAULT 0,
  `sort` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`queue_id`,`sort_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_queue_sorts`
--

LOCK TABLES `ost_queue_sorts` WRITE;
/*!40000 ALTER TABLE `ost_queue_sorts` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_queue_sorts` VALUES
(1,1,0,0),
(1,2,0,0),
(1,3,0,0),
(1,4,0,0),
(1,6,0,0),
(1,7,0,0),
(5,1,0,0),
(5,2,0,0),
(5,3,0,0),
(5,4,0,0),
(5,6,0,0),
(5,7,0,0),
(6,1,0,0),
(6,2,0,0),
(6,3,0,0),
(6,4,0,0),
(6,6,0,0),
(6,7,0,0),
(7,1,0,0),
(7,2,0,0),
(7,3,0,0),
(7,4,0,0),
(7,6,0,0),
(7,7,0,0),
(8,1,0,0),
(8,2,0,0),
(8,3,0,0),
(8,4,0,0),
(8,5,0,0),
(8,6,0,0),
(8,7,0,0),
(9,1,0,0),
(9,2,0,0),
(9,3,0,0),
(9,4,0,0),
(9,5,0,0),
(9,6,0,0),
(9,7,0,0),
(10,1,0,0),
(10,2,0,0),
(10,3,0,0),
(10,4,0,0),
(10,5,0,0),
(10,6,0,0),
(10,7,0,0),
(11,1,0,0),
(11,2,0,0),
(11,3,0,0),
(11,4,0,0),
(11,5,0,0),
(11,6,0,0),
(11,7,0,0),
(12,1,0,0),
(12,2,0,0),
(12,3,0,0),
(12,4,0,0),
(12,5,0,0),
(12,6,0,0),
(12,7,0,0),
(13,1,0,0),
(13,2,0,0),
(13,3,0,0),
(13,4,0,0),
(13,5,0,0),
(13,6,0,0),
(13,7,0,0),
(14,1,0,0),
(14,2,0,0),
(14,3,0,0),
(14,4,0,0),
(14,5,0,0),
(14,6,0,0),
(14,7,0,0);
/*!40000 ALTER TABLE `ost_queue_sorts` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_role`
--

DROP TABLE IF EXISTS `ost_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_role` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `flags` int(10) unsigned NOT NULL DEFAULT 1,
  `name` varchar(64) DEFAULT NULL,
  `permissions` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_role`
--

LOCK TABLES `ost_role` WRITE;
/*!40000 ALTER TABLE `ost_role` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_role` VALUES
(1,1,'All Access','{\"ticket.assign\":1,\"ticket.close\":1,\"ticket.create\":1,\"ticket.delete\":1,\"ticket.edit\":1,\"thread.edit\":1,\"ticket.link\":1,\"ticket.markanswered\":1,\"ticket.merge\":1,\"ticket.reply\":1,\"ticket.refer\":1,\"ticket.release\":1,\"ticket.transfer\":1,\"task.assign\":1,\"task.close\":1,\"task.create\":1,\"task.delete\":1,\"task.edit\":1,\"task.reply\":1,\"task.transfer\":1,\"canned.manage\":1}','Role with unlimited access','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(2,1,'Expanded Access','{\"ticket.assign\":1,\"ticket.close\":1,\"ticket.create\":1,\"ticket.edit\":1,\"ticket.link\":1,\"ticket.merge\":1,\"ticket.reply\":1,\"ticket.refer\":1,\"ticket.release\":1,\"ticket.transfer\":1,\"task.assign\":1,\"task.close\":1,\"task.create\":1,\"task.edit\":1,\"task.reply\":1,\"task.transfer\":1,\"canned.manage\":1}','Role with expanded access','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(3,1,'Limited Access','{\"ticket.assign\":1,\"ticket.create\":1,\"ticket.link\":1,\"ticket.merge\":1,\"ticket.refer\":1,\"ticket.release\":1,\"ticket.transfer\":1,\"task.assign\":1,\"task.reply\":1,\"task.transfer\":1}','Role with limited access','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(4,1,'View only',NULL,'Simple role with no permissions','2026-02-19 18:15:04','2026-02-19 18:15:04');
/*!40000 ALTER TABLE `ost_role` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_schedule`
--

DROP TABLE IF EXISTS `ost_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_schedule` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `flags` int(11) unsigned NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL,
  `timezone` varchar(64) DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_schedule`
--

LOCK TABLES `ost_schedule` WRITE;
/*!40000 ALTER TABLE `ost_schedule` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_schedule` VALUES
(1,1,'Monday - Friday 8am - 5pm with U.S. Holidays',NULL,'','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(2,1,'24/7',NULL,'','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(3,1,'24/5',NULL,'','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(4,0,'U.S. Holidays',NULL,'','2026-02-19 18:15:04','2026-02-19 18:15:04');
/*!40000 ALTER TABLE `ost_schedule` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_schedule_entry`
--

DROP TABLE IF EXISTS `ost_schedule_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_schedule_entry` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `schedule_id` int(11) unsigned NOT NULL DEFAULT 0,
  `flags` int(11) unsigned NOT NULL DEFAULT 0,
  `sort` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL,
  `repeats` varchar(16) NOT NULL DEFAULT 'never',
  `starts_on` date DEFAULT NULL,
  `starts_at` time DEFAULT NULL,
  `ends_on` date DEFAULT NULL,
  `ends_at` time DEFAULT NULL,
  `stops_on` datetime DEFAULT NULL,
  `day` tinyint(4) DEFAULT NULL,
  `week` tinyint(4) DEFAULT NULL,
  `month` tinyint(4) DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `schedule_id` (`schedule_id`),
  KEY `repeats` (`repeats`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_schedule_entry`
--

LOCK TABLES `ost_schedule_entry` WRITE;
/*!40000 ALTER TABLE `ost_schedule_entry` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_schedule_entry` VALUES
(1,1,0,0,'Monday','weekly','2019-01-07','08:00:00','2019-01-07','17:00:00',NULL,1,NULL,NULL,'0000-00-00 00:00:00','2026-02-19 18:15:04'),
(2,1,0,0,'Tuesday','weekly','2019-01-08','08:00:00','2019-01-08','17:00:00',NULL,2,NULL,NULL,'0000-00-00 00:00:00','2026-02-19 18:15:04'),
(3,1,0,0,'Wednesday','weekly','2019-01-09','08:00:00','2019-01-09','17:00:00',NULL,3,NULL,NULL,'0000-00-00 00:00:00','2026-02-19 18:15:04'),
(4,1,0,0,'Thursday','weekly','2019-01-10','08:00:00','2019-01-10','17:00:00',NULL,4,NULL,NULL,'0000-00-00 00:00:00','2026-02-19 18:15:04'),
(5,1,0,0,'Friday','weekly','2019-01-11','08:00:00','2019-01-11','17:00:00',NULL,5,NULL,NULL,'0000-00-00 00:00:00','2026-02-19 18:15:04'),
(6,2,0,0,'Daily','daily','2019-01-01','00:00:00','2019-01-01','23:59:59',NULL,NULL,NULL,NULL,'0000-00-00 00:00:00','2026-02-19 18:15:04'),
(7,3,0,0,'Weekdays','weekdays','2019-01-01','00:00:00','2019-01-01','23:59:59',NULL,NULL,NULL,NULL,'0000-00-00 00:00:00','2026-02-19 18:15:04'),
(8,4,0,0,'New Year\'s Day','yearly','2019-01-01','00:00:00','2019-01-01','23:59:59',NULL,1,NULL,1,'0000-00-00 00:00:00','2026-02-19 18:15:04'),
(9,4,0,0,'MLK Day','yearly','2019-01-21','00:00:00','2019-01-21','23:59:59',NULL,1,3,1,'0000-00-00 00:00:00','2026-02-19 18:15:04'),
(10,4,0,0,'Memorial Day','yearly','2019-05-27','00:00:00','2019-05-27','23:59:59',NULL,1,-1,5,'0000-00-00 00:00:00','2026-02-19 18:15:04'),
(11,4,0,0,'Independence Day (4th of July)','yearly','2019-07-04','00:00:00','2019-07-04','23:59:59',NULL,4,NULL,7,'0000-00-00 00:00:00','2026-02-19 18:15:04'),
(12,4,0,0,'Labor Day','yearly','2019-09-02','00:00:00','2019-09-02','23:59:59',NULL,1,1,9,'0000-00-00 00:00:00','2026-02-19 18:15:04'),
(13,4,0,0,'Indigenous Peoples\' Day (Whodat Columbus)','yearly','2019-10-14','00:00:00','2019-10-14','23:59:59',NULL,1,2,10,'0000-00-00 00:00:00','2026-02-19 18:15:04'),
(14,4,0,0,'Veterans Day','yearly','2019-11-11','00:00:00','2019-11-11','23:59:59',NULL,11,NULL,11,'0000-00-00 00:00:00','2026-02-19 18:15:04'),
(15,4,0,0,'Thanksgiving Day','yearly','2019-11-28','00:00:00','2019-11-28','23:59:59',NULL,4,4,11,'0000-00-00 00:00:00','2026-02-19 18:15:04'),
(16,4,0,0,'Christmas Day','yearly','2019-11-25','00:00:00','2019-11-25','23:59:59',NULL,25,NULL,12,'0000-00-00 00:00:00','2026-02-19 18:15:04');
/*!40000 ALTER TABLE `ost_schedule_entry` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_sequence`
--

DROP TABLE IF EXISTS `ost_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_sequence` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `flags` int(10) unsigned DEFAULT NULL,
  `next` bigint(20) unsigned NOT NULL DEFAULT 1,
  `increment` int(11) DEFAULT 1,
  `padding` char(1) DEFAULT '0',
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_sequence`
--

LOCK TABLES `ost_sequence` WRITE;
/*!40000 ALTER TABLE `ost_sequence` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_sequence` VALUES
(1,'General Tickets',1,1,1,'0','0000-00-00 00:00:00'),
(2,'Tasks Sequence',1,1,1,'0','0000-00-00 00:00:00');
/*!40000 ALTER TABLE `ost_sequence` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_session`
--

DROP TABLE IF EXISTS `ost_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_session` (
  `session_id` varchar(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '',
  `session_data` blob DEFAULT NULL,
  `session_expire` datetime DEFAULT NULL,
  `session_updated` datetime DEFAULT NULL,
  `user_id` varchar(16) NOT NULL DEFAULT '0' COMMENT 'osTicket staff/client ID',
  `user_ip` varchar(64) NOT NULL,
  `user_agent` varchar(255) NOT NULL,
  PRIMARY KEY (`session_id`),
  KEY `updated` (`session_updated`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_session`
--

LOCK TABLES `ost_session` WRITE;
/*!40000 ALTER TABLE `ost_session` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_session` VALUES
('02204cae941671f66b350c1eac6ef121','csrf|N;','2026-02-24 17:10:49','2026-02-23 17:10:49','0','',''),
('03e2b492ca3d084cb5e596bbceaa892f','csrf|a:2:{s:5:\"token\";s:40:\"6a64182800a3f3fa4b4253240e52055faac7c977\";s:4:\"time\";i:1771525183;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:22:\"/scp/settings.php?t=kb\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"1b9e67ff5ecfd3aa4145628360aaff2d:1771525183:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771526373;lastcroncall|i:1771525116;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}::Q:T|i:1;sort|a:1:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}','2026-02-19 19:49:43','2026-02-19 19:19:43','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('04ba8833682449209609785932d77ca8','csrf|a:2:{s:5:\"token\";s:40:\"121b1795493ab502c25fc8fac8d007fdc563687e\";s:4:\"time\";i:1771521943;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:5:\"/scp/\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"13a1cfed93182f73774c02b523d81a9a:1771521937:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771521947;::Q:T|i:1;sort|a:1:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771521937;::Q:A|s:0:\"\";:QA::sort|a:2:{i:0;s:7:\"created\";i:1;i:0;}:Q:tasks|O:8:\"QuerySet\":16:{s:5:\"model\";s:4:\"Task\";s:11:\"constraints\";a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:13:\"flags__hasbit\";i:1;}}}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:2;i:2;a:3:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:13:\"flags__hasbit\";i:1;s:8:\"staff_id\";i:1;}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:16:\"ticket__staff_id\";i:1;s:21:\"ticket__status__state\";s:4:\"open\";}}i:2;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:11:\"dept_id__in\";a:3:{i:0;i:1;i:1;i:2;i:2;i:3;}}}}}}}}s:16:\"path_constraints\";a:0:{}s:8:\"ordering\";a:1:{i:0;s:8:\"-created\";}s:7:\"related\";b:0;s:6:\"values\";a:14:{s:2:\"id\";s:2:\"id\";s:6:\"number\";s:6:\"number\";s:7:\"created\";s:7:\"created\";s:8:\"staff_id\";s:8:\"staff_id\";s:7:\"dept_id\";s:7:\"dept_id\";s:7:\"team_id\";s:7:\"team_id\";s:16:\"staff__firstname\";s:16:\"staff__firstname\";s:15:\"staff__lastname\";s:15:\"staff__lastname\";s:10:\"team__name\";s:10:\"team__name\";s:10:\"dept__name\";s:10:\"dept__name\";s:12:\"cdata__title\";s:12:\"cdata__title\";s:5:\"flags\";s:5:\"flags\";s:14:\"ticket__number\";s:14:\"ticket__number\";s:17:\"ticket__ticket_id\";s:17:\"ticket__ticket_id\";}s:5:\"defer\";a:0:{}s:10:\"aggregated\";b:0;s:11:\"annotations\";a:3:{s:12:\"collab_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"collab_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";s:21:\"thread__collaborators\";s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:16:\"attachment_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:16:\"attachment_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:36:\"thread__entries__attachments__inline\";}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:28:\"thread__entries__attachments\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:12:\"thread_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"thread_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:30:\"thread__entries__flags__hasbit\";i:4;}}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:19:\"thread__entries__id\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}}s:5:\"extra\";a:0:{}s:8:\"distinct\";a:0:{}s:4:\"lock\";b:0;s:5:\"chain\";a:0:{}s:7:\"options\";a:0:{}s:4:\"iter\";i:2;s:8:\"compiler\";s:13:\"MySqlCompiler\";}TTD|i:1771522084;','2026-02-19 18:28:04','2026-02-19 18:26:04','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('061061f8eb328213d6c35ee346c4baad','csrf|a:2:{s:5:\"token\";s:40:\"025a59858d4f50a35e66d38089b62ff722e382b6\";s:4:\"time\";i:1771540335;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:16:\"/scp/plugins.php\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"39ce883d90eca0abbc764daedbeb55c3:1771540286:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771541955;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771540304;::Q:T|i:1;sort|a:1:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}:form-data|N;TTD|i:1771540455;','2026-02-19 23:34:15','2026-02-19 23:32:15','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('07ade436b535bc75a980582ab5fe7d7f','csrf|N;','2026-02-24 17:11:51','2026-02-23 17:11:51','0','',''),
('0a48057491c41f78058e8ec4ffcc45b2','csrf|a:2:{s:5:\"token\";s:40:\"3ed118907b9f82de2275d0b27fcf323265d012b7\";s:4:\"time\";i:1771524830;}','2026-02-20 19:13:51','2026-02-19 19:13:51','0','127.0.0.1','curl/8.14.1'),
('0ae53bd4f8c6f387dbd61f988c84a4c7','csrf|a:2:{s:5:\"token\";s:40:\"2f85c3b6e7536f4669afcec036f733524791ff6d\";s:4:\"time\";i:1771865765;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:25:\"/scp/categories.php?id=98\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";N;}','2026-02-24 17:55:45','2026-02-23 17:56:05','0','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('0d29e831bab59cacc0114a981c4246f6','csrf|a:2:{s:5:\"token\";s:40:\"d6d1616888db128039422118f71f288f899d8495\";s:4:\"time\";i:1771865714;}','2026-02-24 17:55:14','2026-02-23 17:55:14','0','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('167b4f3f8d6278248b613c23dfd3db6a','csrf|N;_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:5:\"/scp/\";s:3:\"msg\";s:23:\"Authentication Required\";}}','2026-02-20 18:16:33','2026-02-19 18:16:33','0','127.0.0.1','curl/8.14.1'),
('16b7be4a630aabb5cddfa171dda115a7','csrf|N;','2026-02-24 17:14:25','2026-02-23 17:14:25','0','',''),
('16cb9cee25ed107a62fce535ff31d593','csrf|a:2:{s:5:\"token\";s:40:\"fbbca3a56017fc283dc0aeef14c0e0603b6eb488\";s:4:\"time\";i:1771862661;}','2026-02-24 17:04:21','2026-02-23 17:04:21','0','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('1af1ddcecf5520f6be43529c66e97934','csrf|a:2:{s:5:\"token\";s:40:\"02fb6d75548ba982f60dd484517e75c436bcf8a0\";s:4:\"time\";i:1771521400;}_auth|a:1:{s:5:\"staff\";N;}','2026-02-20 18:16:40','2026-02-19 18:16:40','0','127.0.0.1','curl/8.14.1'),
('1e469e352b1733ba056eaaf4504838b1','csrf|a:2:{s:5:\"token\";s:40:\"7e5a288235ae0807e896b29d451c5def08160a5b\";s:4:\"time\";i:1771608135;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:18:\"/scp/faq.php?id=78\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";N;}','2026-02-21 18:22:15','2026-02-20 18:22:15','0','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('2492cd0ada5aeed497be6eae6ccca0aa','csrf|a:2:{s:5:\"token\";s:40:\"62eb4f6cce6c84c06315ea2c22a24372452c9948\";s:4:\"time\";i:1771524729;}','2026-02-20 19:12:09','2026-02-19 19:12:09','0','127.0.0.1','curl/8.14.1'),
('25fee84f3ed2f8844322d38f84232d09','csrf|N;_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:5:\"/scp/\";s:3:\"msg\";s:23:\"Authentication Required\";}}','2026-02-20 18:15:20','2026-02-19 18:15:20','0','127.0.0.1','curl/8.14.1'),
('2670a1230f9f17a2bafa8b28dc5226f7','csrf|a:2:{s:5:\"token\";s:40:\"34b490c6493b78ff4fb429fe0f95c8afc55b62a8\";s:4:\"time\";i:1771867824;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:21:\"/scp/tickets.php?id=1\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"3cb05b094f40f5df7bbf3f84c2deba24:1771867789:837ec5754f503cfaaee0929fd48974e7\";}TIME_BOMB|i:1771869524;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771867725;::Q:A|s:0:\"\";:QA::sort|a:2:{i:0;s:7:\"created\";i:1;i:0;}:Q:tasks|O:8:\"QuerySet\":16:{s:5:\"model\";s:4:\"Task\";s:11:\"constraints\";a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:13:\"flags__hasbit\";i:1;}}}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:2;i:2;a:3:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:13:\"flags__hasbit\";i:1;s:8:\"staff_id\";i:1;}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:16:\"ticket__staff_id\";i:1;s:21:\"ticket__status__state\";s:4:\"open\";}}i:2;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:11:\"dept_id__in\";a:3:{i:0;i:1;i:1;i:2;i:2;i:3;}}}}}}}}s:16:\"path_constraints\";a:0:{}s:8:\"ordering\";a:1:{i:0;s:8:\"-created\";}s:7:\"related\";b:0;s:6:\"values\";a:14:{s:2:\"id\";s:2:\"id\";s:6:\"number\";s:6:\"number\";s:7:\"created\";s:7:\"created\";s:8:\"staff_id\";s:8:\"staff_id\";s:7:\"dept_id\";s:7:\"dept_id\";s:7:\"team_id\";s:7:\"team_id\";s:16:\"staff__firstname\";s:16:\"staff__firstname\";s:15:\"staff__lastname\";s:15:\"staff__lastname\";s:10:\"team__name\";s:10:\"team__name\";s:10:\"dept__name\";s:10:\"dept__name\";s:12:\"cdata__title\";s:12:\"cdata__title\";s:5:\"flags\";s:5:\"flags\";s:14:\"ticket__number\";s:14:\"ticket__number\";s:17:\"ticket__ticket_id\";s:17:\"ticket__ticket_id\";}s:5:\"defer\";a:0:{}s:10:\"aggregated\";b:0;s:11:\"annotations\";a:3:{s:12:\"collab_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"collab_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";s:21:\"thread__collaborators\";s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:16:\"attachment_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:16:\"attachment_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:36:\"thread__entries__attachments__inline\";}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:28:\"thread__entries__attachments\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:12:\"thread_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"thread_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:30:\"thread__entries__flags__hasbit\";i:4;}}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:19:\"thread__entries__id\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}}s:5:\"extra\";a:0:{}s:8:\"distinct\";a:0:{}s:4:\"lock\";b:0;s:5:\"chain\";a:0:{}s:7:\"options\";a:0:{}s:4:\"iter\";i:2;s:8:\"compiler\";s:13:\"MySqlCompiler\";}::Q:T|i:1;sort|a:1:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}:uploadedFiles|a:1:{i:3;s:44:\"d305860a8a3d474f8927ec785aaa7aaaf47c0ac1.png\";}:form-data|N;:msgs|O:10:\"ListObject\":1:{i:0;O:13:\"SimpleMessage\":3:{s:4:\"tags\";N;s:5:\"level\";i:30;s:3:\"msg\";s:27:\"Ticket created successfully\";}}','2026-02-24 18:30:16','2026-02-23 18:33:02','1','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('32a0aecb2ed00ab9a0da503540361390','csrf|a:2:{s:5:\"token\";s:40:\"324984e64624860a1ad564f5a7e6de801e90320e\";s:4:\"time\";i:1771531019;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:15:\"/scp/canned.php\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"85217cd28362d598fd509ec02ff2f0ef:1771530972:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771532069;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771531019;::Q:T|i:1;sort|a:1:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}','2026-02-19 21:26:12','2026-02-19 20:56:59','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('35062a593a7b836f081483e8b2f2b9f1','csrf|a:2:{s:5:\"token\";s:40:\"8664f3da7988214d3450994c763fad1e4e00e47d\";s:4:\"time\";i:1771521321;}','2026-02-20 18:15:21','2026-02-19 18:15:21','0','127.0.0.1','curl/8.14.1'),
('39cbfeac6a2cf8a8f4bfef98e3cc8767','csrf|a:2:{s:5:\"token\";s:40:\"6f62b2a8649bbd53991c572d5cca415095620d43\";s:4:\"time\";i:1771622546;}_auth|a:1:{s:5:\"staff\";N;}','2026-02-21 22:22:26','2026-02-20 22:22:26','0','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('3c08102ad18f597a44130b82259af023','csrf|a:2:{s:5:\"token\";s:40:\"fe23148dd034c93c60a8ff307bea88aac01076d6\";s:4:\"time\";i:1771615346;}_auth|a:1:{s:5:\"staff\";N;}','2026-02-21 20:22:26','2026-02-20 20:22:26','0','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('3cf780bd38c3e19b7c1230365d7079fa','csrf|a:2:{s:5:\"token\";s:40:\"8ef7c0d6d81d6a8853f46cca6a923687954512ae\";s:4:\"time\";i:1771580500;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:21:\"/scp/tickets.php?id=2\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"fd35a45d6b54c058284fb13c723befc0:1771580495:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771581639;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771580495;::Q:T|i:1;sort|a:1:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}','2026-02-20 11:11:35','2026-02-20 10:43:12','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('3e51be2cfaae685b963f5810eb9c3258','csrf|a:2:{s:5:\"token\";s:40:\"377e9fb17ab4f1bc3ac3533c963c32b176b542f8\";s:4:\"time\";i:1771833380;}_auth|a:2:{s:4:\"user\";N;s:5:\"staff\";N;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:5:\"/scp/\";s:3:\"msg\";s:23:\"Authentication Required\";}}','2026-02-24 08:55:28','2026-02-23 08:56:20','0','192.168.194.66','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('416fa766123c939f64e6917f9b1920c7','csrf|a:2:{s:5:\"token\";s:40:\"025a59858d4f50a35e66d38089b62ff722e382b6\";s:4:\"time\";i:1771542201;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:16:\"/scp/plugins.php\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"8a6dcb1960c60d627665c0bb122c021f:1771542200:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771543760;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771542201;::Q:T|i:1;sort|a:1:{i:1;a:2:{s:3:\"col\";i:4;s:3:\"dir\";i:1;}}:form-data|N;:msgs|a:0:{}:Q:users|O:8:\"QuerySet\":16:{s:5:\"model\";s:4:\"User\";s:11:\"constraints\";a:0:{}s:16:\"path_constraints\";a:0:{}s:8:\"ordering\";a:1:{i:0;s:4:\"name\";}s:7:\"related\";b:0;s:6:\"values\";a:7:{s:2:\"id\";s:2:\"id\";s:4:\"name\";s:4:\"name\";s:22:\"default_email__address\";s:22:\"default_email__address\";s:11:\"account__id\";s:11:\"account__id\";s:15:\"account__status\";s:15:\"account__status\";s:7:\"created\";s:7:\"created\";s:7:\"updated\";s:7:\"updated\";}s:5:\"defer\";a:0:{}s:10:\"aggregated\";b:0;s:11:\"annotations\";a:1:{s:12:\"ticket_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"ticket_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";s:7:\"tickets\";s:8:\"distinct\";b:0;s:10:\"constraint\";b:0;}}s:5:\"extra\";a:0:{}s:8:\"distinct\";a:0:{}s:4:\"lock\";b:0;s:5:\"chain\";a:0:{}s:7:\"options\";a:0:{}s:4:\"iter\";i:2;s:8:\"compiler\";s:13:\"MySqlCompiler\";}:U:tickets|O:8:\"QuerySet\":16:{s:5:\"model\";s:6:\"Ticket\";s:11:\"constraints\";a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:13:\"ticket_id__in\";O:8:\"QuerySet\":16:{s:5:\"model\";s:6:\"Ticket\";s:11:\"constraints\";a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:7:\"user_id\";i:2;}}}s:16:\"path_constraints\";a:0:{}s:8:\"ordering\";a:0:{}s:7:\"related\";b:0;s:6:\"values\";a:1:{i:0;s:9:\"ticket_id\";}s:5:\"defer\";a:0:{}s:10:\"aggregated\";b:0;s:11:\"annotations\";a:0:{}s:5:\"extra\";a:0:{}s:8:\"distinct\";a:0:{}s:4:\"lock\";b:0;s:5:\"chain\";a:1:{i:0;a:2:{i:0;O:8:\"QuerySet\":16:{s:5:\"model\";s:6:\"Ticket\";s:11:\"constraints\";a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:30:\"thread__collaborators__user_id\";i:2;}}}s:16:\"path_constraints\";a:0:{}s:8:\"ordering\";a:0:{}s:7:\"related\";b:0;s:6:\"values\";a:1:{i:0;s:9:\"ticket_id\";}s:5:\"defer\";a:0:{}s:10:\"aggregated\";b:0;s:11:\"annotations\";a:0:{}s:5:\"extra\";a:0:{}s:8:\"distinct\";a:0:{}s:4:\"lock\";b:0;s:5:\"chain\";a:0:{}s:7:\"options\";a:0:{}s:4:\"iter\";i:3;s:8:\"compiler\";s:13:\"MySqlCompiler\";}i:1;b:0;}}s:7:\"options\";a:0:{}s:4:\"iter\";i:3;s:8:\"compiler\";s:13:\"MySqlCompiler\";}}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:2;i:2;a:3:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:17:\"status__state__in\";a:2:{i:0;s:4:\"open\";i:1;s:6:\"closed\";}i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:2;i:2;a:3:{s:8:\"staff_id\";i:1;s:34:\"thread__referrals__agent__staff_id\";i:1;i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:25:\"child_thread__object_type\";s:1:\"C\";s:40:\"child_thread__referrals__agent__staff_id\";i:1;}}}}}}}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:2;i:2;a:2:{s:11:\"dept_id__in\";a:3:{i:0;i:1;i:1;i:2;i:2;i:3;}s:31:\"thread__referrals__dept__id__in\";a:3:{i:0;i:1;i:1;i:2;i:2;i:3;}}}i:2;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:25:\"child_thread__object_type\";s:1:\"C\";s:37:\"child_thread__referrals__dept__id__in\";a:3:{i:0;i:1;i:1;i:2;i:2;i:3;}}}}}}}}s:16:\"path_constraints\";a:1:{s:4:\"lock\";a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:16:\"lock__expire__gt\";O:11:\"SqlFunction\":3:{s:5:\"alias\";N;s:4:\"func\";s:3:\"NOW\";s:4:\"args\";a:0:{}}}}}}s:8:\"ordering\";a:1:{i:0;s:8:\"-created\";}s:7:\"related\";b:0;s:6:\"values\";a:21:{s:8:\"staff_id\";s:8:\"staff_id\";s:16:\"staff__firstname\";s:16:\"staff__firstname\";s:15:\"staff__lastname\";s:15:\"staff__lastname\";s:10:\"team__name\";s:10:\"team__name\";s:7:\"team_id\";s:7:\"team_id\";s:13:\"lock__lock_id\";s:13:\"lock__lock_id\";s:14:\"lock__staff_id\";s:14:\"lock__staff_id\";s:9:\"isoverdue\";s:9:\"isoverdue\";s:9:\"status_id\";s:9:\"status_id\";s:12:\"status__name\";s:12:\"status__name\";s:13:\"status__state\";s:13:\"status__state\";s:6:\"number\";s:6:\"number\";s:14:\"cdata__subject\";s:14:\"cdata__subject\";s:9:\"ticket_id\";s:9:\"ticket_id\";s:6:\"source\";s:6:\"source\";s:7:\"dept_id\";s:7:\"dept_id\";s:10:\"dept__name\";s:10:\"dept__name\";s:7:\"user_id\";s:7:\"user_id\";s:28:\"user__default_email__address\";s:28:\"user__default_email__address\";s:10:\"user__name\";s:10:\"user__name\";s:10:\"lastupdate\";s:10:\"lastupdate\";}s:5:\"defer\";a:0:{}s:10:\"aggregated\";b:0;s:11:\"annotations\";a:3:{s:12:\"collab_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"collab_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";s:21:\"thread__collaborators\";s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:16:\"attachment_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:16:\"attachment_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:36:\"thread__entries__attachments__inline\";}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:28:\"thread__entries__attachments\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:12:\"thread_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"thread_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:30:\"thread__entries__flags__hasbit\";i:4;}}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:19:\"thread__entries__id\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}}s:5:\"extra\";a:0:{}s:8:\"distinct\";a:1:{i:0;s:9:\"ticket_id\";}s:4:\"lock\";b:0;s:5:\"chain\";a:0:{}s:7:\"options\";a:0:{}s:4:\"iter\";i:2;s:8:\"compiler\";s:13:\"MySqlCompiler\";}:cannedFiles|a:1:{i:2;s:12:\"osTicket.txt\";}::Q:A|s:0:\"\";:QA::sort|a:2:{i:0;s:7:\"created\";i:1;i:0;}:Q:tasks|O:8:\"QuerySet\":16:{s:5:\"model\";s:4:\"Task\";s:11:\"constraints\";a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:13:\"flags__hasbit\";i:1;}}}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:2;i:2;a:3:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:13:\"flags__hasbit\";i:1;s:8:\"staff_id\";i:1;}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:16:\"ticket__staff_id\";i:1;s:21:\"ticket__status__state\";s:4:\"open\";}}i:2;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:11:\"dept_id__in\";a:3:{i:0;i:1;i:1;i:2;i:2;i:3;}}}}}}}}s:16:\"path_constraints\";a:0:{}s:8:\"ordering\";a:1:{i:0;s:8:\"-created\";}s:7:\"related\";b:0;s:6:\"values\";a:14:{s:2:\"id\";s:2:\"id\";s:6:\"number\";s:6:\"number\";s:7:\"created\";s:7:\"created\";s:8:\"staff_id\";s:8:\"staff_id\";s:7:\"dept_id\";s:7:\"dept_id\";s:7:\"team_id\";s:7:\"team_id\";s:16:\"staff__firstname\";s:16:\"staff__firstname\";s:15:\"staff__lastname\";s:15:\"staff__lastname\";s:10:\"team__name\";s:10:\"team__name\";s:10:\"dept__name\";s:10:\"dept__name\";s:12:\"cdata__title\";s:12:\"cdata__title\";s:5:\"flags\";s:5:\"flags\";s:14:\"ticket__number\";s:14:\"ticket__number\";s:17:\"ticket__ticket_id\";s:17:\"ticket__ticket_id\";}s:5:\"defer\";a:0:{}s:10:\"aggregated\";b:0;s:11:\"annotations\";a:3:{s:12:\"collab_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"collab_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";s:21:\"thread__collaborators\";s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:16:\"attachment_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:16:\"attachment_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:36:\"thread__entries__attachments__inline\";}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:28:\"thread__entries__attachments\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:12:\"thread_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"thread_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:30:\"thread__entries__flags__hasbit\";i:4;}}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:19:\"thread__entries__id\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}}s:5:\"extra\";a:0:{}s:8:\"distinct\";a:0:{}s:4:\"lock\";b:0;s:5:\"chain\";a:0:{}s:7:\"options\";a:0:{}s:4:\"iter\";i:2;s:8:\"compiler\";s:13:\"MySqlCompiler\";}:email|a:1:{i:3;N;}','2026-02-20 00:33:20','2026-02-20 00:03:21','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('422f4e6940d47c674e6848a0791b6901','csrf|N;','2026-02-24 18:57:57','2026-02-23 18:57:57','0','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('47be0a121f1e38e5f5b50eac7c2f2a6f','csrf|N;','2026-02-24 17:14:15','2026-02-23 17:14:15','0','',''),
('55fd430cac1124dae0886f78d0038596','csrf|a:2:{s:5:\"token\";s:40:\"ac1d1d6e87d58cb4ad9b390ceb79651cc7ba874d\";s:4:\"time\";i:1771862871;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:5:\"/scp/\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"6085670cbc88f4cf4efe04e00bef9ace:1771862858:837ec5754f503cfaaee0929fd48974e7\";}TIME_BOMB|i:1771862868;::Q:T|i:1;sort|a:1:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771862859;','2026-02-24 17:07:17','2026-02-23 17:10:39','1','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('56d4ac9bcd8111471ba7c9f31797c075','csrf|a:2:{s:5:\"token\";s:40:\"8cd8c1be2c56deb6b5ec244ce844f4aabc4ff002\";s:4:\"time\";i:1771521320;}','2026-02-20 18:15:20','2026-02-19 18:15:20','0','127.0.0.1','curl/8.14.1'),
('591998b8c0c9b2ab7c4b618b10897136','csrf|N;','2026-02-24 17:15:56','2026-02-23 17:15:56','0','',''),
('6997854ee5e6fca6e416b1d21832a7c0','csrf|a:2:{s:5:\"token\";s:40:\"025a59858d4f50a35e66d38089b62ff722e382b6\";s:4:\"time\";i:1771541949;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:16:\"/scp/plugins.php\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"471e513e43f14ec58e356c5b5b2888f2:1771541948:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771541955;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771541536;::Q:T|i:1;sort|a:1:{i:1;a:2:{s:3:\"col\";i:4;s:3:\"dir\";i:1;}}:form-data|N;:msgs|a:0:{}:Q:users|O:8:\"QuerySet\":16:{s:5:\"model\";s:4:\"User\";s:11:\"constraints\";a:0:{}s:16:\"path_constraints\";a:0:{}s:8:\"ordering\";a:1:{i:0;s:4:\"name\";}s:7:\"related\";b:0;s:6:\"values\";a:7:{s:2:\"id\";s:2:\"id\";s:4:\"name\";s:4:\"name\";s:22:\"default_email__address\";s:22:\"default_email__address\";s:11:\"account__id\";s:11:\"account__id\";s:15:\"account__status\";s:15:\"account__status\";s:7:\"created\";s:7:\"created\";s:7:\"updated\";s:7:\"updated\";}s:5:\"defer\";a:0:{}s:10:\"aggregated\";b:0;s:11:\"annotations\";a:1:{s:12:\"ticket_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"ticket_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";s:7:\"tickets\";s:8:\"distinct\";b:0;s:10:\"constraint\";b:0;}}s:5:\"extra\";a:0:{}s:8:\"distinct\";a:0:{}s:4:\"lock\";b:0;s:5:\"chain\";a:0:{}s:7:\"options\";a:0:{}s:4:\"iter\";i:2;s:8:\"compiler\";s:13:\"MySqlCompiler\";}:U:tickets|O:8:\"QuerySet\":16:{s:5:\"model\";s:6:\"Ticket\";s:11:\"constraints\";a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:13:\"ticket_id__in\";O:8:\"QuerySet\":16:{s:5:\"model\";s:6:\"Ticket\";s:11:\"constraints\";a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:7:\"user_id\";i:2;}}}s:16:\"path_constraints\";a:0:{}s:8:\"ordering\";a:0:{}s:7:\"related\";b:0;s:6:\"values\";a:1:{i:0;s:9:\"ticket_id\";}s:5:\"defer\";a:0:{}s:10:\"aggregated\";b:0;s:11:\"annotations\";a:0:{}s:5:\"extra\";a:0:{}s:8:\"distinct\";a:0:{}s:4:\"lock\";b:0;s:5:\"chain\";a:1:{i:0;a:2:{i:0;O:8:\"QuerySet\":16:{s:5:\"model\";s:6:\"Ticket\";s:11:\"constraints\";a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:30:\"thread__collaborators__user_id\";i:2;}}}s:16:\"path_constraints\";a:0:{}s:8:\"ordering\";a:0:{}s:7:\"related\";b:0;s:6:\"values\";a:1:{i:0;s:9:\"ticket_id\";}s:5:\"defer\";a:0:{}s:10:\"aggregated\";b:0;s:11:\"annotations\";a:0:{}s:5:\"extra\";a:0:{}s:8:\"distinct\";a:0:{}s:4:\"lock\";b:0;s:5:\"chain\";a:0:{}s:7:\"options\";a:0:{}s:4:\"iter\";i:3;s:8:\"compiler\";s:13:\"MySqlCompiler\";}i:1;b:0;}}s:7:\"options\";a:0:{}s:4:\"iter\";i:3;s:8:\"compiler\";s:13:\"MySqlCompiler\";}}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:2;i:2;a:3:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:17:\"status__state__in\";a:2:{i:0;s:4:\"open\";i:1;s:6:\"closed\";}i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:2;i:2;a:3:{s:8:\"staff_id\";i:1;s:34:\"thread__referrals__agent__staff_id\";i:1;i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:25:\"child_thread__object_type\";s:1:\"C\";s:40:\"child_thread__referrals__agent__staff_id\";i:1;}}}}}}}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:2;i:2;a:2:{s:11:\"dept_id__in\";a:3:{i:0;i:1;i:1;i:2;i:2;i:3;}s:31:\"thread__referrals__dept__id__in\";a:3:{i:0;i:1;i:1;i:2;i:2;i:3;}}}i:2;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:25:\"child_thread__object_type\";s:1:\"C\";s:37:\"child_thread__referrals__dept__id__in\";a:3:{i:0;i:1;i:1;i:2;i:2;i:3;}}}}}}}}s:16:\"path_constraints\";a:1:{s:4:\"lock\";a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:16:\"lock__expire__gt\";O:11:\"SqlFunction\":3:{s:5:\"alias\";N;s:4:\"func\";s:3:\"NOW\";s:4:\"args\";a:0:{}}}}}}s:8:\"ordering\";a:1:{i:0;s:8:\"-created\";}s:7:\"related\";b:0;s:6:\"values\";a:21:{s:8:\"staff_id\";s:8:\"staff_id\";s:16:\"staff__firstname\";s:16:\"staff__firstname\";s:15:\"staff__lastname\";s:15:\"staff__lastname\";s:10:\"team__name\";s:10:\"team__name\";s:7:\"team_id\";s:7:\"team_id\";s:13:\"lock__lock_id\";s:13:\"lock__lock_id\";s:14:\"lock__staff_id\";s:14:\"lock__staff_id\";s:9:\"isoverdue\";s:9:\"isoverdue\";s:9:\"status_id\";s:9:\"status_id\";s:12:\"status__name\";s:12:\"status__name\";s:13:\"status__state\";s:13:\"status__state\";s:6:\"number\";s:6:\"number\";s:14:\"cdata__subject\";s:14:\"cdata__subject\";s:9:\"ticket_id\";s:9:\"ticket_id\";s:6:\"source\";s:6:\"source\";s:7:\"dept_id\";s:7:\"dept_id\";s:10:\"dept__name\";s:10:\"dept__name\";s:7:\"user_id\";s:7:\"user_id\";s:28:\"user__default_email__address\";s:28:\"user__default_email__address\";s:10:\"user__name\";s:10:\"user__name\";s:10:\"lastupdate\";s:10:\"lastupdate\";}s:5:\"defer\";a:0:{}s:10:\"aggregated\";b:0;s:11:\"annotations\";a:3:{s:12:\"collab_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"collab_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";s:21:\"thread__collaborators\";s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:16:\"attachment_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:16:\"attachment_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:36:\"thread__entries__attachments__inline\";}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:28:\"thread__entries__attachments\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:12:\"thread_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"thread_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:30:\"thread__entries__flags__hasbit\";i:4;}}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:19:\"thread__entries__id\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}}s:5:\"extra\";a:0:{}s:8:\"distinct\";a:1:{i:0;s:9:\"ticket_id\";}s:4:\"lock\";b:0;s:5:\"chain\";a:0:{}s:7:\"options\";a:0:{}s:4:\"iter\";i:2;s:8:\"compiler\";s:13:\"MySqlCompiler\";}:cannedFiles|a:1:{i:2;s:12:\"osTicket.txt\";}::Q:A|s:0:\"\";:QA::sort|a:2:{i:0;s:7:\"created\";i:1;i:0;}:Q:tasks|O:8:\"QuerySet\":16:{s:5:\"model\";s:4:\"Task\";s:11:\"constraints\";a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:13:\"flags__hasbit\";i:1;}}}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:2;i:2;a:3:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:13:\"flags__hasbit\";i:1;s:8:\"staff_id\";i:1;}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:16:\"ticket__staff_id\";i:1;s:21:\"ticket__status__state\";s:4:\"open\";}}i:2;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:11:\"dept_id__in\";a:3:{i:0;i:1;i:1;i:2;i:2;i:3;}}}}}}}}s:16:\"path_constraints\";a:0:{}s:8:\"ordering\";a:1:{i:0;s:8:\"-created\";}s:7:\"related\";b:0;s:6:\"values\";a:14:{s:2:\"id\";s:2:\"id\";s:6:\"number\";s:6:\"number\";s:7:\"created\";s:7:\"created\";s:8:\"staff_id\";s:8:\"staff_id\";s:7:\"dept_id\";s:7:\"dept_id\";s:7:\"team_id\";s:7:\"team_id\";s:16:\"staff__firstname\";s:16:\"staff__firstname\";s:15:\"staff__lastname\";s:15:\"staff__lastname\";s:10:\"team__name\";s:10:\"team__name\";s:10:\"dept__name\";s:10:\"dept__name\";s:12:\"cdata__title\";s:12:\"cdata__title\";s:5:\"flags\";s:5:\"flags\";s:14:\"ticket__number\";s:14:\"ticket__number\";s:17:\"ticket__ticket_id\";s:17:\"ticket__ticket_id\";}s:5:\"defer\";a:0:{}s:10:\"aggregated\";b:0;s:11:\"annotations\";a:3:{s:12:\"collab_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"collab_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";s:21:\"thread__collaborators\";s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:16:\"attachment_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:16:\"attachment_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:36:\"thread__entries__attachments__inline\";}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:28:\"thread__entries__attachments\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:12:\"thread_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"thread_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:30:\"thread__entries__flags__hasbit\";i:4;}}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:19:\"thread__entries__id\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}}s:5:\"extra\";a:0:{}s:8:\"distinct\";a:0:{}s:4:\"lock\";b:0;s:5:\"chain\";a:0:{}s:7:\"options\";a:0:{}s:4:\"iter\";i:2;s:8:\"compiler\";s:13:\"MySqlCompiler\";}:email|a:1:{i:3;N;}TTD|i:1771542080;','2026-02-20 00:01:20','2026-02-19 23:59:20','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('6db0c4d17d03033304519dddcac72c84','csrf|a:2:{s:5:\"token\";s:40:\"badccc12c22385d51e540d450e3f0939709b72ab\";s:4:\"time\";i:1771524155;}','2026-02-20 19:02:35','2026-02-19 19:02:35','0','127.0.0.1','curl/8.14.1'),
('6f0d81c4545b1af22c1477e4d7c8908e','csrf|a:2:{s:5:\"token\";s:40:\"611aeec3c303bf94757c46873be8b72e911e3216\";s:4:\"time\";i:1771837384;}_staff|a:1:{s:4:\"auth\";a:1:{s:3:\"msg\";s:25:\"Valid CSRF Token Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:2;s:3:\"key\";s:12:\"local:admin2\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"7526e739d734eee7d675b6d23940dd71:1771837377:92e59810084a6bba80b205f4a6abe473\";}TIME_BOMB|i:1771838444;::Q:T|i:1;sort|a:1:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771836810;','2026-02-23 10:32:57','2026-02-23 10:03:04','2','192.168.194.66','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('730fe2ccc13f9ea5f01fc0800e84a37b','csrf|a:2:{s:5:\"token\";s:40:\"6299f2209b7918a484f0c7590e13dd5897491755\";s:4:\"time\";i:1771521393;}','2026-02-20 18:16:33','2026-02-19 18:16:33','0','127.0.0.1','curl/8.14.1'),
('745b89a8caa27ab0f265fb4a2f93bd33','csrf|a:2:{s:5:\"token\";s:40:\"611aeec3c303bf94757c46873be8b72e911e3216\";s:4:\"time\";i:1771836636;}_staff|a:1:{s:4:\"auth\";a:1:{s:3:\"msg\";s:25:\"Valid CSRF Token Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:2;s:3:\"key\";s:12:\"local:admin2\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"b180330e905da5975d3c1ce86fd99a62:1771836612:92e59810084a6bba80b205f4a6abe473\";}TIME_BOMB|i:1771836622;TTD|i:1771836764;','2026-02-23 09:52:44','2026-02-23 09:50:44','2','192.168.194.66','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('7c5b05270cb4b6d83b5e8e6a854024bc','csrf|a:2:{s:5:\"token\";s:40:\"025a59858d4f50a35e66d38089b62ff722e382b6\";s:4:\"time\";i:1771540865;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:16:\"/scp/plugins.php\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"188cb3ee917ae3dca9fd12ac594e4bd3:1771540822:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771541955;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771540750;::Q:T|i:1;sort|a:1:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}:form-data|N;:msgs|a:0:{}:Q:users|O:8:\"QuerySet\":16:{s:5:\"model\";s:4:\"User\";s:11:\"constraints\";a:0:{}s:16:\"path_constraints\";a:0:{}s:8:\"ordering\";a:1:{i:0;s:4:\"name\";}s:7:\"related\";b:0;s:6:\"values\";a:7:{s:2:\"id\";s:2:\"id\";s:4:\"name\";s:4:\"name\";s:22:\"default_email__address\";s:22:\"default_email__address\";s:11:\"account__id\";s:11:\"account__id\";s:15:\"account__status\";s:15:\"account__status\";s:7:\"created\";s:7:\"created\";s:7:\"updated\";s:7:\"updated\";}s:5:\"defer\";a:0:{}s:10:\"aggregated\";b:0;s:11:\"annotations\";a:1:{s:12:\"ticket_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"ticket_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";s:7:\"tickets\";s:8:\"distinct\";b:0;s:10:\"constraint\";b:0;}}s:5:\"extra\";a:0:{}s:8:\"distinct\";a:0:{}s:4:\"lock\";b:0;s:5:\"chain\";a:0:{}s:7:\"options\";a:0:{}s:4:\"iter\";i:2;s:8:\"compiler\";s:13:\"MySqlCompiler\";}:U:tickets|O:8:\"QuerySet\":16:{s:5:\"model\";s:6:\"Ticket\";s:11:\"constraints\";a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:13:\"ticket_id__in\";O:8:\"QuerySet\":16:{s:5:\"model\";s:6:\"Ticket\";s:11:\"constraints\";a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:7:\"user_id\";i:2;}}}s:16:\"path_constraints\";a:0:{}s:8:\"ordering\";a:0:{}s:7:\"related\";b:0;s:6:\"values\";a:1:{i:0;s:9:\"ticket_id\";}s:5:\"defer\";a:0:{}s:10:\"aggregated\";b:0;s:11:\"annotations\";a:0:{}s:5:\"extra\";a:0:{}s:8:\"distinct\";a:0:{}s:4:\"lock\";b:0;s:5:\"chain\";a:1:{i:0;a:2:{i:0;O:8:\"QuerySet\":16:{s:5:\"model\";s:6:\"Ticket\";s:11:\"constraints\";a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:30:\"thread__collaborators__user_id\";i:2;}}}s:16:\"path_constraints\";a:0:{}s:8:\"ordering\";a:0:{}s:7:\"related\";b:0;s:6:\"values\";a:1:{i:0;s:9:\"ticket_id\";}s:5:\"defer\";a:0:{}s:10:\"aggregated\";b:0;s:11:\"annotations\";a:0:{}s:5:\"extra\";a:0:{}s:8:\"distinct\";a:0:{}s:4:\"lock\";b:0;s:5:\"chain\";a:0:{}s:7:\"options\";a:0:{}s:4:\"iter\";i:3;s:8:\"compiler\";s:13:\"MySqlCompiler\";}i:1;b:0;}}s:7:\"options\";a:0:{}s:4:\"iter\";i:3;s:8:\"compiler\";s:13:\"MySqlCompiler\";}}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:2;i:2;a:3:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:17:\"status__state__in\";a:2:{i:0;s:4:\"open\";i:1;s:6:\"closed\";}i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:2;i:2;a:3:{s:8:\"staff_id\";i:1;s:34:\"thread__referrals__agent__staff_id\";i:1;i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:25:\"child_thread__object_type\";s:1:\"C\";s:40:\"child_thread__referrals__agent__staff_id\";i:1;}}}}}}}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:2;i:2;a:2:{s:11:\"dept_id__in\";a:3:{i:0;i:1;i:1;i:2;i:2;i:3;}s:31:\"thread__referrals__dept__id__in\";a:3:{i:0;i:1;i:1;i:2;i:2;i:3;}}}i:2;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:25:\"child_thread__object_type\";s:1:\"C\";s:37:\"child_thread__referrals__dept__id__in\";a:3:{i:0;i:1;i:1;i:2;i:2;i:3;}}}}}}}}s:16:\"path_constraints\";a:1:{s:4:\"lock\";a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:16:\"lock__expire__gt\";O:11:\"SqlFunction\":3:{s:5:\"alias\";N;s:4:\"func\";s:3:\"NOW\";s:4:\"args\";a:0:{}}}}}}s:8:\"ordering\";a:1:{i:0;s:8:\"-created\";}s:7:\"related\";b:0;s:6:\"values\";a:21:{s:8:\"staff_id\";s:8:\"staff_id\";s:16:\"staff__firstname\";s:16:\"staff__firstname\";s:15:\"staff__lastname\";s:15:\"staff__lastname\";s:10:\"team__name\";s:10:\"team__name\";s:7:\"team_id\";s:7:\"team_id\";s:13:\"lock__lock_id\";s:13:\"lock__lock_id\";s:14:\"lock__staff_id\";s:14:\"lock__staff_id\";s:9:\"isoverdue\";s:9:\"isoverdue\";s:9:\"status_id\";s:9:\"status_id\";s:12:\"status__name\";s:12:\"status__name\";s:13:\"status__state\";s:13:\"status__state\";s:6:\"number\";s:6:\"number\";s:14:\"cdata__subject\";s:14:\"cdata__subject\";s:9:\"ticket_id\";s:9:\"ticket_id\";s:6:\"source\";s:6:\"source\";s:7:\"dept_id\";s:7:\"dept_id\";s:10:\"dept__name\";s:10:\"dept__name\";s:7:\"user_id\";s:7:\"user_id\";s:28:\"user__default_email__address\";s:28:\"user__default_email__address\";s:10:\"user__name\";s:10:\"user__name\";s:10:\"lastupdate\";s:10:\"lastupdate\";}s:5:\"defer\";a:0:{}s:10:\"aggregated\";b:0;s:11:\"annotations\";a:3:{s:12:\"collab_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"collab_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";s:21:\"thread__collaborators\";s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:16:\"attachment_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:16:\"attachment_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:36:\"thread__entries__attachments__inline\";}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:28:\"thread__entries__attachments\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:12:\"thread_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"thread_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:30:\"thread__entries__flags__hasbit\";i:4;}}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:19:\"thread__entries__id\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}}s:5:\"extra\";a:0:{}s:8:\"distinct\";a:1:{i:0;s:9:\"ticket_id\";}s:4:\"lock\";b:0;s:5:\"chain\";a:0:{}s:7:\"options\";a:0:{}s:4:\"iter\";i:2;s:8:\"compiler\";s:13:\"MySqlCompiler\";}:cannedFiles|a:1:{i:2;s:12:\"osTicket.txt\";}TTD|i:1771540985;','2026-02-19 23:43:05','2026-02-19 23:41:05','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('7c7556da9e30cec52af249793493970e','csrf|a:2:{s:5:\"token\";s:40:\"6d72b02a5218fd2a1c71f2d84dbcd16b3647bec4\";s:4:\"time\";i:1771581489;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:21:\"/scp/tickets.php?id=1\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"93a54e4464e22487db04e7d02d2bf21d:1771581479:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771583277;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771581373;','2026-02-20 11:27:59','2026-02-20 10:58:09','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('7dfe7a97a02b6acc00dbef47c134ddcf','csrf|a:2:{s:5:\"token\";s:40:\"6271d8f663a726a704826933722fb853a5b2c4f1\";s:4:\"time\";i:1771860504;}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"551516e517fcca229b061915c5d1a6d7:1771860495:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771861800;::Q:T|i:5;sort|a:2:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}i:5;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:3;s:4:\"root\";N;s:4:\"name\";s:19:\"Priority + Due Date\";s:7:\"columns\";s:35:\"[\"-cdata__priority\",\"-est_duedate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:11:\"est_duedate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771860213;:form-data|N;:msgs|a:0:{}','2026-02-23 16:58:15','2026-02-23 16:28:24','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('7e7ac9f01ad408a7bf7f69f01d92fb29','csrf|a:2:{s:5:\"token\";s:40:\"0ff39f020437806c3554b5936aa762e094660eb1\";s:4:\"time\";i:1771524846;}','2026-02-20 19:14:06','2026-02-19 19:14:06','0','127.0.0.1','curl/8.14.1'),
('81f58589e6aede29b0c666010bf39040','csrf|a:2:{s:5:\"token\";s:40:\"96769882da6e5c9cdfce0f2296d07341dd6dd85f\";s:4:\"time\";i:1771869512;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:21:\"/scp/tickets.php?id=5\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"79fba49c22a736b791f2eb6f61261e91:1771869496:837ec5754f503cfaaee0929fd48974e7\";}TIME_BOMB|i:1771871308;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771869496;::Q:T|i:1;sort|a:1:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}','2026-02-23 19:28:28','2026-02-23 19:01:20','1','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('870335b5a9c3d79c4c68de2fd7898934','csrf|a:2:{s:5:\"token\";s:40:\"457fdb981a5eb86b88c3359ffc06deeb31dc7fd6\";s:4:\"time\";i:1771629746;}_auth|a:1:{s:5:\"staff\";N;}','2026-02-22 00:22:26','2026-02-21 00:22:26','0','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('872662b1af0d750383bf50afd2643e1a','csrf|N;','2026-02-24 17:11:19','2026-02-23 17:11:19','0','',''),
('882f5e573cebb79aa0ca45e9eb7f8716','csrf|a:2:{s:5:\"token\";s:40:\"96769882da6e5c9cdfce0f2296d07341dd6dd85f\";s:4:\"time\";i:1771869502;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:21:\"/scp/tickets.php?id=5\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"79fba49c22a736b791f2eb6f61261e91:1771869496:837ec5754f503cfaaee0929fd48974e7\";}TIME_BOMB|i:1771869506;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771869496;::Q:T|i:1;sort|a:1:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}TTD|i:1771869628;','2026-02-23 19:00:28','2026-02-23 18:58:28','1','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('8bcdad213cafbcd987ec96e9375a089f','csrf|N;','2026-02-24 17:11:24','2026-02-23 17:11:24','0','',''),
('8c218001b6bbedccb091227846f055f6','csrf|a:2:{s:5:\"token\";s:40:\"0f3656b803e399f97f18cf6129097c0e1300cbaa\";s:4:\"time\";i:1771862814;}_auth|a:2:{s:4:\"user\";a:1:{s:7:\"strikes\";i:1;}s:5:\"staff\";N;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:5:\"/scp/\";s:3:\"msg\";s:23:\"Authentication Required\";}}','2026-02-24 17:04:12','2026-02-23 17:06:54','0','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('8e43e30a482f92dbfd15379b02e6b26e','csrf|N;','2026-02-24 17:17:53','2026-02-23 17:17:53','0','',''),
('97621c13db37947f9e7e19339df8a77f','csrf|a:2:{s:5:\"token\";s:40:\"729c52853df3e6853eec26871b0480d670539801\";s:4:\"time\";i:1771585993;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:27:\"/scp/plugins.php?id=1&xid=1\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"0cea2d3de7c2c35031f77a9efc395010:1771585986:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771585996;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771585986;TTD|i:1771586117;','2026-02-20 12:15:17','2026-02-20 12:13:17','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('989c2516d6c4ecf3fe8610d898dc93d7','csrf|a:2:{s:5:\"token\";s:40:\"8ef7c0d6d81d6a8853f46cca6a923687954512ae\";s:4:\"time\";i:1771579838;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:21:\"/scp/tickets.php?id=2\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"fe40c1f771cdeb72b4e1ce79841445c1:1771579828:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771579838;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771579829;TTD|i:1771579959;','2026-02-20 10:32:39','2026-02-20 10:30:39','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('99c3f76f0020137117fbd6a9e50abca1','csrf|a:2:{s:5:\"token\";s:40:\"d14a6344ebd4ad36b6b0675b7fd490d6bb297335\";s:4:\"time\";i:1771613479;}','2026-02-21 19:51:19','2026-02-20 19:51:19','0','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/601.2.4 (KHTML, like Gecko) Version/9.0.1 Safari/601.2.4 facebookexternalhit/1.1 Facebot Twitterbot/1.0'),
('9ca77cc501a76969af6b8577e10bf27e','csrf|N;','2026-02-24 18:02:25','2026-02-23 18:02:25','0','',''),
('a05054c17c5d4a7d2bb15d0d033b612d','csrf|N;','2026-02-24 18:01:55','2026-02-23 18:01:55','0','',''),
('a79f5f7d1838ced2061371f5f0da7201','csrf|N;','2026-02-21 10:44:18','2026-02-20 10:44:18','0','127.0.0.1','curl/8.14.1'),
('ab75c17e266ece70592151bba4738f06','csrf|N;','2026-02-24 17:16:33','2026-02-23 17:16:33','0','',''),
('b50a579a72821f7154fb09d4d30d9062','csrf|a:2:{s:5:\"token\";s:40:\"121b1795493ab502c25fc8fac8d007fdc563687e\";s:4:\"time\";i:1771522969;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:5:\"/scp/\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"1ce6a0cf38b645784434398075bb1f9f:1771522960:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771523764;::Q:T|i:1;sort|a:1:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771522966;::Q:A|s:0:\"\";:QA::sort|a:2:{i:0;s:7:\"created\";i:1;i:0;}:Q:tasks|O:8:\"QuerySet\":16:{s:5:\"model\";s:4:\"Task\";s:11:\"constraints\";a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:13:\"flags__hasbit\";i:1;}}}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:2;i:2;a:3:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:13:\"flags__hasbit\";i:1;s:8:\"staff_id\";i:1;}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:16:\"ticket__staff_id\";i:1;s:21:\"ticket__status__state\";s:4:\"open\";}}i:2;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:11:\"dept_id__in\";a:3:{i:0;i:1;i:1;i:2;i:2;i:3;}}}}}}}}s:16:\"path_constraints\";a:0:{}s:8:\"ordering\";a:1:{i:0;s:8:\"-created\";}s:7:\"related\";b:0;s:6:\"values\";a:14:{s:2:\"id\";s:2:\"id\";s:6:\"number\";s:6:\"number\";s:7:\"created\";s:7:\"created\";s:8:\"staff_id\";s:8:\"staff_id\";s:7:\"dept_id\";s:7:\"dept_id\";s:7:\"team_id\";s:7:\"team_id\";s:16:\"staff__firstname\";s:16:\"staff__firstname\";s:15:\"staff__lastname\";s:15:\"staff__lastname\";s:10:\"team__name\";s:10:\"team__name\";s:10:\"dept__name\";s:10:\"dept__name\";s:12:\"cdata__title\";s:12:\"cdata__title\";s:5:\"flags\";s:5:\"flags\";s:14:\"ticket__number\";s:14:\"ticket__number\";s:17:\"ticket__ticket_id\";s:17:\"ticket__ticket_id\";}s:5:\"defer\";a:0:{}s:10:\"aggregated\";b:0;s:11:\"annotations\";a:3:{s:12:\"collab_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"collab_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";s:21:\"thread__collaborators\";s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:16:\"attachment_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:16:\"attachment_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:36:\"thread__entries__attachments__inline\";}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:28:\"thread__entries__attachments\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:12:\"thread_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"thread_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:30:\"thread__entries__flags__hasbit\";i:4;}}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:19:\"thread__entries__id\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}}s:5:\"extra\";a:0:{}s:8:\"distinct\";a:0:{}s:4:\"lock\";b:0;s:5:\"chain\";a:0:{}s:7:\"options\";a:0:{}s:4:\"iter\";i:2;s:8:\"compiler\";s:13:\"MySqlCompiler\";}','2026-02-19 19:12:40','2026-02-19 18:42:49','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('b6bdc7b5fadb204c6852992ac3530e7d','csrf|a:2:{s:5:\"token\";s:40:\"6a64182800a3f3fa4b4253240e52055faac7c977\";s:4:\"time\";i:1771524569;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:22:\"/scp/settings.php?t=kb\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"619fa2aa8c5107b012647950feb3ca64:1771524559:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771524569;lastcroncall|i:1771524559;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}TTD|i:1771524693;','2026-02-19 19:11:33','2026-02-19 19:09:33','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('b85d39f29420ee22fa7621bd69651ff0','csrf|a:2:{s:5:\"token\";s:40:\"6271d8f663a726a704826933722fb853a5b2c4f1\";s:4:\"time\";i:1771859999;}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"e9db3a9b1a7c83ee2009470940b536bf:1771859989:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771859999;::Q:T|i:1;sort|a:1:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771859990;TTD|i:1771860120;','2026-02-23 16:22:00','2026-02-23 16:20:00','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('bb688796dbcce737e028f1c4976930f9','csrf|a:2:{s:5:\"token\";s:40:\"d50fbfa92485570e198d7497119b62fa96d35e2a\";s:4:\"time\";i:1771868018;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:21:\"/scp/tickets.php?id=4\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"7a1329142db6e0778874116491a71e2f:1771868008:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771868018;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771868008;::Q:T|i:1;sort|a:1:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}TTD|i:1771868146;','2026-02-23 18:35:46','2026-02-23 18:33:46','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('bcc726b3cc1e58bb4c432982b42590cc','csrf|a:2:{s:5:\"token\";s:40:\"d50fbfa92485570e198d7497119b62fa96d35e2a\";s:4:\"time\";i:1771868937;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:21:\"/scp/tickets.php?id=4\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"544ac20de74a25e123d4a8a2b0afa04c:1771868936:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771869826;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771868937;::Q:T|i:1;sort|a:1:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}','2026-02-23 19:18:56','2026-02-23 18:48:57','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('cfc86e2e327fc06f169e8372d5f5c39a','csrf|a:2:{s:5:\"token\";s:40:\"324984e64624860a1ad564f5a7e6de801e90320e\";s:4:\"time\";i:1771530267;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:15:\"/scp/canned.php\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"23d58e8b4a6fda0ec8bcc7b913fa9f29:1771530257:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771530267;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771530257;TTD|i:1771530389;','2026-02-19 20:46:29','2026-02-19 20:44:29','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('d050e655dbe656cf167ba152be5388fd','csrf|a:2:{s:5:\"token\";s:40:\"729c52853df3e6853eec26871b0480d670539801\";s:4:\"time\";i:1771586590;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:27:\"/scp/plugins.php?id=1&xid=1\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"09b84d4541a76843ffcc4467ae3d62e2:1771586567:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771587797;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771586448;::Q:T|i:1;sort|a:1:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}::Q:A|s:0:\"\";:QA::sort|a:2:{i:0;s:7:\"created\";i:1;i:0;}:Q:tasks|O:8:\"QuerySet\":16:{s:5:\"model\";s:4:\"Task\";s:11:\"constraints\";a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:13:\"flags__hasbit\";i:1;}}}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:2;i:2;a:3:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:13:\"flags__hasbit\";i:1;s:8:\"staff_id\";i:1;}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:16:\"ticket__staff_id\";i:1;s:21:\"ticket__status__state\";s:4:\"open\";}}i:2;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:11:\"dept_id__in\";a:3:{i:0;i:1;i:1;i:2;i:2;i:3;}}}}}}}}s:16:\"path_constraints\";a:0:{}s:8:\"ordering\";a:1:{i:0;s:8:\"-created\";}s:7:\"related\";b:0;s:6:\"values\";a:14:{s:2:\"id\";s:2:\"id\";s:6:\"number\";s:6:\"number\";s:7:\"created\";s:7:\"created\";s:8:\"staff_id\";s:8:\"staff_id\";s:7:\"dept_id\";s:7:\"dept_id\";s:7:\"team_id\";s:7:\"team_id\";s:16:\"staff__firstname\";s:16:\"staff__firstname\";s:15:\"staff__lastname\";s:15:\"staff__lastname\";s:10:\"team__name\";s:10:\"team__name\";s:10:\"dept__name\";s:10:\"dept__name\";s:12:\"cdata__title\";s:12:\"cdata__title\";s:5:\"flags\";s:5:\"flags\";s:14:\"ticket__number\";s:14:\"ticket__number\";s:17:\"ticket__ticket_id\";s:17:\"ticket__ticket_id\";}s:5:\"defer\";a:0:{}s:10:\"aggregated\";b:0;s:11:\"annotations\";a:3:{s:12:\"collab_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"collab_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";s:21:\"thread__collaborators\";s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:16:\"attachment_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:16:\"attachment_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:36:\"thread__entries__attachments__inline\";}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:28:\"thread__entries__attachments\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:12:\"thread_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"thread_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:30:\"thread__entries__flags__hasbit\";i:4;}}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:19:\"thread__entries__id\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}}s:5:\"extra\";a:0:{}s:8:\"distinct\";a:0:{}s:4:\"lock\";b:0;s:5:\"chain\";a:0:{}s:7:\"options\";a:0:{}s:4:\"iter\";i:2;s:8:\"compiler\";s:13:\"MySqlCompiler\";}','2026-02-20 12:52:47','2026-02-20 12:23:10','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('d5aeb9752698194eef3e31afcaf23adf','csrf|a:2:{s:5:\"token\";s:40:\"2a4a4a67c72d020cdc5102939d427ca30037d313\";s:4:\"time\";i:1771859907;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:5:\"/scp/\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"6b21009caddaad41a6f1b609fd6988c5:1771859907:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771859917;::Q:T|i:1;sort|a:1:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771859907;TTD|i:1771860094;','2026-02-23 16:21:34','2026-02-23 16:19:34','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('da4a19c1de1c596bcbbd882477dc6f3a','csrf|a:2:{s:5:\"token\";s:40:\"6d72b02a5218fd2a1c71f2d84dbcd16b3647bec4\";s:4:\"time\";i:1771581375;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:21:\"/scp/tickets.php?id=1\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"18a796430fd64ebd36998be446a12be0:1771581373:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771581383;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771581373;TTD|i:1771581597;','2026-02-20 10:59:57','2026-02-20 10:57:57','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('dc8ebe366c1766a0cbfc41d37b197273','csrf|a:2:{s:5:\"token\";s:40:\"34b490c6493b78ff4fb429fe0f95c8afc55b62a8\";s:4:\"time\";i:1771865735;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:21:\"/scp/tickets.php?id=1\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"5da42a67ad13a9eee8aac28fbbf857ef:1771865734:837ec5754f503cfaaee0929fd48974e7\";}TIME_BOMB|i:1771865745;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771865735;TTD|i:1771865875;','2026-02-23 17:57:55','2026-02-23 17:55:55','1','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('df554181ad68d83addf2d5d5de2687ba','csrf|a:2:{s:5:\"token\";s:40:\"6271d8f663a726a704826933722fb853a5b2c4f1\";s:4:\"time\";i:1771860223;}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"69000f84dd749554342eb97dadf1e589:1771860223:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771861800;::Q:T|i:5;sort|a:2:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}i:5;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:3;s:4:\"root\";N;s:4:\"name\";s:19:\"Priority + Due Date\";s:7:\"columns\";s:35:\"[\"-cdata__priority\",\"-est_duedate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:11:\"est_duedate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771860213;:form-data|N;TTD|i:1771860343;','2026-02-23 16:25:43','2026-02-23 16:23:43','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('e68671b771406f69cc3deed0dfedaaac','csrf|N;','2026-02-24 17:11:38','2026-02-23 17:11:38','0','',''),
('ea4392f61ef66a7d14e19c8728a4d016','csrf|a:2:{s:5:\"token\";s:40:\"095ffda340cd37a6f18de4c990b5e40463171999\";s:4:\"time\";i:1771678902;}_auth|a:1:{s:5:\"staff\";N;}','2026-02-22 14:01:42','2026-02-21 14:01:42','0','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('eb1cd50977c9c60c6760446a8257fe08','csrf|a:2:{s:5:\"token\";s:40:\"34b490c6493b78ff4fb429fe0f95c8afc55b62a8\";s:4:\"time\";i:1771866247;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:21:\"/scp/tickets.php?id=1\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"87fb835d2b7c9c836f74ee7fbcf194ea:1771866208:837ec5754f503cfaaee0929fd48974e7\";}TIME_BOMB|i:1771867555;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771866219;::Q:A|s:0:\"\";:QA::sort|a:2:{i:0;s:7:\"created\";i:1;i:0;}:Q:tasks|O:8:\"QuerySet\":16:{s:5:\"model\";s:4:\"Task\";s:11:\"constraints\";a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:13:\"flags__hasbit\";i:1;}}}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:2;i:2;a:3:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:13:\"flags__hasbit\";i:1;s:8:\"staff_id\";i:1;}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:16:\"ticket__staff_id\";i:1;s:21:\"ticket__status__state\";s:4:\"open\";}}i:2;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:11:\"dept_id__in\";a:3:{i:0;i:1;i:1;i:2;i:2;i:3;}}}}}}}}s:16:\"path_constraints\";a:0:{}s:8:\"ordering\";a:1:{i:0;s:8:\"-created\";}s:7:\"related\";b:0;s:6:\"values\";a:14:{s:2:\"id\";s:2:\"id\";s:6:\"number\";s:6:\"number\";s:7:\"created\";s:7:\"created\";s:8:\"staff_id\";s:8:\"staff_id\";s:7:\"dept_id\";s:7:\"dept_id\";s:7:\"team_id\";s:7:\"team_id\";s:16:\"staff__firstname\";s:16:\"staff__firstname\";s:15:\"staff__lastname\";s:15:\"staff__lastname\";s:10:\"team__name\";s:10:\"team__name\";s:10:\"dept__name\";s:10:\"dept__name\";s:12:\"cdata__title\";s:12:\"cdata__title\";s:5:\"flags\";s:5:\"flags\";s:14:\"ticket__number\";s:14:\"ticket__number\";s:17:\"ticket__ticket_id\";s:17:\"ticket__ticket_id\";}s:5:\"defer\";a:0:{}s:10:\"aggregated\";b:0;s:11:\"annotations\";a:3:{s:12:\"collab_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"collab_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";s:21:\"thread__collaborators\";s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:16:\"attachment_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:16:\"attachment_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:36:\"thread__entries__attachments__inline\";}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:28:\"thread__entries__attachments\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:12:\"thread_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"thread_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:30:\"thread__entries__flags__hasbit\";i:4;}}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:19:\"thread__entries__id\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}}s:5:\"extra\";a:0:{}s:8:\"distinct\";a:0:{}s:4:\"lock\";b:0;s:5:\"chain\";a:0:{}s:7:\"options\";a:0:{}s:4:\"iter\";i:2;s:8:\"compiler\";s:13:\"MySqlCompiler\";}::Q:T|i:1;sort|a:1:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}TTD|i:1771867844;','2026-02-23 18:30:44','2026-02-23 18:28:44','1','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('ecf8d3ce37e3147d4d7074a2612d642f','csrf|a:2:{s:5:\"token\";s:40:\"025a59858d4f50a35e66d38089b62ff722e382b6\";s:4:\"time\";i:1771540006;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:16:\"/scp/plugins.php\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"6d7a057cdc38abef63baa145e6e1b8d2:1771539996:8d91ec19a492cb0772c6acf25e9bdb0e\";}TIME_BOMB|i:1771540006;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771539996;TTD|i:1771540275;','2026-02-19 23:31:15','2026-02-19 23:29:15','1','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('edb1b0936a8d068c09303a06b9627fb1','csrf|N;','2026-02-24 17:11:09','2026-02-23 17:11:09','0','',''),
('ee50485b15a763cd07a06d690317e921','csrf|a:2:{s:5:\"token\";s:40:\"b62a283ecd5ca9222a6c902fef31d4250bdd7209\";s:4:\"time\";i:1771524155;}','2026-02-20 19:02:35','2026-02-19 19:02:35','0','127.0.0.1','curl/8.14.1'),
('eef521dbcb151a6af5c29d052e50a352','csrf|a:2:{s:5:\"token\";s:40:\"34b490c6493b78ff4fb429fe0f95c8afc55b62a8\";s:4:\"time\";i:1771867816;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:21:\"/scp/tickets.php?id=1\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";a:3:{s:2:\"id\";i:1;s:3:\"key\";s:14:\"local:ostadmin\";s:3:\"2fa\";N;}}:token|a:1:{s:5:\"staff\";s:76:\"3cb05b094f40f5df7bbf3f84c2deba24:1771867789:837ec5754f503cfaaee0929fd48974e7\";}TIME_BOMB|i:1771869524;cfg:core|a:1:{s:11:\"db_timezone\";s:13:\"Europe/Berlin\";}lastcroncall|i:1771867725;::Q:A|s:0:\"\";:QA::sort|a:2:{i:0;s:7:\"created\";i:1;i:0;}:Q:tasks|O:8:\"QuerySet\":16:{s:5:\"model\";s:4:\"Task\";s:11:\"constraints\";a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:13:\"flags__hasbit\";i:1;}}}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:2;i:2;a:3:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:13:\"flags__hasbit\";i:1;s:8:\"staff_id\";i:1;}}i:1;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:2:{s:16:\"ticket__staff_id\";i:1;s:21:\"ticket__status__state\";s:4:\"open\";}}i:2;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:11:\"dept_id__in\";a:3:{i:0;i:1;i:1;i:2;i:2;i:3;}}}}}}}}s:16:\"path_constraints\";a:0:{}s:8:\"ordering\";a:1:{i:0;s:8:\"-created\";}s:7:\"related\";b:0;s:6:\"values\";a:14:{s:2:\"id\";s:2:\"id\";s:6:\"number\";s:6:\"number\";s:7:\"created\";s:7:\"created\";s:8:\"staff_id\";s:8:\"staff_id\";s:7:\"dept_id\";s:7:\"dept_id\";s:7:\"team_id\";s:7:\"team_id\";s:16:\"staff__firstname\";s:16:\"staff__firstname\";s:15:\"staff__lastname\";s:15:\"staff__lastname\";s:10:\"team__name\";s:10:\"team__name\";s:10:\"dept__name\";s:10:\"dept__name\";s:12:\"cdata__title\";s:12:\"cdata__title\";s:5:\"flags\";s:5:\"flags\";s:14:\"ticket__number\";s:14:\"ticket__number\";s:17:\"ticket__ticket_id\";s:17:\"ticket__ticket_id\";}s:5:\"defer\";a:0:{}s:10:\"aggregated\";b:0;s:11:\"annotations\";a:3:{s:12:\"collab_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"collab_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";s:21:\"thread__collaborators\";s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:16:\"attachment_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:16:\"attachment_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:36:\"thread__entries__attachments__inline\";}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:28:\"thread__entries__attachments\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}s:12:\"thread_count\";O:12:\"SqlAggregate\":5:{s:5:\"alias\";s:12:\"thread_count\";s:4:\"func\";s:5:\"COUNT\";s:4:\"expr\";O:7:\"SqlCase\":5:{s:5:\"alias\";N;s:5:\"cases\";a:1:{i:0;a:2:{i:0;O:1:\"Q\":3:{i:0;i:0;i:1;i:0;i:2;a:1:{s:30:\"thread__entries__flags__hasbit\";i:4;}}i:1;N;}}s:4:\"else\";O:8:\"SqlField\":5:{s:5:\"alias\";N;s:8:\"operator\";N;s:8:\"operands\";N;s:5:\"level\";i:0;s:5:\"field\";s:19:\"thread__entries__id\";}s:4:\"func\";s:4:\"CASE\";s:4:\"args\";a:0:{}}s:8:\"distinct\";b:1;s:10:\"constraint\";b:0;}}s:5:\"extra\";a:0:{}s:8:\"distinct\";a:0:{}s:4:\"lock\";b:0;s:5:\"chain\";a:0:{}s:7:\"options\";a:0:{}s:4:\"iter\";i:2;s:8:\"compiler\";s:13:\"MySqlCompiler\";}::Q:T|i:1;sort|a:1:{i:1;a:2:{s:9:\"queuesort\";O:9:\"QueueSort\":7:{s:2:\"ht\";a:5:{s:2:\"id\";i:1;s:4:\"root\";N;s:4:\"name\";s:32:\"Priority + Most Recently Updated\";s:7:\"columns\";s:34:\"[\"-cdata__priority\",\"-lastupdate\"]\";s:7:\"updated\";s:19:\"2026-02-19 18:15:04\";}s:5:\"dirty\";a:0:{}s:7:\"__new__\";b:0;s:11:\"__deleted__\";b:0;s:12:\"__deferred__\";a:0:{}s:8:\"_columns\";a:2:{s:15:\"cdata__priority\";b:1;s:10:\"lastupdate\";b:1;}s:6:\"_extra\";N;}s:3:\"dir\";i:0;}}:uploadedFiles|a:1:{i:3;s:44:\"d305860a8a3d474f8927ec785aaa7aaaf47c0ac1.png\";}:form-data|N;TTD|i:1771867936;','2026-02-23 18:32:16','2026-02-23 18:30:16','1','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('eff93c868e80c7d6565477f011c4002d','csrf|N;','2026-02-24 17:14:31','2026-02-23 17:14:31','0','',''),
('f0cac1ece691d374dd9e3a3ad5713b3f','csrf|N;','2026-02-24 17:14:46','2026-02-23 17:14:46','0','',''),
('f53cf82dd80531b91de2274ceb189631','csrf|a:2:{s:5:\"token\";s:40:\"1e543e5094ceba1f92ff9cc8a3aae869d342cf12\";s:4:\"time\";i:1771693359;}_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:21:\"/scp/tickets.php?id=2\";s:3:\"msg\";s:23:\"Authentication Required\";}}_auth|a:1:{s:5:\"staff\";N;}','2026-02-22 18:02:39','2026-02-21 18:02:39','0','192.168.194.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0'),
('f5563d8c2629da4e2f06c37a48246801','csrf|N;_staff|a:1:{s:4:\"auth\";a:2:{s:4:\"dest\";s:5:\"/scp/\";s:3:\"msg\";s:23:\"Authentication Required\";}}','2026-02-20 18:15:21','2026-02-19 18:15:21','0','127.0.0.1','curl/8.14.1'),
('f866e1f15954a67c2f1aebad0b878cbe','csrf|a:2:{s:5:\"token\";s:40:\"ca9a46fb832a11a5d8e16943b3c76afe798850ae\";s:4:\"time\";i:1771524688;}','2026-02-20 19:11:28','2026-02-19 19:11:28','0','127.0.0.1','curl/8.14.1'),
('fc7d1f6a5d19e6e14e7da2571b738928','csrf|N;','2026-02-24 17:11:01','2026-02-23 17:11:01','0','',''),
('fd4a1b38f93f4064d1302efd124c217d','csrf|N;','2026-02-24 18:02:41','2026-02-23 18:02:41','0','','');
/*!40000 ALTER TABLE `ost_session` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_sla`
--

DROP TABLE IF EXISTS `ost_sla`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_sla` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `schedule_id` int(10) unsigned NOT NULL DEFAULT 0,
  `flags` int(10) unsigned NOT NULL DEFAULT 3,
  `grace_period` int(10) unsigned NOT NULL DEFAULT 0,
  `name` varchar(64) NOT NULL DEFAULT '',
  `notes` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_sla`
--

LOCK TABLES `ost_sla` WRITE;
/*!40000 ALTER TABLE `ost_sla` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_sla` VALUES
(1,0,3,18,'Default SLA',NULL,'2026-02-19 18:15:03','2026-02-19 18:15:03');
/*!40000 ALTER TABLE `ost_sla` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_staff`
--

DROP TABLE IF EXISTS `ost_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_staff` (
  `staff_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dept_id` int(10) unsigned NOT NULL DEFAULT 0,
  `role_id` int(10) unsigned NOT NULL DEFAULT 0,
  `username` varchar(32) NOT NULL DEFAULT '',
  `firstname` varchar(32) DEFAULT NULL,
  `lastname` varchar(32) DEFAULT NULL,
  `passwd` varchar(128) DEFAULT NULL,
  `backend` varchar(32) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(24) NOT NULL DEFAULT '',
  `phone_ext` varchar(6) DEFAULT NULL,
  `mobile` varchar(24) NOT NULL DEFAULT '',
  `signature` text NOT NULL,
  `lang` varchar(16) DEFAULT NULL,
  `timezone` varchar(64) DEFAULT NULL,
  `locale` varchar(16) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `isactive` tinyint(1) NOT NULL DEFAULT 1,
  `isadmin` tinyint(1) NOT NULL DEFAULT 0,
  `isvisible` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `onvacation` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `assigned_only` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `show_assigned_tickets` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `change_passwd` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `max_page_size` int(11) unsigned NOT NULL DEFAULT 0,
  `auto_refresh_rate` int(10) unsigned NOT NULL DEFAULT 0,
  `default_signature_type` enum('none','mine','dept') NOT NULL DEFAULT 'none',
  `default_paper_size` enum('Letter','Legal','Ledger','A4','A3') NOT NULL DEFAULT 'Letter',
  `extra` text DEFAULT NULL,
  `permissions` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `lastlogin` datetime DEFAULT NULL,
  `passwdreset` datetime DEFAULT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`staff_id`),
  UNIQUE KEY `username` (`username`),
  KEY `dept_id` (`dept_id`),
  KEY `issuperuser` (`isadmin`),
  KEY `isactive` (`isactive`),
  KEY `onvacation` (`onvacation`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_staff`
--

LOCK TABLES `ost_staff` WRITE;
/*!40000 ALTER TABLE `ost_staff` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_staff` VALUES
(1,1,1,'ostadmin','Root','Admin','$2a$08$Ad.EtInjaaYJslc.jXDsd.lbdh2eSUHjxgTVzboXyn89i/t6QUOwq',NULL,'admin@ki-projekt.local','',NULL,'','',NULL,NULL,NULL,NULL,1,1,1,0,0,0,0,25,0,'none','Letter','{\"browser_lang\":\"en_US\"}','{\"user.create\":1,\"user.delete\":1,\"user.edit\":1,\"user.manage\":1,\"user.dir\":1,\"org.create\":1,\"org.delete\":1,\"org.edit\":1,\"faq.manage\":1,\"visibility.agents\":1,\"emails.banlist\":1,\"visibility.departments\":1}','2026-02-19 18:15:04','2026-02-23 18:58:16','2026-02-19 18:15:04','2026-02-23 18:58:16'),
(2,1,1,'admin2','Admin','User','$2a$08$Ou3rerTJB2CeW.ieicO91OqoIpp/Ub6M3TqDeetSXJ1Hg8PUy/Ope',NULL,'admin2@ki-projekt.local','',NULL,'','',NULL,NULL,NULL,NULL,1,1,1,0,0,0,0,25,0,'none','Letter','{\"browser_lang\":\"en_US\"}','{\"user.create\":1,\"user.delete\":1,\"user.edit\":1,\"user.manage\":1,\"user.dir\":1,\"org.create\":1,\"org.delete\":1,\"org.edit\":1,\"faq.manage\":1,\"visibility.agents\":1,\"emails.banlist\":1,\"visibility.departments\":1}','2026-02-23 09:48:38','2026-02-23 09:50:12','2026-02-23 09:50:36','2026-02-23 09:50:36');
/*!40000 ALTER TABLE `ost_staff` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_staff_dept_access`
--

DROP TABLE IF EXISTS `ost_staff_dept_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_staff_dept_access` (
  `staff_id` int(10) unsigned NOT NULL DEFAULT 0,
  `dept_id` int(10) unsigned NOT NULL DEFAULT 0,
  `role_id` int(10) unsigned NOT NULL DEFAULT 0,
  `flags` int(10) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`staff_id`,`dept_id`),
  KEY `dept_id` (`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_staff_dept_access`
--

LOCK TABLES `ost_staff_dept_access` WRITE;
/*!40000 ALTER TABLE `ost_staff_dept_access` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_staff_dept_access` VALUES
(1,2,1,1),
(1,3,1,1),
(2,2,1,1),
(2,3,1,1);
/*!40000 ALTER TABLE `ost_staff_dept_access` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_syslog`
--

DROP TABLE IF EXISTS `ost_syslog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_syslog` (
  `log_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `log_type` enum('Debug','Warning','Error') NOT NULL,
  `title` varchar(255) NOT NULL,
  `log` text NOT NULL,
  `logger` varchar(64) NOT NULL,
  `ip_address` varchar(64) NOT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`log_id`),
  KEY `log_type` (`log_type`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_syslog`
--

LOCK TABLES `ost_syslog` WRITE;
/*!40000 ALTER TABLE `ost_syslog` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_syslog` VALUES
(1,'Debug','osTicket installed!','Congratulations osTicket basic installation completed!\n\nThank you for choosing osTicket!','','127.0.0.1','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(2,'Error','Mailer Error','Unable to email via Sendmail Unable to send mail: Unknown error ','','192.168.194.181','2026-02-19 23:32:15','2026-02-19 23:32:15'),
(3,'Error','Mailer Error','Unable to email via Sendmail Unable to send mail: Unknown error ','','192.168.194.181','2026-02-19 23:32:15','2026-02-19 23:32:15'),
(4,'Error','Mailer Error','Unable to email via Sendmail Unable to send mail: Unknown error ','','192.168.194.181','2026-02-19 23:41:05','2026-02-19 23:41:05'),
(5,'Error','Mailer Error','Unable to email via Sendmail Unable to send mail: Unknown error ','','192.168.194.181','2026-02-19 23:41:05','2026-02-19 23:41:05'),
(6,'Warning','Invalid CSRF Token __CSRFToken__','Invalid CSRF token [377e9fb17ab4f1bc3ac3533c963c32b176b542f8] on http://192.168.194.65/scp/login.php','','192.168.194.66','2026-02-23 09:49:47','2026-02-23 09:49:47'),
(7,'Error','Mailer Error','Unable to email via Sendmail Unable to send mail: Unknown error ','','192.168.194.181','2026-02-23 16:23:43','2026-02-23 16:23:43'),
(8,'Error','Mailer Error','Unable to email via Sendmail Unable to send mail: Unknown error ','','192.168.194.181','2026-02-23 16:23:43','2026-02-23 16:23:43'),
(9,'Error','Mailer Error','Unable to email via Sendmail Unable to send mail: Unknown error ','','::1','2026-02-23 18:30:16','2026-02-23 18:30:16'),
(10,'Error','Mailer Error','Unable to email via Sendmail Unable to send mail: Unknown error ','','::1','2026-02-23 18:30:16','2026-02-23 18:30:16');
/*!40000 ALTER TABLE `ost_syslog` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_task`
--

DROP TABLE IF EXISTS `ost_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_task` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` int(11) NOT NULL DEFAULT 0,
  `object_type` char(1) NOT NULL,
  `number` varchar(20) DEFAULT NULL,
  `dept_id` int(10) unsigned NOT NULL DEFAULT 0,
  `staff_id` int(10) unsigned NOT NULL DEFAULT 0,
  `team_id` int(10) unsigned NOT NULL DEFAULT 0,
  `lock_id` int(11) unsigned NOT NULL DEFAULT 0,
  `flags` int(10) unsigned NOT NULL DEFAULT 0,
  `duedate` datetime DEFAULT NULL,
  `closed` datetime DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dept_id` (`dept_id`),
  KEY `staff_id` (`staff_id`),
  KEY `team_id` (`team_id`),
  KEY `created` (`created`),
  KEY `object` (`object_id`,`object_type`),
  KEY `flags` (`flags`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_task`
--

LOCK TABLES `ost_task` WRITE;
/*!40000 ALTER TABLE `ost_task` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ost_task` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_task__cdata`
--

DROP TABLE IF EXISTS `ost_task__cdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_task__cdata` (
  `task_id` int(11) unsigned NOT NULL,
  `title` mediumtext DEFAULT NULL,
  PRIMARY KEY (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_task__cdata`
--

LOCK TABLES `ost_task__cdata` WRITE;
/*!40000 ALTER TABLE `ost_task__cdata` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ost_task__cdata` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_team`
--

DROP TABLE IF EXISTS `ost_team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_team` (
  `team_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` int(10) unsigned NOT NULL DEFAULT 0,
  `flags` int(10) unsigned NOT NULL DEFAULT 1,
  `name` varchar(125) NOT NULL DEFAULT '',
  `notes` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`team_id`),
  UNIQUE KEY `name` (`name`),
  KEY `lead_id` (`lead_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_team`
--

LOCK TABLES `ost_team` WRITE;
/*!40000 ALTER TABLE `ost_team` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_team` VALUES
(1,0,1,'Level I Support','Tier 1 support, responsible for the initial iteraction with customers','2026-02-19 18:15:04','2026-02-19 18:15:04');
/*!40000 ALTER TABLE `ost_team` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_team_member`
--

DROP TABLE IF EXISTS `ost_team_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_team_member` (
  `team_id` int(10) unsigned NOT NULL DEFAULT 0,
  `staff_id` int(10) unsigned NOT NULL,
  `flags` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`team_id`,`staff_id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_team_member`
--

LOCK TABLES `ost_team_member` WRITE;
/*!40000 ALTER TABLE `ost_team_member` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ost_team_member` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_thread`
--

DROP TABLE IF EXISTS `ost_thread`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_thread` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` int(11) unsigned NOT NULL,
  `object_type` char(1) NOT NULL,
  `extra` text DEFAULT NULL,
  `lastresponse` datetime DEFAULT NULL,
  `lastmessage` datetime DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `object_id` (`object_id`),
  KEY `object_type` (`object_type`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_thread`
--

LOCK TABLES `ost_thread` WRITE;
/*!40000 ALTER TABLE `ost_thread` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_thread` VALUES
(1,1,'T',NULL,NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(2,2,'T',NULL,NULL,'2026-02-19 23:32:15','2026-02-19 23:32:15'),
(3,3,'T',NULL,'2026-02-19 23:41:05','2026-02-19 23:41:05','2026-02-19 23:41:05'),
(4,4,'T',NULL,NULL,'2026-02-23 16:23:43','2026-02-23 16:23:43'),
(5,5,'T',NULL,NULL,'2026-02-23 18:30:16','2026-02-23 18:30:16');
/*!40000 ALTER TABLE `ost_thread` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_thread_collaborator`
--

DROP TABLE IF EXISTS `ost_thread_collaborator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_thread_collaborator` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `flags` int(10) unsigned NOT NULL DEFAULT 1,
  `thread_id` int(11) unsigned NOT NULL DEFAULT 0,
  `user_id` int(11) unsigned NOT NULL DEFAULT 0,
  `role` char(1) NOT NULL DEFAULT 'M',
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `collab` (`thread_id`,`user_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_thread_collaborator`
--

LOCK TABLES `ost_thread_collaborator` WRITE;
/*!40000 ALTER TABLE `ost_thread_collaborator` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ost_thread_collaborator` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_thread_entry`
--

DROP TABLE IF EXISTS `ost_thread_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_thread_entry` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(11) unsigned NOT NULL DEFAULT 0,
  `thread_id` int(11) unsigned NOT NULL DEFAULT 0,
  `staff_id` int(11) unsigned NOT NULL DEFAULT 0,
  `user_id` int(11) unsigned NOT NULL DEFAULT 0,
  `type` char(1) NOT NULL DEFAULT '',
  `flags` int(11) unsigned NOT NULL DEFAULT 0,
  `poster` varchar(128) NOT NULL DEFAULT '',
  `editor` int(10) unsigned DEFAULT NULL,
  `editor_type` char(1) DEFAULT NULL,
  `source` varchar(32) NOT NULL DEFAULT '',
  `title` varchar(255) DEFAULT NULL,
  `body` text NOT NULL,
  `format` varchar(16) NOT NULL DEFAULT 'html',
  `ip_address` varchar(64) NOT NULL DEFAULT '',
  `extra` text DEFAULT NULL,
  `recipients` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  KEY `thread_id` (`thread_id`),
  KEY `staff_id` (`staff_id`),
  KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_thread_entry`
--

LOCK TABLES `ost_thread_entry` WRITE;
/*!40000 ALTER TABLE `ost_thread_entry` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_thread_entry` VALUES
(1,0,1,0,1,'M',65,'osTicket Team',NULL,NULL,'Web','osTicket Installed!',' <p>Thank you for choosing osTicket. </p> <p>Please make sure you join the <a href=\"https://forum.osticket.com\">osTicket forums</a> and our <a href=\"https://osticket.com\">mailing list</a> to stay up to date on the latest news, security alerts and updates. The osTicket forums are also a great place to get assistance, guidance, tips, and help from other osTicket users. In addition to the forums, the <a href=\"https://docs.osticket.com\">osTicket Docs</a> provides a useful collection of educational materials, documentation, and notes from the community. We welcome your contributions to the osTicket community. </p> <p>If you are looking for a greater level of support, we provide professional services and commercial support with guaranteed response times, and access to the core development team. We can also help customize osTicket or even add new features to the system to meet your unique needs. </p> <p>If the idea of managing and upgrading this osTicket installation is daunting, you can try osTicket as a hosted service at <a href=\"https://supportsystem.com\">https://supportsystem.com/</a> -- no installation required and we can import your data! With SupportSystem\'s turnkey infrastructure, you get osTicket at its best, leaving you free to focus on your customers without the burden of making sure the application is stable, maintained, and secure. </p> <p>Cheers, </p> <p>-<br /> osTicket Team - https://osticket.com/ </p> <p><strong>PS.</strong> Don\'t just make customers happy, make happy customers! </p>','html','127.0.0.1',NULL,NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04'),
(2,0,2,0,2,'M',577,'Yannick',NULL,NULL,'Email',NULL,'<p>Can\'t login</p>','html','192.168.194.181',NULL,'{\"to\":{\"2\":\"Yannick <yannick.beck@test.de>\"}}','2026-02-19 23:32:15','2026-02-19 23:32:15'),
(3,0,3,0,2,'M',577,'Yannick',NULL,NULL,'Email',NULL,'<p>ES GEHT NICHT</p>','html','192.168.194.181',NULL,'{\"to\":{\"2\":\"Yannick <yannick.beck@test.de>\"}}','2026-02-19 23:41:05','2026-02-19 23:41:05'),
(4,3,3,1,0,'R',576,'Root Admin',NULL,NULL,'Email',NULL,'<p>osTicket is a widely-used open source support ticket system, an</p> <p>attractive alternative to higher-cost and complex customer support</p> <p>systems - simple, lightweight, reliable, open source, web-based and easy</p> <p>to setup and use.</p>','html','192.168.194.181',NULL,'{\"to\":{\"2\":\"Yannick <yannick.beck@test.de>\"}}','2026-02-19 23:41:05','2026-02-19 23:41:05'),
(5,0,3,0,0,'N',192,'SYSTEM',NULL,NULL,'',' AI Draft Reply','<div style=\"border:2px solid #4A90D9;border-radius:6px;margin:5px 0;font-family:Arial, sans-serif\"><div style=\"background:#4A90D9;color:#fff;padding:8px 12px;font-size:14px;font-weight:bold\"> AI Reply Assistant â€” Draft Suggestion</div><div style=\"background:#f0f4f8;padding:6px 12px;font-size:12px;color:#555;border-bottom:1px solid #ddd\">Confidence: <strong style=\"color:#27ae60\">85%</strong> Â |Â  Model: <strong>gemma3:4b</strong> Â |Â  Tokens: 769 Â |Â  <span style=\"color:#e67e22;font-weight:bold\">âš  More info needed</span></div><div style=\"padding:8px 12px;font-size:13px;color:#666;border-bottom:1px solid #eee\"><strong>Suggested Subject:</strong> Problembeschreibung</div><div style=\"padding:12px;font-size:14px;line-height:1.6;color:#333\"><strong> Draft Reply:</strong><br /><br />Es tut mir leid, dass es nicht funktioniert. KÃ¶nnten Sie bitte genauer beschreiben, was nicht funktioniert?</div><div style=\"padding:10px 12px;background:#fff8e1;border-top:1px solid #ffe082\"><strong style=\"color:#e67e22\"> Suggested questions to ask the customer:</strong><ol style=\"margin:5px 0 5px 20px;padding:0\"><li style=\"margin:3px 0\">Welches Problem treten auf?</li><li style=\"margin:3px 0\">Welches System oder welche Anwendung betrifft das Problem?</li><li style=\"margin:3px 0\">Welche Fehlermeldung wird angezeigt?</li></ol></div><div style=\"padding:8px 12px;border-top:1px solid #eee;font-size:12px\"><strong> Suggested Tags:</strong> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">problem</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">support</span></div><div style=\"padding:6px 12px;background:#f9f9f9;border-top:1px solid #eee;font-size:11px;color:#999;font-style:italic\">âš  This is an AI-generated draft. Review carefully before sending to the customer. Do not send without verification.</div></div>','html','192.168.194.181',NULL,NULL,'2026-02-19 23:44:18','2026-02-19 23:44:18'),
(6,0,2,0,0,'N',192,'SYSTEM',NULL,NULL,'',' AI Draft Reply','<div style=\"border:2px solid #4A90D9;border-radius:6px;margin:5px 0;font-family:Arial, sans-serif\"><div style=\"background:#4A90D9;color:#fff;padding:8px 12px;font-size:14px;font-weight:bold\"> AI Reply Assistant â€” Draft Suggestion</div><div style=\"background:#f0f4f8;padding:6px 12px;font-size:12px;color:#555;border-bottom:1px solid #ddd\">Confidence: <strong style=\"color:#27ae60\">90%</strong> Â |Â  Model: <strong>gemma3:4b</strong> Â |Â  Tokens: 743 Â |Â  <span style=\"color:#e67e22;font-weight:bold\">âš  More info needed</span></div><div style=\"padding:8px 12px;font-size:13px;color:#666;border-bottom:1px solid #eee\"><strong>Suggested Subject:</strong> Login-Problem</div><div style=\"padding:12px;font-size:14px;line-height:1.6;color:#333\"><strong> Draft Reply:</strong><br /><br />Guten Tag Yannick,<br /> <br /> Ich verstehe, dass Sie Probleme beim Login haben. Da kein Wissensdatenbankinhalt verfÃ¼gbar ist, kann ich Ihnen aktuell keine spezifischen Schritte zur LÃ¶sung anbieten. <br /> <br /> Bitte teilen Sie mir mit, ob Sie die Ã¼blichen Zugangsdaten verwenden und ob Sie Fehlermeldungen erhalten.</div><div style=\"padding:10px 12px;background:#fff8e1;border-top:1px solid #ffe082\"><strong style=\"color:#e67e22\"> Suggested questions to ask the customer:</strong><ol style=\"margin:5px 0 5px 20px;padding:0\"><li style=\"margin:3px 0\">Welche Zugangsdaten verwenden Sie (Benutzername/E-Mail und Passwort)?</li><li style=\"margin:3px 0\">Erhalten Sie beim Login eine Fehlermeldung? Wenn ja, wie lautet diese?</li><li style=\"margin:3px 0\">Haben Sie kÃ¼rzlich Ihr Passwort geÃ¤ndert?</li></ol></div><div style=\"padding:8px 12px;border-top:1px solid #eee;font-size:12px\"><strong> Suggested Tags:</strong> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">login</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">account-access</span></div><div style=\"padding:6px 12px;background:#f9f9f9;border-top:1px solid #eee;font-size:11px;color:#999;font-style:italic\">âš  This is an AI-generated draft. Review carefully before sending to the customer. Do not send without verification.</div></div>','html','192.168.194.181',NULL,NULL,'2026-02-20 00:03:19','2026-02-20 00:03:19'),
(7,0,2,0,0,'N',192,'SYSTEM',NULL,NULL,'',' AI Draft Reply','<div style=\"border:2px solid #4A90D9;border-radius:6px;margin:5px 0;font-family:Arial, sans-serif\"><div style=\"background:#4A90D9;color:#fff;padding:8px 12px;font-size:14px;font-weight:bold\"> AI Reply Assistant â€” Draft Suggestion</div><div style=\"background:#f0f4f8;padding:6px 12px;font-size:12px;color:#555;border-bottom:1px solid #ddd\">Confidence: <strong style=\"color:#27ae60\">95%</strong> Â |Â  Model: <strong>gemma3:4b</strong> Â |Â  Tokens: 1,607</div><div style=\"padding:8px 12px;font-size:13px;color:#666;border-bottom:1px solid #eee\"><strong>Suggested Subject:</strong> Login-Problem</div><div style=\"padding:12px;font-size:14px;line-height:1.6;color:#333\"><strong> Draft Reply:</strong><br /><br />Guten Tag,<br /> <br /> Bei Ihrem Login-Problem kÃ¶nnen Sie bitte zuerst Ihren Benutzernamen und UPN Ã¼berprÃ¼fen. Bitte stellen Sie sicher, dass Sie die richtige GroÃŸ- und Kleinschreibung verwenden. ÃœberprÃ¼fen Sie auÃŸerdem die Uhrzeit und die Zeitsynchronisation. Zudem sollten Sie den Netzwerkpfad und die DNS-AuflÃ¶sung prÃ¼fen sowie den Status Ihrer Konto-Sperre und MFA-Status.<br /> <br /> Bitte dokumentieren Sie das Ergebnis jedes Anmeldeversuchs.<br /> <br /> Referenz: http://192.168.194.65/scp/categories.php?id=28</div><div style=\"padding:8px 12px;border-top:1px solid #eee;font-size:12px\"><strong> Suggested Tags:</strong> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">login</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">anmeldung</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">demomass</span></div><div style=\"padding:6px 12px;background:#f9f9f9;border-top:1px solid #eee;font-size:11px;color:#999;font-style:italic\">âš  This is an AI-generated draft. Review carefully before sending to the customer. Do not send without verification.</div></div>','html','192.168.194.181',NULL,NULL,'2026-02-20 12:20:47','2026-02-20 12:20:47'),
(8,0,1,0,0,'N',192,'SYSTEM',NULL,NULL,'',' AI Draft Reply','<div style=\"border:2px solid #4A90D9;border-radius:6px;margin:5px 0;font-family:Arial, sans-serif\"><div style=\"background:#4A90D9;color:#fff;padding:8px 12px;font-size:14px;font-weight:bold\"> AI Reply Assistant â€” Draft Suggestion</div><div style=\"background:#f0f4f8;padding:6px 12px;font-size:12px;color:#555;border-bottom:1px solid #ddd\">Confidence: <strong style=\"color:#27ae60\">95%</strong> Â |Â  Model: <strong>gemma3:4b</strong> Â |Â  Tokens: 2,003</div><div style=\"padding:8px 12px;font-size:13px;color:#666;border-bottom:1px solid #eee\"><strong>Suggested Subject:</strong> osTicket Installation - Erste Schritte</div><div style=\"padding:12px;font-size:14px;line-height:1.6;color:#333\"><strong> Draft Reply:</strong><br /><br />Vielen Dank fÃ¼r Ihre osTicket Installation! Bitte beachten Sie, dass wir Ihnen bei der Stabilisierung Ihrer Installation behilflich sein kÃ¶nnen, indem wir die StÃ¶rung klassifizieren und erste MaÃŸnahmen ergreifen. Wie in den verfÃ¼gbaren Wissensartikeln beschrieben, beinhaltet dies die Erfassung der Auswirkungen und Betroffenheit, die Priorisierung nach SLA und die DurchfÃ¼hrung einer SofortmaÃŸnahme zur Stabilisierung. Bitte sichern Sie LogeintrÃ¤ge und Fehlermeldungen und aktualisieren Sie das Ticket mit reproduzierbaren Schritten. <br /> <br /> Referenzen:<br /> Sources:<br /> - http://192.168.194.65/scp/categories.php?id=98</div><div style=\"padding:8px 12px;border-top:1px solid #eee;font-size:12px\"><strong> Suggested Tags:</strong> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">osticket</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">installation</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">support</span></div><div style=\"padding:6px 12px;background:#f9f9f9;border-top:1px solid #eee;font-size:11px;color:#999;font-style:italic\">âš  This is an AI-generated draft. Review carefully before sending to the customer. Do not send without verification.</div></div>','html','192.168.194.66',NULL,NULL,'2026-02-23 09:53:27','2026-02-23 09:53:27'),
(9,0,4,0,3,'M',577,'Yannick',NULL,NULL,'Email',NULL,'<figure><img src=\"cid:wle_c0wwgcoo9r0-jj-x4wqp6qvr8cse\" data-image=\"WLE_C0wWGCoo9R0-JJ-x4Wqp6qvR8CsE\" alt=\"image\" /></figure> <p>Ich habe beim Login eine Fehlermeldung. Mein SSO funktioniert nicht. Hilfe ASAP</p>','html','192.168.194.181',NULL,'{\"to\":{\"3\":\"Yannick <Yannick@test.de>\"}}','2026-02-23 16:23:43','2026-02-23 16:23:43'),
(10,0,4,0,0,'N',192,'SYSTEM',NULL,NULL,'',' AI Draft Reply','<div style=\"border:2px solid #4A90D9;border-radius:6px;margin:5px 0;font-family:Arial, sans-serif\"><div style=\"background:#4A90D9;color:#fff;padding:8px 12px;font-size:14px;font-weight:bold\"> AI Reply Assistant â€” Draft Suggestion</div><div style=\"background:#f0f4f8;padding:6px 12px;font-size:12px;color:#555;border-bottom:1px solid #ddd\">Confidence: <strong style=\"color:#27ae60\">90%</strong> Â |Â  Model: <strong>gemma3:4b</strong> Â |Â  Tokens: 1,723</div><div style=\"padding:8px 12px;font-size:13px;color:#666;border-bottom:1px solid #eee\"><strong>Suggested Subject:</strong> SSO Fehler - Erstdiagnose</div><div style=\"padding:12px;font-size:14px;line-height:1.6;color:#333\"><strong> Draft Reply:</strong><br /><br />Sehr geehrter Herr Yannick,<br /> <br /> bitte prÃ¼fen Sie anhand der folgenden Schritte Ihren Benutzernamen und UPN. ÃœberprÃ¼fen Sie auch die Uhrzeit und Zeitsynchronisation sowie den Netzwerkpfad und DNS-AuflÃ¶sung. Kontrollieren Sie die Konto-Sperre und den MFA-Status. Bitte dokumentieren Sie das Ergebnis nach einer erneuten Anmeldung.<br /> <br /> Referenz: http://192.168.194.65/scp/categories.php?id=35</div><div style=\"padding:8px 12px;border-top:1px solid #eee;font-size:12px\"><strong> Suggested Tags:</strong> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">sso</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">anmeldungfehlgeschlagen</span></div><div style=\"padding:6px 12px;background:#f9f9f9;border-top:1px solid #eee;font-size:11px;color:#999;font-style:italic\">âš  This is an AI-generated draft. Review carefully before sending to the customer. Do not send without verification.</div></div>','html','192.168.194.181',NULL,NULL,'2026-02-23 16:25:46','2026-02-23 16:25:46'),
(11,0,1,0,0,'N',192,'SYSTEM',NULL,NULL,'',' AI Draft Reply','<div style=\"border:2px solid #4A90D9;border-radius:6px;margin:5px 0;font-family:Arial, sans-serif\"><div style=\"background:#4A90D9;color:#fff;padding:8px 12px;font-size:14px;font-weight:bold\"> AI Reply Assistant â€” Draft Suggestion</div><div style=\"background:#f0f4f8;padding:6px 12px;font-size:12px;color:#555;border-bottom:1px solid #ddd\">Confidence: <strong style=\"color:#27ae60\">95%</strong> Â |Â  Model: <strong>gemma3:4b</strong> Â |Â  Tokens: 2,157</div><div style=\"padding:8px 12px;font-size:13px;color:#666;border-bottom:1px solid #eee\"><strong>Suggested Subject:</strong> osTicket Installation - Initial Support</div><div style=\"padding:12px;font-size:14px;line-height:1.6;color:#333\"><strong> Draft Reply:</strong><br /><br />Sehr geehrte osTicket Team,<br /> <br /> Vielen Dank fÃ¼r Ihre Nachricht bezÃ¼glich Ihrer osTicket Installation. Wir freuen uns, dass Sie osTicket nutzen. <br /> <br /> GemÃ¤ÃŸ unseren Wissensdatenbankartikeln (siehe Quellen unten), ist das Ziel bei StÃ¶rungen die schnelle Einordnung und Stabilisierung. Dazu gehÃ¶ren die Erfassung der Auswirkung und Betroffenheit, die Priorisierung nach SLA und die DurchfÃ¼hrung sofortiger StabilisierungsmaÃŸnahmen. Bitte dokumentieren Sie reproduzierbare Schritte und sichern Sie LogeintrÃ¤ge und Fehlermeldungen.<br /> <br /> Quellen:<br /> - http://192.168.194.65/scp/categories.php?id=98<br /> - http://192.168.194.65/scp/categories.php?id=83<br /> - http://192.168.194.65/scp/categories.php?id=53<br /> - http://192.168.194.65/scp/categories.php?id=40<br /> - http://192.168.194.65/scp/categories.php?id=76</div><div style=\"padding:8px 12px;border-top:1px solid #eee;font-size:12px\"><strong> Suggested Tags:</strong> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">installation</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">support</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">osticket</span></div><div style=\"padding:6px 12px;background:#f9f9f9;border-top:1px solid #eee;font-size:11px;color:#999;font-style:italic\">âš  This is an AI-generated draft. Review carefully before sending to the customer. Do not send without verification.</div></div>','html','::1',NULL,NULL,'2026-02-23 17:10:39','2026-02-23 17:10:39'),
(12,0,1,0,0,'N',192,'SYSTEM',NULL,NULL,'',' AI Draft Reply','<div style=\"border:2px solid #4A90D9;border-radius:6px;margin:5px 0;font-family:Arial, sans-serif\"><div style=\"background:#4A90D9;color:#fff;padding:8px 12px;font-size:14px;font-weight:bold\"> AI Reply Assistant â€” Draft Suggestion</div><div style=\"background:#f0f4f8;padding:6px 12px;font-size:12px;color:#555;border-bottom:1px solid #ddd\">Confidence: <strong style=\"color:#27ae60\">100%</strong> Â |Â  Model: <strong>gemma3:4b</strong> Â |Â  Tokens: 1,307</div><div style=\"padding:8px 12px;font-size:13px;color:#666;border-bottom:1px solid #eee\"><strong>Suggested Subject:</strong> osTicket Installation Information</div><div style=\"padding:12px;font-size:14px;line-height:1.6;color:#333\"><strong> Draft Reply:</strong><br /><br />Vielen Dank fÃ¼r die Nutzung von osTicket. Bitte besuchen Sie die osTicket-Foren unter <a href=\"https://forum.osticket.com\">https://forum.osticket.com</a> und unsere Mailingliste unter <a href=\"https://osticket.com\">https://osticket.com</a>, um Ã¼ber die neuesten Nachrichten, Sicherheitswarnungen und Updates informiert zu bleiben. Die osTicket-Foren sind auch ein groÃŸartiger Ort, um Hilfe, Anleitung, Tipps und UnterstÃ¼tzung von anderen osTicket-Benutzern zu erhalten. Die osTicket Docs unter <a href=\"https://docs.osticket.com\">https://docs.osticket.com</a> bieten eine nÃ¼tzliche Sammlung von Bildungsmaterialien, Dokumentation und Notizen von der Community. <br /> <br /> FÃ¼r eine grÃ¶ÃŸere UnterstÃ¼tzung bieten wir professionelle Dienstleistungen und kommerzielle UnterstÃ¼tzung mit garantierten Reaktionszeiten und Zugang zum Kernentwicklungsteam. Wir kÃ¶nnen Ihnen auch bei der Anpassung von osTicket oder dem HinzufÃ¼gen neuer Funktionen zum System helfen, um Ihre spezifischen BedÃ¼rfnisse zu erfÃ¼llen.</div><div style=\"padding:8px 12px;border-top:1px solid #eee;font-size:12px\"><strong> Suggested Tags:</strong> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">installation</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">support</span></div><div style=\"padding:6px 12px;background:#f9f9f9;border-top:1px solid #eee;font-size:11px;color:#999;font-style:italic\">âš  This is an AI-generated draft. Review carefully before sending to the customer. Do not send without verification.</div></div>','html','::1',NULL,NULL,'2026-02-23 17:59:43','2026-02-23 17:59:43'),
(13,0,4,0,0,'N',192,'SYSTEM',NULL,NULL,'',' AI Draft Reply','<div style=\"border:2px solid #4A90D9;border-radius:6px;margin:5px 0;font-family:Arial, sans-serif\"><div style=\"background:#4A90D9;color:#fff;padding:8px 12px;font-size:14px;font-weight:bold\"> AI Reply Assistant â€” Draft Suggestion</div><div style=\"background:#f0f4f8;padding:6px 12px;font-size:12px;color:#555;border-bottom:1px solid #ddd\">Confidence: <strong style=\"color:#27ae60\">90%</strong> Â |Â  Model: <strong>gemma3:4b</strong> Â |Â  Tokens: 993 Â |Â  <span style=\"color:#e67e22;font-weight:bold\">âš  More info needed</span></div><div style=\"padding:8px 12px;font-size:13px;color:#666;border-bottom:1px solid #eee\"><strong>Suggested Subject:</strong> SSO Fehler â€“ Dringende UnterstÃ¼tzung</div><div style=\"padding:12px;font-size:14px;line-height:1.6;color:#333\"><strong> Draft Reply:</strong><br /><br />Sehr geehrter Herr Yannick,<br /> <br /> wir erhalten Ihre Meldung bezÃ¼glich des SSO-Fehlers. Wir verstehen, dass dies dringend ist.<br /> <br /> Da keine spezifischen Informationen in der Wissensdatenbank verfÃ¼gbar sind, benÃ¶tigen wir weitere Details, um Ihnen effektiv helfen zu kÃ¶nnen.<br /> <br /> Bitte teilen Sie uns mit, welche Fehlermeldung Sie erhalten und welche Schritte Sie bereits zur Fehlerbehebung unternommen haben.<br /> <br /> Mit freundlichen GrÃ¼ÃŸen,<br /> Ihr Support-Team</div><div style=\"padding:10px 12px;background:#fff8e1;border-top:1px solid #ffe082\"><strong style=\"color:#e67e22\"> Suggested questions to ask the customer:</strong><ol style=\"margin:5px 0 5px 20px;padding:0\"><li style=\"margin:3px 0\">Bitte geben Sie die genaue Fehlermeldung an, die Sie erhalten.</li><li style=\"margin:3px 0\">Welches Browser- und Betriebssystem verwenden Sie?</li><li style=\"margin:3px 0\">Haben Sie kÃ¼rzlich Ã„nderungen an Ihren Sicherheitseinstellungen vorgenommen?</li></ol></div><div style=\"padding:8px 12px;border-top:1px solid #eee;font-size:12px\"><strong> Suggested Tags:</strong> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">sso</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">fehler</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">dringend</span></div><div style=\"padding:6px 12px;background:#f9f9f9;border-top:1px solid #eee;font-size:11px;color:#999;font-style:italic\">âš  This is an AI-generated draft. Review carefully before sending to the customer. Do not send without verification.</div></div>','html','::1',NULL,NULL,'2026-02-23 18:02:21','2026-02-23 18:02:21'),
(14,0,5,0,2,'M',577,'Yannick',NULL,NULL,'Phone',NULL,'<figure><img src=\"cid:wle_c0wwgcoo9r0-jj-x4wqp6qvr8cse\" data-image=\"WLE_C0wWGCoo9R0-JJ-x4Wqp6qvR8CsE\" alt=\"image\" /></figure> <p>BILDTEST-MULTIMODAL-4711</p> <p>Bitte analysiere den angehÃ¤ngten Screenshot und antworte NUR basierend auf dem, was im Bild steht.</p> <p>Wichtig:</p> <p>1) Nenne exakt den sichtbaren Fehlertext aus dem Screenshot.</p> <p>2) Nenne 2 konkrete nÃ¤chste Schritte zur Behebung.</p> <p>3) FÃ¼ge am Ende den Satz hinzu: \"Bildanalyse wurde verwendet.\"</p> <p>4) Antworte auf Deutsch.</p> <figure><img src=\"cid:wle_c0wwgcoo9r0-jj-x4wqp6qvr8cse\" data-image=\"WLE_C0wWGCoo9R0-JJ-x4Wqp6qvR8CsE\" alt=\"image\" /></figure>','html','::1',NULL,'{\"to\":{\"2\":\"Yannick <yannick.beck@test.de>\"}}','2026-02-23 18:30:16','2026-02-23 18:30:16'),
(15,0,5,0,0,'N',192,'SYSTEM',NULL,NULL,'',' AI Draft Reply','<div style=\"border:2px solid #4A90D9;border-radius:6px;margin:5px 0;font-family:Arial, sans-serif\"><div style=\"background:#4A90D9;color:#fff;padding:8px 12px;font-size:14px;font-weight:bold\"> AI Reply Assistant â€” Draft Suggestion</div><div style=\"background:#f0f4f8;padding:6px 12px;font-size:12px;color:#555;border-bottom:1px solid #ddd\">Confidence: <strong style=\"color:#27ae60\">95%</strong> Â |Â  Model: <strong>gemma3:4b</strong> Â |Â  Tokens: 1,992</div><div style=\"padding:8px 12px;font-size:13px;color:#666;border-bottom:1px solid #eee\"><strong>Suggested Subject:</strong> Screenshot Fehler Analyse</div><div style=\"padding:12px;font-size:14px;line-height:1.6;color:#333\"><strong> Draft Reply:</strong><br /><br />Basierend auf dem Screenshot ist der sichtbare Fehlertext: \'Bildtest-Multimodal-4711\'.<br /> <br /> Zwei konkrete nÃ¤chste Schritte zur Behebung sind:<br /> 1. ÃœberprÃ¼fen Sie die Konfiguration des Bildtests.<br /> 2. FÃ¼hren Sie einen Neustart des Systems durch.<br /> <br /> Bildanalyse wurde verwendet.</div><div style=\"padding:8px 12px;border-top:1px solid #eee;font-size:12px\"><strong> Suggested Tags:</strong> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">screenshot</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">fehler</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">analyse</span></div><div style=\"padding:6px 12px;background:#f9f9f9;border-top:1px solid #eee;font-size:11px;color:#999;font-style:italic\">âš  This is an AI-generated draft. Review carefully before sending to the customer. Do not send without verification.</div></div>','html','::1',NULL,NULL,'2026-02-23 18:33:02','2026-02-23 18:33:02'),
(16,0,4,0,0,'N',192,'SYSTEM',NULL,NULL,'',' AI Draft Reply','<div style=\"border:2px solid #4A90D9;border-radius:6px;margin:5px 0;font-family:Arial, sans-serif\"><div style=\"background:#4A90D9;color:#fff;padding:8px 12px;font-size:14px;font-weight:bold\"> AI Reply Assistant â€” Draft Suggestion</div><div style=\"background:#f0f4f8;padding:6px 12px;font-size:12px;color:#555;border-bottom:1px solid #ddd\">Confidence: <strong style=\"color:#27ae60\">95%</strong> Â |Â  Model: <strong>gemma3:4b</strong> Â |Â  Tokens: 1,765</div><div style=\"padding:8px 12px;font-size:13px;color:#666;border-bottom:1px solid #eee\"><strong>Suggested Subject:</strong> SSO-Fehler</div><div style=\"padding:12px;font-size:14px;line-height:1.6;color:#333\"><strong> Draft Reply:</strong><br /><br />Sehr geehrter Herr Yannick,<br /> <br /> bitte prÃ¼fen Sie anhand der folgenden Schritte, ob das Problem behoben werden kann:<br /> <br /> 1. ÃœberprÃ¼fen Sie Ihren Benutzernamen und Ihre UPN.<br /> 2. Stellen Sie sicher, dass die Uhrzeit und die Zeitsynchronisation korrekt sind.<br /> 3. PrÃ¼fen Sie den Netzwerkpfad und die DNS-AuflÃ¶sung.<br /> 4. ÃœberprÃ¼fen Sie, ob Ihr Konto gesperrt ist oder ob MFA aktiv ist.<br /> <br /> Bitte melden Sie das Ergebnis Ihrer ÃœberprÃ¼fung.<br /> <br /> Referenz: http://192.168.194.65/scp/faq.php?id=105</div><div style=\"padding:8px 12px;border-top:1px solid #eee;font-size:12px\"><strong> Suggested Tags:</strong> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">sso</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">anmeldung</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">fehler</span></div><div style=\"padding:6px 12px;background:#f9f9f9;border-top:1px solid #eee;font-size:11px;color:#999;font-style:italic\">âš  This is an AI-generated draft. Review carefully before sending to the customer. Do not send without verification.</div></div>','html','192.168.194.181',NULL,NULL,'2026-02-23 18:36:25','2026-02-23 18:36:25'),
(17,0,5,0,0,'N',192,'SYSTEM',NULL,NULL,'',' AI Draft Reply','<div style=\"border:2px solid #4A90D9;border-radius:6px;margin:5px 0;font-family:Arial, sans-serif\"><div style=\"background:#4A90D9;color:#fff;padding:8px 12px;font-size:14px;font-weight:bold\"> AI Reply Assistant â€” Draft Suggestion</div><div style=\"background:#f0f4f8;padding:6px 12px;font-size:12px;color:#555;border-bottom:1px solid #ddd\">Confidence: <strong style=\"color:#27ae60\">95%</strong> Â |Â  Model: <strong>gemma3:4b</strong> Â |Â  Tokens: 1,991</div><div style=\"padding:8px 12px;font-size:13px;color:#666;border-bottom:1px solid #eee\"><strong>Suggested Subject:</strong> Screenshot Fehler Analyse</div><div style=\"padding:12px;font-size:14px;line-height:1.6;color:#333\"><strong> Draft Reply:</strong><br /><br />Basierend auf dem Screenshot ist der sichtbare Fehlertext: \'Bildtest-Multimodal-4711\'.<br /> <br /> Zwei konkrete nÃ¤chste Schritte zur Behebung sind:<br /> 1. ÃœberprÃ¼fen Sie die Konfiguration des Bildtests.<br /> 2. Testen Sie die einzelnen Komponenten isoliert.<br /> <br /> Bildanalyse wurde verwendet.</div><div style=\"padding:8px 12px;border-top:1px solid #eee;font-size:12px\"><strong> Suggested Tags:</strong> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">screenshot</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">fehler</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">analyse</span></div><div style=\"padding:6px 12px;background:#f9f9f9;border-top:1px solid #eee;font-size:11px;color:#999;font-style:italic\">âš  This is an AI-generated draft. Review carefully before sending to the customer. Do not send without verification.</div></div>','html','192.168.194.181',NULL,NULL,'2026-02-23 18:40:41','2026-02-23 18:40:41'),
(18,0,4,0,0,'N',192,'SYSTEM',NULL,NULL,'',' AI Draft Reply','<div style=\"border:2px solid #4A90D9;border-radius:6px;margin:5px 0;font-family:Arial, sans-serif\"><div style=\"background:#4A90D9;color:#fff;padding:8px 12px;font-size:14px;font-weight:bold\"> AI Reply Assistant â€” Draft Suggestion</div><div style=\"background:#f0f4f8;padding:6px 12px;font-size:12px;color:#555;border-bottom:1px solid #ddd\">Confidence: <strong style=\"color:#27ae60\">95%</strong> Â |Â  Model: <strong>gemma3:4b</strong> Â |Â  Tokens: 1,729</div><div style=\"padding:8px 12px;font-size:13px;color:#666;border-bottom:1px solid #eee\"><strong>Suggested Subject:</strong> SSO-Fehler</div><div style=\"padding:12px;font-size:14px;line-height:1.6;color:#333\"><strong> Draft Reply:</strong><br /><br />Sehr geehrter Herr Yannick,<br /> <br /> bitte prÃ¼fen Sie anhand der folgenden Schritte, ob die genannten Symptome auftreten:<br /> <br /> * PrÃ¼fen Sie Ihren Benutzernamen und UPN.<br /> * ÃœberprÃ¼fen Sie die Uhrzeit und die Zeitsynchronisation.<br /> * Stellen Sie sicher, dass Ihr Netzwerkpfad und DNS-AuflÃ¶sung korrekt sind.<br /> * ÃœberprÃ¼fen Sie, ob Ihr Konto gesperrt ist oder ob MFA aktiv ist.<br /> <br /> Bitte melden Sie uns das Ergebnis Ihrer ÃœberprÃ¼fung.</div><div style=\"padding:8px 12px;border-top:1px solid #eee;font-size:12px\"><strong> Suggested Tags:</strong> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">sso</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">fehler</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">anmeldung</span></div><div style=\"padding:6px 12px;background:#f9f9f9;border-top:1px solid #eee;font-size:11px;color:#999;font-style:italic\">âš  This is an AI-generated draft. Review carefully before sending to the customer. Do not send without verification.</div></div>','html','192.168.194.181',NULL,NULL,'2026-02-23 18:48:55','2026-02-23 18:48:55'),
(19,0,5,0,0,'N',192,'SYSTEM',NULL,NULL,'',' AI Draft Reply','<div style=\"border:2px solid #4A90D9;border-radius:6px;margin:5px 0;font-family:Arial, sans-serif\"><div style=\"background:#4A90D9;color:#fff;padding:8px 12px;font-size:14px;font-weight:bold\"> AI Reply Assistant â€” Draft Suggestion</div><div style=\"background:#f0f4f8;padding:6px 12px;font-size:12px;color:#555;border-bottom:1px solid #ddd\">Confidence: <strong style=\"color:#27ae60\">95%</strong> Â |Â  Model: <strong>gemma3:4b</strong> Â |Â  Tokens: 1,990</div><div style=\"padding:8px 12px;font-size:13px;color:#666;border-bottom:1px solid #eee\"><strong>Suggested Subject:</strong> Screenshot Fehler Analyse</div><div style=\"padding:12px;font-size:14px;line-height:1.6;color:#333\"><strong> Draft Reply:</strong><br /><br />Basierend auf dem Screenshot ist der sichtbare Fehlertext: \'Bildtest-Multimodal-4711\'.<br /> <br /> 2. Konkrete nÃ¤chste Schritte zur Behebung:<br /> 1. Komponenten einzeln isoliert testen.<br /> 2. Konfigurationsabweichungen vergleichen.<br /> <br /> Bildanalyse wurde verwendet.</div><div style=\"padding:8px 12px;border-top:1px solid #eee;font-size:12px\"><strong> Suggested Tags:</strong> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">screenshot</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">fehler</span> <span style=\"background:#e3edf7;color:#2c5282;padding:2px 8px;border-radius:10px;font-size:11px;margin:0 2px\">analyse</span></div><div style=\"padding:6px 12px;background:#f9f9f9;border-top:1px solid #eee;font-size:11px;color:#999;font-style:italic\">âš  This is an AI-generated draft. Review carefully before sending to the customer. Do not send without verification.</div></div>','html','::1',NULL,NULL,'2026-02-23 19:01:20','2026-02-23 19:01:20');
/*!40000 ALTER TABLE `ost_thread_entry` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_thread_entry_email`
--

DROP TABLE IF EXISTS `ost_thread_entry_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_thread_entry_email` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `thread_entry_id` int(11) unsigned NOT NULL,
  `email_id` int(11) unsigned DEFAULT NULL,
  `mid` varchar(255) NOT NULL,
  `headers` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `thread_entry_id` (`thread_entry_id`),
  KEY `mid` (`mid`),
  KEY `email_id` (`email_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_thread_entry_email`
--

LOCK TABLES `ost_thread_entry_email` WRITE;
/*!40000 ALTER TABLE `ost_thread_entry_email` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ost_thread_entry_email` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_thread_entry_merge`
--

DROP TABLE IF EXISTS `ost_thread_entry_merge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_thread_entry_merge` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `thread_entry_id` int(11) unsigned NOT NULL,
  `data` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `thread_entry_id` (`thread_entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_thread_entry_merge`
--

LOCK TABLES `ost_thread_entry_merge` WRITE;
/*!40000 ALTER TABLE `ost_thread_entry_merge` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ost_thread_entry_merge` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_thread_event`
--

DROP TABLE IF EXISTS `ost_thread_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_thread_event` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `thread_id` int(11) unsigned NOT NULL DEFAULT 0,
  `thread_type` char(1) NOT NULL DEFAULT '',
  `event_id` int(11) unsigned DEFAULT NULL,
  `staff_id` int(11) unsigned NOT NULL,
  `team_id` int(11) unsigned NOT NULL,
  `dept_id` int(11) unsigned NOT NULL,
  `topic_id` int(11) unsigned NOT NULL,
  `data` varchar(1024) DEFAULT NULL COMMENT 'Encoded differences',
  `username` varchar(128) NOT NULL DEFAULT 'SYSTEM',
  `uid` int(11) unsigned DEFAULT NULL,
  `uid_type` char(1) NOT NULL DEFAULT 'S',
  `annulled` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `timestamp` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ticket_state` (`thread_id`,`event_id`,`timestamp`),
  KEY `ticket_stats` (`timestamp`,`event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_thread_event`
--

LOCK TABLES `ost_thread_event` WRITE;
/*!40000 ALTER TABLE `ost_thread_event` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_thread_event` VALUES
(1,1,'T',1,0,0,1,1,NULL,'SYSTEM',1,'U',0,'2026-02-19 18:15:04'),
(2,2,'T',1,1,0,2,10,NULL,'ostadmin',1,'S',0,'2026-02-19 23:32:15'),
(3,3,'T',1,1,0,2,1,NULL,'ostadmin',1,'S',0,'2026-02-19 23:41:05'),
(4,3,'T',4,1,0,2,1,'{\"claim\":true}','ostadmin',1,'S',0,'2026-02-19 23:41:05'),
(5,4,'T',1,1,0,3,10,NULL,'ostadmin',1,'S',0,'2026-02-23 16:23:43'),
(6,4,'T',4,1,0,3,10,'{\"claim\":true}','ostadmin',1,'S',0,'2026-02-23 16:23:43'),
(7,5,'T',1,1,0,3,10,NULL,'ostadmin',1,'S',0,'2026-02-23 18:30:16');
/*!40000 ALTER TABLE `ost_thread_event` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_thread_referral`
--

DROP TABLE IF EXISTS `ost_thread_referral`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_thread_referral` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `thread_id` int(11) unsigned NOT NULL,
  `object_id` int(11) unsigned NOT NULL,
  `object_type` char(1) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ref` (`object_id`,`object_type`,`thread_id`),
  KEY `thread_id` (`thread_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_thread_referral`
--

LOCK TABLES `ost_thread_referral` WRITE;
/*!40000 ALTER TABLE `ost_thread_referral` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ost_thread_referral` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_ticket`
--

DROP TABLE IF EXISTS `ost_ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_ticket` (
  `ticket_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_pid` int(11) unsigned DEFAULT NULL,
  `number` varchar(20) DEFAULT NULL,
  `user_id` int(11) unsigned NOT NULL DEFAULT 0,
  `user_email_id` int(11) unsigned NOT NULL DEFAULT 0,
  `status_id` int(10) unsigned NOT NULL DEFAULT 0,
  `dept_id` int(10) unsigned NOT NULL DEFAULT 0,
  `sla_id` int(10) unsigned NOT NULL DEFAULT 0,
  `topic_id` int(10) unsigned NOT NULL DEFAULT 0,
  `staff_id` int(10) unsigned NOT NULL DEFAULT 0,
  `team_id` int(10) unsigned NOT NULL DEFAULT 0,
  `email_id` int(11) unsigned NOT NULL DEFAULT 0,
  `lock_id` int(11) unsigned NOT NULL DEFAULT 0,
  `flags` int(10) unsigned NOT NULL DEFAULT 0,
  `sort` int(11) unsigned NOT NULL DEFAULT 0,
  `ip_address` varchar(64) NOT NULL DEFAULT '',
  `source` enum('Web','Email','Phone','API','Other') NOT NULL DEFAULT 'Other',
  `source_extra` varchar(40) DEFAULT NULL,
  `isoverdue` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `isanswered` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `duedate` datetime DEFAULT NULL,
  `est_duedate` datetime DEFAULT NULL,
  `reopened` datetime DEFAULT NULL,
  `closed` datetime DEFAULT NULL,
  `lastupdate` datetime DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`ticket_id`),
  KEY `user_id` (`user_id`),
  KEY `dept_id` (`dept_id`),
  KEY `staff_id` (`staff_id`),
  KEY `team_id` (`team_id`),
  KEY `status_id` (`status_id`),
  KEY `created` (`created`),
  KEY `closed` (`closed`),
  KEY `duedate` (`duedate`),
  KEY `topic_id` (`topic_id`),
  KEY `sla_id` (`sla_id`),
  KEY `ticket_pid` (`ticket_pid`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_ticket`
--

LOCK TABLES `ost_ticket` WRITE;
/*!40000 ALTER TABLE `ost_ticket` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_ticket` VALUES
(1,NULL,'465837',1,0,1,1,1,1,0,0,0,0,0,0,'127.0.0.1','Web',NULL,0,0,NULL,'2026-02-24 08:00:00',NULL,NULL,'2026-02-19 18:15:04','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(2,NULL,'596870',2,0,1,2,1,10,0,0,0,1,0,0,'192.168.194.181','Email',NULL,0,0,NULL,'2026-02-24 08:00:00',NULL,NULL,'2026-02-19 23:32:15','2026-02-19 23:32:15','2026-02-19 23:32:34'),
(3,NULL,'175026',2,0,1,2,1,1,1,0,0,0,0,0,'192.168.194.181','Email',NULL,0,1,NULL,'2026-02-24 08:00:00',NULL,NULL,'2026-02-19 23:41:05','2026-02-19 23:41:05','2026-02-19 23:41:05'),
(4,NULL,'612485',3,0,1,3,1,10,1,0,0,0,0,0,'192.168.194.181','Email',NULL,0,0,NULL,'2026-02-25 16:23:43',NULL,NULL,'2026-02-23 16:23:43','2026-02-23 16:23:43','2026-02-23 16:23:43'),
(5,NULL,'771753',2,0,1,3,1,10,0,0,0,0,0,0,'::1','Phone',NULL,0,0,NULL,'2026-02-26 08:00:00',NULL,NULL,'2026-02-23 18:30:16','2026-02-23 18:30:16','2026-02-23 18:30:16');
/*!40000 ALTER TABLE `ost_ticket` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_ticket__cdata`
--

DROP TABLE IF EXISTS `ost_ticket__cdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_ticket__cdata` (
  `ticket_id` int(11) unsigned NOT NULL,
  `subject` mediumtext DEFAULT NULL,
  `priority` mediumtext DEFAULT NULL,
  PRIMARY KEY (`ticket_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_ticket__cdata`
--

LOCK TABLES `ost_ticket__cdata` WRITE;
/*!40000 ALTER TABLE `ost_ticket__cdata` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_ticket__cdata` VALUES
(1,'osTicket Installed!',''),
(2,'Login issue','1'),
(3,'ES GEHT NICHT','2'),
(4,'SSO ERROR','4'),
(5,'Screenshot error','2');
/*!40000 ALTER TABLE `ost_ticket__cdata` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_ticket_priority`
--

DROP TABLE IF EXISTS `ost_ticket_priority`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_ticket_priority` (
  `priority_id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `priority` varchar(60) NOT NULL DEFAULT '',
  `priority_desc` varchar(30) NOT NULL DEFAULT '',
  `priority_color` varchar(7) NOT NULL DEFAULT '',
  `priority_urgency` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `ispublic` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`priority_id`),
  UNIQUE KEY `priority` (`priority`),
  KEY `priority_urgency` (`priority_urgency`),
  KEY `ispublic` (`ispublic`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_ticket_priority`
--

LOCK TABLES `ost_ticket_priority` WRITE;
/*!40000 ALTER TABLE `ost_ticket_priority` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_ticket_priority` VALUES
(1,'low','Low','#DDFFDD',4,1),
(2,'normal','Normal','#FFFFF0',3,1),
(3,'high','High','#FEE7E7',2,1),
(4,'emergency','Emergency','#FEE7E7',1,1);
/*!40000 ALTER TABLE `ost_ticket_priority` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_ticket_status`
--

DROP TABLE IF EXISTS `ost_ticket_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_ticket_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `state` varchar(16) DEFAULT NULL,
  `mode` int(11) unsigned NOT NULL DEFAULT 0,
  `flags` int(11) unsigned NOT NULL DEFAULT 0,
  `sort` int(11) unsigned NOT NULL DEFAULT 0,
  `properties` text NOT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `state` (`state`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_ticket_status`
--

LOCK TABLES `ost_ticket_status` WRITE;
/*!40000 ALTER TABLE `ost_ticket_status` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_ticket_status` VALUES
(1,'Open','open',3,0,1,'{\"description\":\"Open tickets.\"}','2026-02-19 18:15:04','0000-00-00 00:00:00'),
(2,'Resolved','closed',1,0,2,'{\"allowreopen\":true,\"reopenstatus\":0,\"description\":\"Resolved tickets\"}','2026-02-19 18:15:04','0000-00-00 00:00:00'),
(3,'Closed','closed',3,0,3,'{\"allowreopen\":true,\"reopenstatus\":0,\"description\":\"Closed tickets. Tickets will still be accessible on client and staff panels.\"}','2026-02-19 18:15:04','0000-00-00 00:00:00'),
(4,'Archived','archived',3,0,4,'{\"description\":\"Tickets only adminstratively available but no longer accessible on ticket queues and client panel.\"}','2026-02-19 18:15:04','0000-00-00 00:00:00'),
(5,'Deleted','deleted',3,0,5,'{\"description\":\"Tickets queued for deletion. Not accessible on ticket queues.\"}','2026-02-19 18:15:04','0000-00-00 00:00:00');
/*!40000 ALTER TABLE `ost_ticket_status` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_translation`
--

DROP TABLE IF EXISTS `ost_translation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_translation` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `object_hash` char(16) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `type` enum('phrase','article','override') DEFAULT NULL,
  `flags` int(10) unsigned NOT NULL DEFAULT 0,
  `revision` int(11) unsigned DEFAULT NULL,
  `agent_id` int(10) unsigned NOT NULL DEFAULT 0,
  `lang` varchar(16) NOT NULL DEFAULT '',
  `text` mediumtext NOT NULL,
  `source_text` text DEFAULT NULL,
  `updated` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `type` (`type`,`lang`),
  KEY `object_hash` (`object_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_translation`
--

LOCK TABLES `ost_translation` WRITE;
/*!40000 ALTER TABLE `ost_translation` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ost_translation` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_user`
--

DROP TABLE IF EXISTS `ost_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `org_id` int(10) unsigned NOT NULL,
  `default_email_id` int(10) NOT NULL,
  `status` int(11) unsigned NOT NULL DEFAULT 0,
  `name` varchar(128) NOT NULL,
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `org_id` (`org_id`),
  KEY `default_email_id` (`default_email_id`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_user`
--

LOCK TABLES `ost_user` WRITE;
/*!40000 ALTER TABLE `ost_user` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_user` VALUES
(1,1,1,0,'osTicket Team','2026-02-19 18:15:04','2026-02-19 18:15:04'),
(2,0,2,0,'Yannick','2026-02-19 23:31:44','2026-02-19 23:31:44'),
(3,0,3,0,'Yannick','2026-02-23 16:21:15','2026-02-23 16:21:15');
/*!40000 ALTER TABLE `ost_user` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_user__cdata`
--

DROP TABLE IF EXISTS `ost_user__cdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_user__cdata` (
  `user_id` int(11) unsigned NOT NULL,
  `email` mediumtext DEFAULT NULL,
  `name` mediumtext DEFAULT NULL,
  `phone` mediumtext DEFAULT NULL,
  `notes` mediumtext DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_user__cdata`
--

LOCK TABLES `ost_user__cdata` WRITE;
/*!40000 ALTER TABLE `ost_user__cdata` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_user__cdata` VALUES
(2,NULL,NULL,'',''),
(3,NULL,NULL,'','');
/*!40000 ALTER TABLE `ost_user__cdata` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_user_account`
--

DROP TABLE IF EXISTS `ost_user_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_user_account` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `status` int(11) unsigned NOT NULL DEFAULT 0,
  `timezone` varchar(64) DEFAULT NULL,
  `lang` varchar(16) DEFAULT NULL,
  `username` varchar(64) DEFAULT NULL,
  `passwd` varchar(128) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `backend` varchar(32) DEFAULT NULL,
  `extra` text DEFAULT NULL,
  `registered` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_user_account`
--

LOCK TABLES `ost_user_account` WRITE;
/*!40000 ALTER TABLE `ost_user_account` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ost_user_account` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ost_user_email`
--

DROP TABLE IF EXISTS `ost_user_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ost_user_email` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `flags` int(10) unsigned NOT NULL DEFAULT 0,
  `address` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `address` (`address`),
  KEY `user_email_lookup` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ost_user_email`
--

LOCK TABLES `ost_user_email` WRITE;
/*!40000 ALTER TABLE `ost_user_email` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `ost_user_email` VALUES
(1,1,0,'feedback@osticket.com'),
(2,2,0,'yannick.beck@test.de'),
(3,3,0,'Yannick@test.de');
/*!40000 ALTER TABLE `ost_user_email` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-02-23 19:16:23
