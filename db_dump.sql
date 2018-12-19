-- MySQL dump 10.13  Distrib 5.7.24, for Linux (x86_64)
--
-- Host: localhost    Database: cmfive
-- ------------------------------------------------------
-- Server version	5.7.24-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `attachment`
--

DROP TABLE IF EXISTS `attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attachment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `parent_table` varchar(255) NOT NULL,
  `parent_id` bigint(20) NOT NULL,
  `modifier_user_id` bigint(20) DEFAULT NULL,
  `filename` varchar(255) NOT NULL,
  `mimetype` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `fullpath` text NOT NULL,
  `type_code` varchar(255) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `adapter` varchar(255) NOT NULL DEFAULT 'local',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `parent_id` (`parent_id`),
  KEY `modifier_user_id` (`modifier_user_id`),
  KEY `parent_table` (`parent_table`),
  KEY `adapter` (`adapter`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attachment`
--

LOCK TABLES `attachment` WRITE;
/*!40000 ALTER TABLE `attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attachment_type`
--

DROP TABLE IF EXISTS `attachment_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attachment_type` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `table_name` varchar(255) NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attachment_type`
--

LOCK TABLES `attachment_type` WRITE;
/*!40000 ALTER TABLE `attachment_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `attachment_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit`
--

DROP TABLE IF EXISTS `audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `submodule` text,
  `message` text,
  `module` varchar(128) DEFAULT NULL,
  `action` varchar(128) DEFAULT NULL,
  `path` varchar(1024) DEFAULT NULL,
  `ip` varchar(128) DEFAULT NULL,
  `db_class` varchar(128) DEFAULT NULL,
  `db_action` varchar(128) DEFAULT NULL,
  `db_id` bigint(20) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=247 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit`
--

LOCK TABLES `audit` WRITE;
/*!40000 ALTER TABLE `audit` DISABLE KEYS */;
INSERT INTO `audit` VALUES (1,NULL,NULL,NULL,NULL,'','','Migration','insert',1,'2018-12-20 10:43:31',NULL),(2,NULL,NULL,NULL,NULL,'','','Migration','insert',2,'2018-12-20 10:43:31',NULL),(3,NULL,NULL,NULL,NULL,'','','Migration','insert',3,'2018-12-20 10:43:31',NULL),(4,NULL,NULL,NULL,NULL,'','','Migration','insert',4,'2018-12-20 10:43:31',NULL),(5,NULL,NULL,NULL,NULL,'','','Migration','insert',5,'2018-12-20 10:43:31',NULL),(6,NULL,NULL,NULL,NULL,'','','Migration','insert',6,'2018-12-20 10:43:31',NULL),(7,NULL,NULL,NULL,NULL,'','','Migration','insert',7,'2018-12-20 10:43:32',NULL),(8,NULL,NULL,NULL,NULL,'','','Migration','insert',8,'2018-12-20 10:43:32',NULL),(9,NULL,NULL,NULL,NULL,'','','Migration','insert',9,'2018-12-20 10:43:32',NULL),(10,NULL,NULL,NULL,NULL,'','','Migration','insert',10,'2018-12-20 10:43:32',NULL),(11,NULL,NULL,NULL,NULL,'','','Migration','insert',11,'2018-12-20 10:43:32',NULL),(12,NULL,NULL,NULL,NULL,'','','Migration','insert',12,'2018-12-20 10:43:32',NULL),(13,NULL,NULL,NULL,NULL,'','','Migration','insert',13,'2018-12-20 10:43:32',NULL),(14,NULL,NULL,NULL,NULL,'','','Migration','insert',14,'2018-12-20 10:43:33',NULL),(15,NULL,NULL,NULL,NULL,'','','Migration','insert',15,'2018-12-20 10:43:33',NULL),(16,NULL,NULL,NULL,NULL,'','','Migration','insert',16,'2018-12-20 10:43:33',NULL),(17,NULL,NULL,NULL,NULL,'','','Migration','insert',17,'2018-12-20 10:43:33',NULL),(18,NULL,NULL,NULL,NULL,'','','Migration','insert',18,'2018-12-20 10:43:33',NULL),(19,NULL,NULL,NULL,NULL,'','','Migration','insert',19,'2018-12-20 10:43:33',NULL),(20,NULL,NULL,NULL,NULL,'','','Migration','insert',20,'2018-12-20 10:43:33',NULL),(21,NULL,NULL,NULL,NULL,'','','Migration','insert',21,'2018-12-20 10:43:33',NULL),(22,NULL,NULL,NULL,NULL,'','','Migration','insert',22,'2018-12-20 10:43:34',NULL),(23,NULL,NULL,NULL,NULL,'','','Migration','insert',23,'2018-12-20 10:43:34',NULL),(24,NULL,NULL,NULL,NULL,'','','Migration','insert',24,'2018-12-20 10:43:34',NULL),(25,NULL,NULL,NULL,NULL,'','','Migration','insert',25,'2018-12-20 10:43:34',NULL),(26,NULL,NULL,NULL,NULL,'','','Migration','insert',26,'2018-12-20 10:43:34',NULL),(27,NULL,NULL,NULL,NULL,'','','Migration','insert',27,'2018-12-20 10:43:34',NULL),(28,NULL,NULL,NULL,NULL,'','','Migration','insert',28,'2018-12-20 10:43:34',NULL),(29,NULL,NULL,NULL,NULL,'','','Migration','insert',29,'2018-12-20 10:43:35',NULL),(30,NULL,NULL,NULL,NULL,'','','Migration','insert',30,'2018-12-20 10:43:35',NULL),(31,NULL,NULL,NULL,NULL,'','','Migration','insert',31,'2018-12-20 10:43:35',NULL),(32,NULL,NULL,NULL,NULL,'','','Migration','insert',32,'2018-12-20 10:43:35',NULL),(33,NULL,NULL,NULL,NULL,'','','Migration','insert',33,'2018-12-20 10:43:35',NULL),(34,NULL,NULL,NULL,NULL,'','','Migration','insert',34,'2018-12-20 10:43:35',NULL),(35,NULL,NULL,NULL,NULL,'','','Migration','insert',35,'2018-12-20 10:43:35',NULL),(36,NULL,NULL,NULL,NULL,'','','Migration','insert',36,'2018-12-20 10:43:35',NULL),(37,NULL,NULL,NULL,NULL,'','','Migration','insert',37,'2018-12-20 10:43:35',NULL),(38,NULL,NULL,NULL,NULL,'','','Migration','insert',38,'2018-12-20 10:43:35',NULL),(39,NULL,NULL,NULL,NULL,'','','Migration','insert',39,'2018-12-20 10:43:36',NULL),(40,NULL,NULL,NULL,NULL,'','','Migration','insert',40,'2018-12-20 10:43:36',NULL),(41,NULL,NULL,NULL,NULL,'','','Migration','insert',41,'2018-12-20 10:43:36',NULL),(42,NULL,NULL,NULL,NULL,'','','Migration','insert',42,'2018-12-20 10:43:36',NULL),(43,NULL,NULL,NULL,NULL,'','','Migration','insert',43,'2018-12-20 10:43:36',NULL),(44,NULL,NULL,NULL,NULL,'','','Migration','insert',44,'2018-12-20 10:43:36',NULL),(45,NULL,NULL,NULL,NULL,'','','Migration','insert',45,'2018-12-20 10:43:37',NULL),(46,NULL,NULL,NULL,NULL,'','','Migration','insert',46,'2018-12-20 10:43:37',NULL),(47,NULL,NULL,NULL,NULL,'','','Migration','insert',47,'2018-12-20 10:43:37',NULL),(48,NULL,NULL,NULL,NULL,'','','Migration','insert',48,'2018-12-20 10:43:37',NULL),(49,NULL,NULL,NULL,NULL,'','','Migration','insert',49,'2018-12-20 10:43:37',NULL),(50,NULL,NULL,NULL,NULL,'','','Migration','insert',50,'2018-12-20 10:43:37',NULL),(51,NULL,NULL,NULL,NULL,'','','Migration','insert',51,'2018-12-20 10:43:37',NULL),(52,NULL,NULL,NULL,NULL,'','','Migration','insert',52,'2018-12-20 10:43:37',NULL),(53,NULL,NULL,NULL,NULL,'','','Migration','insert',53,'2018-12-20 10:43:37',NULL),(54,NULL,NULL,NULL,NULL,'','','Migration','insert',54,'2018-12-20 10:43:37',NULL),(55,NULL,NULL,NULL,NULL,'','','Migration','insert',55,'2018-12-20 10:43:38',NULL),(56,NULL,NULL,NULL,NULL,'','','Migration','insert',56,'2018-12-20 10:43:38',NULL),(57,NULL,NULL,NULL,NULL,'','','Migration','insert',57,'2018-12-20 10:43:38',NULL),(58,NULL,NULL,NULL,NULL,'','','Lookup','insert',1,'2018-12-20 10:43:38',NULL),(59,NULL,NULL,NULL,NULL,'','','Lookup','insert',2,'2018-12-20 10:43:38',NULL),(60,NULL,NULL,NULL,NULL,'','','Lookup','insert',3,'2018-12-20 10:43:38',NULL),(61,NULL,NULL,NULL,NULL,'','','Lookup','insert',4,'2018-12-20 10:43:38',NULL),(62,NULL,NULL,NULL,NULL,'','','Lookup','insert',5,'2018-12-20 10:43:38',NULL),(63,NULL,NULL,NULL,NULL,'','','MigrationSeed','insert',1,'2018-12-20 10:43:38',NULL),(64,NULL,NULL,NULL,NULL,'','','Report','insert',1,'2018-12-20 10:43:38',NULL),(65,NULL,NULL,NULL,NULL,'','','ReportMember','insert',1,'2018-12-20 10:43:38',NULL),(66,NULL,NULL,NULL,NULL,'','','MigrationSeed','insert',2,'2018-12-20 10:43:38',NULL),(67,NULL,NULL,NULL,NULL,'','','Template','insert',1,'2018-12-20 10:43:38',NULL),(68,NULL,NULL,NULL,NULL,'','','MigrationSeed','insert',3,'2018-12-20 10:43:38',NULL),(69,NULL,NULL,'auth','login','/auth/login','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:39',NULL),(70,NULL,NULL,'auth','login','/auth/login','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:40',NULL),(71,NULL,NULL,'main','index','/main/index','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:40',1),(72,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:41',1),(73,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:42',1),(74,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:42',1),(75,NULL,NULL,'admin','index','/admin','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:43',1),(76,NULL,NULL,'admin','users','/admin/users','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:44',1),(77,NULL,NULL,'admin','useradd','/admin/useradd/box?isbox=1','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:44',1),(78,NULL,NULL,'admin','useradd','/admin/useradd','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:46',1),(79,NULL,NULL,'admin','useradd','/admin/useradd','127.0.0.1','Contact','insert',2,'2018-12-20 10:43:46',1),(80,NULL,NULL,'admin','useradd','/admin/useradd','127.0.0.1','User','insert',2,'2018-12-20 10:43:46',1),(81,NULL,NULL,'admin','useradd','/admin/useradd','127.0.0.1','User','update',2,'2018-12-20 10:43:46',1),(82,NULL,NULL,'admin','useradd','/admin/useradd','127.0.0.1','User','update',2,'2018-12-20 10:43:46',1),(83,NULL,NULL,'admin','useradd','/admin/useradd','127.0.0.1','UserRole','insert',1,'2018-12-20 10:43:46',1),(84,NULL,NULL,'admin','useradd','/admin/useradd','127.0.0.1','UserRole','insert',2,'2018-12-20 10:43:46',1),(85,NULL,NULL,'admin','useradd','/admin/useradd','127.0.0.1','Inbox','insert',1,'2018-12-20 10:43:47',1),(86,NULL,NULL,'admin','users','/admin/users','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:47',1),(87,NULL,NULL,'auth','logout','/auth/logout','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:47',1),(88,NULL,NULL,'auth','login','/auth/login','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:47',NULL),(89,NULL,NULL,'auth','login','/auth/login','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:48',NULL),(90,NULL,NULL,'auth','login','/auth/login','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:48',NULL),(91,NULL,NULL,'main','index','/main/index','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:48',2),(92,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:49',2),(93,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:49',2),(94,NULL,NULL,'auth','logout','/auth/logout','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:50',2),(95,NULL,NULL,'auth','login','/auth/login','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:50',NULL),(96,NULL,NULL,'auth','login','/auth/login','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:50',NULL),(97,NULL,NULL,'auth','login','/auth/login','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:50',NULL),(98,NULL,NULL,'main','index','/main/index','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:50',1),(99,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:51',1),(100,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:51',1),(101,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:52',1),(102,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:53',1),(103,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1','Inbox','insert',2,'2018-12-20 10:43:53',1),(104,NULL,NULL,'inbox','index','/inbox/index','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:53',1),(105,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:54',1),(106,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:54',1),(107,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:55',1),(108,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:56',1),(109,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1','Inbox','insert',3,'2018-12-20 10:43:56',1),(110,NULL,NULL,'inbox','index','/inbox/index','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:56',1),(111,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:56',1),(112,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:57',1),(113,NULL,NULL,'inbox','view','/inbox/view/new/3','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:57',1),(114,NULL,NULL,'inbox','view','/inbox/view/new/3','127.0.0.1','Inbox','update',3,'2018-12-20 10:43:57',1),(115,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:58',1),(116,NULL,NULL,'inbox','read','/inbox/read','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:58',1),(117,NULL,NULL,'inbox','archive','/inbox/archive/read/3','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:59',1),(118,NULL,NULL,'inbox','archive','/inbox/archive/read/3','127.0.0.1','Inbox','update',3,'2018-12-20 10:43:59',1),(119,NULL,NULL,'inbox','read','/inbox/read','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:59',1),(120,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:43:59',1),(121,NULL,NULL,'inbox','showarchive','/inbox/showarchive','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:00',1),(122,NULL,NULL,'inbox','delete','/inbox/delete/showarchive/3','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:01',1),(123,NULL,NULL,'inbox','delete','/inbox/delete/showarchive/3','127.0.0.1','Inbox','delete',3,'2018-12-20 10:44:01',1),(124,NULL,NULL,'inbox','delete','/inbox/delete/showarchive/3','127.0.0.1','Inbox','update',3,'2018-12-20 10:44:01',1),(125,NULL,NULL,'inbox','showarchive','/inbox/showarchive','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:01',1),(126,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:01',1),(127,NULL,NULL,'inbox','trash','/inbox/trash','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:02',1),(128,NULL,NULL,'inbox','deleteforever','/inbox/deleteforever/3','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:02',1),(129,NULL,NULL,'inbox','deleteforever','/inbox/deleteforever/3','127.0.0.1','Inbox','update',3,'2018-12-20 10:44:02',1),(130,NULL,NULL,'inbox','trash','/inbox/trash','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:02',1),(131,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:03',1),(132,NULL,NULL,'inbox','trash','/inbox/trash','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:03',1),(133,NULL,NULL,'admin','index','/admin','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:04',1),(134,NULL,NULL,'admin','users','/admin/users','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:04',1),(135,NULL,NULL,'admin','useradd','/admin/useradd/box?isbox=1','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:04',1),(136,NULL,NULL,'admin','useradd','/admin/useradd','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:06',1),(137,NULL,NULL,'admin','useradd','/admin/useradd','127.0.0.1','Contact','insert',3,'2018-12-20 10:44:06',1),(138,NULL,NULL,'admin','useradd','/admin/useradd','127.0.0.1','User','insert',3,'2018-12-20 10:44:06',1),(139,NULL,NULL,'admin','useradd','/admin/useradd','127.0.0.1','User','update',3,'2018-12-20 10:44:06',1),(140,NULL,NULL,'admin','useradd','/admin/useradd','127.0.0.1','User','update',3,'2018-12-20 10:44:06',1),(141,NULL,NULL,'admin','useradd','/admin/useradd','127.0.0.1','UserRole','insert',3,'2018-12-20 10:44:07',1),(142,NULL,NULL,'admin','useradd','/admin/useradd','127.0.0.1','UserRole','insert',4,'2018-12-20 10:44:07',1),(143,NULL,NULL,'admin','useradd','/admin/useradd','127.0.0.1','UserRole','insert',5,'2018-12-20 10:44:07',1),(144,NULL,NULL,'admin','useradd','/admin/useradd','127.0.0.1','Inbox','insert',4,'2018-12-20 10:44:07',1),(145,NULL,NULL,'admin','users','/admin/users','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:07',1),(146,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:07',1),(147,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:08',1),(148,NULL,NULL,'auth','logout','/auth/logout','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:08',1),(149,NULL,NULL,'auth','login','/auth/login','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:08',NULL),(150,NULL,NULL,'auth','login','/auth/login','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:09',NULL),(151,NULL,NULL,'auth','login','/auth/login','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:09',NULL),(152,NULL,NULL,'main','index','/main/index','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:09',3),(153,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:10',3),(154,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:10',3),(155,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:10',3),(156,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:12',3),(157,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1','Inbox','insert',5,'2018-12-20 10:44:12',3),(158,NULL,NULL,'inbox','index','/inbox/index','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:12',3),(159,NULL,NULL,'auth','logout','/auth/logout','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:12',3),(160,NULL,NULL,'auth','login','/auth/login','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:12',NULL),(161,NULL,NULL,'auth','login','/auth/login','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:12',NULL),(162,NULL,NULL,'auth','login','/auth/login','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:13',NULL),(163,NULL,NULL,'main','index','/main/index','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:13',1),(164,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:13',1),(165,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:14',1),(166,NULL,NULL,'inbox','view','/inbox/view/new/5','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:14',1),(167,NULL,NULL,'inbox','view','/inbox/view/new/5','127.0.0.1','Inbox','update',5,'2018-12-20 10:44:14',1),(168,NULL,NULL,'inbox','send','/inbox/send/5','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:15',1),(169,NULL,NULL,'inbox','send','/inbox/send/5','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:16',1),(170,NULL,NULL,'inbox','send','/inbox/send/5','127.0.0.1','Inbox','insert',6,'2018-12-20 10:44:16',1),(171,NULL,NULL,'inbox','send','/inbox/send/5','127.0.0.1','Inbox','update',5,'2018-12-20 10:44:16',1),(172,NULL,NULL,'inbox','index','/inbox/index','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:16',1),(173,NULL,NULL,'auth','logout','/auth/logout','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:16',1),(174,NULL,NULL,'auth','login','/auth/login','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:16',NULL),(175,NULL,NULL,'auth','login','/auth/login','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:17',NULL),(176,NULL,NULL,'auth','login','/auth/login','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:17',NULL),(177,NULL,NULL,'main','index','/main/index','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:17',3),(178,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:18',3),(179,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:18',3),(180,NULL,NULL,'auth','logout','/auth/logout','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:19',3),(181,NULL,NULL,'auth','login','/auth/login','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:19',NULL),(182,NULL,NULL,'auth','login','/auth/login','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:19',NULL),(183,NULL,NULL,'auth','login','/auth/login','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:19',NULL),(184,NULL,NULL,'main','index','/main/index','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:20',1),(185,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:20',1),(186,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:21',1),(187,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:21',1),(188,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:22',1),(189,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1','Inbox','insert',7,'2018-12-20 10:44:22',1),(190,NULL,NULL,'inbox','index','/inbox/index','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:22',1),(191,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:23',1),(192,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:23',1),(193,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:23',1),(194,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:24',1),(195,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1','Inbox','insert',8,'2018-12-20 10:44:25',1),(196,NULL,NULL,'inbox','index','/inbox/index','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:25',1),(197,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:25',1),(198,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:26',1),(199,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:26',1),(200,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:27',1),(201,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1','Inbox','insert',9,'2018-12-20 10:44:27',1),(202,NULL,NULL,'inbox','index','/inbox/index','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:27',1),(203,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:28',1),(204,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:28',1),(205,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:29',1),(206,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:30',1),(207,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1','Inbox','insert',10,'2018-12-20 10:44:30',1),(208,NULL,NULL,'inbox','index','/inbox/index','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:30',1),(209,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:31',1),(210,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:31',1),(211,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:32',1),(212,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:33',1),(213,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1','Inbox','insert',11,'2018-12-20 10:44:33',1),(214,NULL,NULL,'inbox','index','/inbox/index','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:33',1),(215,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:33',1),(216,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:34',1),(217,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:34',1),(218,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:35',1),(219,NULL,NULL,'inbox','send','/inbox/send','127.0.0.1','Inbox','insert',12,'2018-12-20 10:44:36',1),(220,NULL,NULL,'inbox','index','/inbox/index','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:36',1),(221,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:36',1),(222,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:37',1),(223,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:38',1),(224,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:38',1),(225,NULL,NULL,'inbox','archive','/inbox/archive/index/7,9','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:39',1),(226,NULL,NULL,'inbox','archive','/inbox/archive/index/7,9','127.0.0.1','Inbox','update',7,'2018-12-20 10:44:39',1),(227,NULL,NULL,'inbox','archive','/inbox/archive/index/7,9','127.0.0.1','Inbox','update',9,'2018-12-20 10:44:39',1),(228,NULL,NULL,'inbox','index','/inbox/index','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:39',1),(229,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:39',1),(230,NULL,NULL,'inbox','showarchive','/inbox/showarchive','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:40',1),(231,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:40',1),(232,NULL,NULL,'inbox','showarchive','/inbox/showarchive','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:41',1),(233,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:41',1),(234,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:42',1),(235,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:43',1),(236,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:43',1),(237,NULL,NULL,'inbox','delete','/inbox/delete/index/8,10','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:44',1),(238,NULL,NULL,'inbox','delete','/inbox/delete/index/8,10','127.0.0.1','Inbox','delete',8,'2018-12-20 10:44:44',1),(239,NULL,NULL,'inbox','delete','/inbox/delete/index/8,10','127.0.0.1','Inbox','update',8,'2018-12-20 10:44:44',1),(240,NULL,NULL,'inbox','delete','/inbox/delete/index/8,10','127.0.0.1','Inbox','delete',10,'2018-12-20 10:44:44',1),(241,NULL,NULL,'inbox','delete','/inbox/delete/index/8,10','127.0.0.1','Inbox','update',10,'2018-12-20 10:44:44',1),(242,NULL,NULL,'inbox','index','/inbox/index','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:44',1),(243,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:44',1),(244,NULL,NULL,'inbox','trash','/inbox/trash','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:45',1),(245,NULL,NULL,'inbox','index','/inbox','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:45',1),(246,NULL,NULL,'inbox','trash','/inbox/trash','127.0.0.1',NULL,NULL,NULL,'2018-12-20 10:44:46',1);
/*!40000 ALTER TABLE `audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channel`
--

DROP TABLE IF EXISTS `channel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `channel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `name` varchar(255) DEFAULT NULL,
  `notify_user_email` varchar(255) DEFAULT NULL,
  `notify_user_id` bigint(20) DEFAULT NULL,
  `do_processing` tinyint(1) NOT NULL DEFAULT '1',
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `is_active` (`is_active`),
  KEY `notify_user_id` (`notify_user_id`),
  KEY `do_processing` (`do_processing`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel`
--

LOCK TABLES `channel` WRITE;
/*!40000 ALTER TABLE `channel` DISABLE KEYS */;
/*!40000 ALTER TABLE `channel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channel_email_option`
--

DROP TABLE IF EXISTS `channel_email_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `channel_email_option` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `channel_id` bigint(20) NOT NULL,
  `server` varchar(1024) NOT NULL,
  `s_username` varchar(512) DEFAULT NULL,
  `s_password` varchar(512) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `use_auth` tinyint(1) NOT NULL DEFAULT '1',
  `folder` varchar(255) DEFAULT NULL,
  `protocol` varchar(255) DEFAULT NULL,
  `to_filter` varchar(255) DEFAULT NULL,
  `from_filter` varchar(255) DEFAULT NULL,
  `subject_filter` varchar(255) DEFAULT NULL,
  `cc_filter` varchar(255) DEFAULT NULL,
  `body_filter` varchar(255) DEFAULT NULL,
  `post_read_action` varchar(255) DEFAULT NULL,
  `post_read_parameter` varchar(255) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `verify_peer` tinyint(1) NOT NULL DEFAULT '1',
  `allow_self_signed` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `channel_id` (`channel_id`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel_email_option`
--

LOCK TABLES `channel_email_option` WRITE;
/*!40000 ALTER TABLE `channel_email_option` DISABLE KEYS */;
/*!40000 ALTER TABLE `channel_email_option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channel_message`
--

DROP TABLE IF EXISTS `channel_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `channel_message` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `channel_id` bigint(20) NOT NULL,
  `message_type` varchar(255) NOT NULL,
  `is_processed` tinyint(1) NOT NULL DEFAULT '1',
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `channel_id` (`channel_id`),
  KEY `is_processed` (`is_processed`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel_message`
--

LOCK TABLES `channel_message` WRITE;
/*!40000 ALTER TABLE `channel_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `channel_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channel_message_status`
--

DROP TABLE IF EXISTS `channel_message_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `channel_message_status` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `message_id` bigint(20) NOT NULL,
  `processor_id` bigint(20) NOT NULL,
  `message` text NOT NULL,
  `is_successful` tinyint(1) NOT NULL DEFAULT '0',
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `message_id` (`message_id`),
  KEY `processor_id` (`processor_id`),
  KEY `is_successful` (`is_successful`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel_message_status`
--

LOCK TABLES `channel_message_status` WRITE;
/*!40000 ALTER TABLE `channel_message_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `channel_message_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channel_processor`
--

DROP TABLE IF EXISTS `channel_processor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `channel_processor` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `channel_id` bigint(20) NOT NULL,
  `class` varchar(255) NOT NULL,
  `module` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `processor_settings` varchar(1024) DEFAULT NULL,
  `settings` varchar(1024) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `channel_id` (`channel_id`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel_processor`
--

LOCK TABLES `channel_processor` WRITE;
/*!40000 ALTER TABLE `channel_processor` DISABLE KEYS */;
/*!40000 ALTER TABLE `channel_processor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channel_web_option`
--

DROP TABLE IF EXISTS `channel_web_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `channel_web_option` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `channel_id` bigint(20) NOT NULL,
  `url` varchar(1024) NOT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `channel_id` (`channel_id`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel_web_option`
--

LOCK TABLES `channel_web_option` WRITE;
/*!40000 ALTER TABLE `channel_web_option` DISABLE KEYS */;
/*!40000 ALTER TABLE `channel_web_option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `obj_table` varchar(200) NOT NULL,
  `obj_id` bigint(20) DEFAULT NULL,
  `comment` text,
  `is_internal` tinyint(1) NOT NULL DEFAULT '0',
  `is_system` tinyint(1) NOT NULL DEFAULT '0',
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `obj_id` (`obj_id`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact`
--

DROP TABLE IF EXISTS `contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contact` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(128) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `othername` varchar(255) DEFAULT NULL,
  `title_lookup_id` bigint(20) DEFAULT NULL,
  `homephone` varchar(64) DEFAULT NULL,
  `workphone` varchar(64) DEFAULT NULL,
  `mobile` varchar(64) DEFAULT NULL,
  `priv_mobile` varchar(64) DEFAULT NULL,
  `fax` varchar(64) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `notes` text,
  `private_to_user_id` bigint(20) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact`
--

LOCK TABLES `contact` WRITE;
/*!40000 ALTER TABLE `contact` DISABLE KEYS */;
INSERT INTO `contact` VALUES (1,'Administrator','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'admin@tripleacs.com',NULL,NULL,'2012-04-27 06:31:52','2012-04-27 06:31:52',NULL,0),(2,'inboxreader','jones',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'fred@jones.com',NULL,NULL,'2018-12-20 10:43:46','2018-12-20 10:43:46',1,0),(3,'fred','jones',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'fred@jones.com',NULL,NULL,'2018-12-20 10:44:06','2018-12-20 10:44:06',1,0);
/*!40000 ALTER TABLE `contact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorite`
--

DROP TABLE IF EXISTS `favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `favorite` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `object_class` varchar(255) NOT NULL,
  `object_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `object_id` (`object_id`),
  KEY `user_id` (`user_id`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite`
--

LOCK TABLES `favorite` WRITE;
/*!40000 ALTER TABLE `favorite` DISABLE KEYS */;
/*!40000 ALTER TABLE `favorite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form`
--

DROP TABLE IF EXISTS `form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(256) NOT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `header_template` longtext,
  `row_template` longtext,
  `summary_template` longtext,
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form`
--

LOCK TABLES `form` WRITE;
/*!40000 ALTER TABLE `form` DISABLE KEYS */;
/*!40000 ALTER TABLE `form` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_application`
--

DROP TABLE IF EXISTS `form_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_application` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_application`
--

LOCK TABLES `form_application` WRITE;
/*!40000 ALTER TABLE `form_application` DISABLE KEYS */;
/*!40000 ALTER TABLE `form_application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_application_mapping`
--

DROP TABLE IF EXISTS `form_application_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_application_mapping` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `form_id` bigint(20) NOT NULL,
  `application_id` bigint(20) NOT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_application_mapping`
--

LOCK TABLES `form_application_mapping` WRITE;
/*!40000 ALTER TABLE `form_application_mapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `form_application_mapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_application_member`
--

DROP TABLE IF EXISTS `form_application_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_application_member` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `application_id` bigint(20) NOT NULL,
  `member_user_id` bigint(20) NOT NULL,
  `role` varchar(255) NOT NULL DEFAULT 'VIEWER',
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_application_member`
--

LOCK TABLES `form_application_member` WRITE;
/*!40000 ALTER TABLE `form_application_member` DISABLE KEYS */;
/*!40000 ALTER TABLE `form_application_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_application_view`
--

DROP TABLE IF EXISTS `form_application_view`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_application_view` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `application_id` bigint(20) NOT NULL,
  `form_id` bigint(20) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `template_id` bigint(20) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_application_view`
--

LOCK TABLES `form_application_view` WRITE;
/*!40000 ALTER TABLE `form_application_view` DISABLE KEYS */;
/*!40000 ALTER TABLE `form_application_view` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_event`
--

DROP TABLE IF EXISTS `form_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_event` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `form_id` bigint(20) NOT NULL,
  `form_application_id` bigint(20) NOT NULL,
  `event_type` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `class` varchar(255) NOT NULL,
  `module` varchar(255) NOT NULL,
  `processor_settings` varchar(1024) DEFAULT NULL,
  `settings` varchar(1024) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_event`
--

LOCK TABLES `form_event` WRITE;
/*!40000 ALTER TABLE `form_event` DISABLE KEYS */;
/*!40000 ALTER TABLE `form_event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_field`
--

DROP TABLE IF EXISTS `form_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_field` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `form_id` bigint(20) NOT NULL,
  `name` varchar(256) NOT NULL,
  `technical_name` varchar(256) DEFAULT NULL,
  `interface_class` varchar(256) DEFAULT NULL,
  `type` varchar(256) NOT NULL,
  `mask` varchar(1024) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `ordering` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `form_id` (`form_id`),
  KEY `ordering` (`ordering`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_field`
--

LOCK TABLES `form_field` WRITE;
/*!40000 ALTER TABLE `form_field` DISABLE KEYS */;
/*!40000 ALTER TABLE `form_field` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_field_metadata`
--

DROP TABLE IF EXISTS `form_field_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_field_metadata` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `form_field_id` bigint(20) DEFAULT NULL,
  `meta_key` varchar(256) NOT NULL,
  `meta_value` varchar(256) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `form_field_id` (`form_field_id`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_field_metadata`
--

LOCK TABLES `form_field_metadata` WRITE;
/*!40000 ALTER TABLE `form_field_metadata` DISABLE KEYS */;
/*!40000 ALTER TABLE `form_field_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_instance`
--

DROP TABLE IF EXISTS `form_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_instance` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `form_id` bigint(20) NOT NULL,
  `object_class` varchar(256) NOT NULL,
  `object_id` bigint(20) NOT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `form_id` (`form_id`),
  KEY `object_class` (`object_class`),
  KEY `object_id` (`object_id`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_instance`
--

LOCK TABLES `form_instance` WRITE;
/*!40000 ALTER TABLE `form_instance` DISABLE KEYS */;
/*!40000 ALTER TABLE `form_instance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_mapping`
--

DROP TABLE IF EXISTS `form_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_mapping` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `form_id` bigint(20) NOT NULL,
  `object` varchar(256) NOT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `form_id` (`form_id`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_mapping`
--

LOCK TABLES `form_mapping` WRITE;
/*!40000 ALTER TABLE `form_mapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `form_mapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_value`
--

DROP TABLE IF EXISTS `form_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_value` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `form_instance_id` bigint(20) NOT NULL,
  `form_field_id` bigint(20) NOT NULL,
  `value` varchar(1024) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `form_instance_id` (`form_instance_id`),
  KEY `form_field_id` (`form_field_id`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_value`
--

LOCK TABLES `form_value` WRITE;
/*!40000 ALTER TABLE `form_value` DISABLE KEYS */;
/*!40000 ALTER TABLE `form_value` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_user`
--

DROP TABLE IF EXISTS `group_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `role` varchar(32) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `dt_created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`),
  KEY `user_id` (`user_id`),
  KEY `is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_user`
--

LOCK TABLES `group_user` WRITE;
/*!40000 ALTER TABLE `group_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `group_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inbox`
--

DROP TABLE IF EXISTS `inbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inbox` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `sender_id` bigint(20) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `message_id` bigint(20) DEFAULT NULL,
  `dt_read` datetime DEFAULT NULL,
  `is_new` tinyint(1) NOT NULL DEFAULT '1',
  `dt_archived` datetime DEFAULT NULL,
  `is_archived` tinyint(1) NOT NULL DEFAULT '1',
  `parent_message_id` bigint(20) DEFAULT NULL,
  `has_parent` tinyint(1) NOT NULL DEFAULT '0',
  `del_forever` tinyint(1) NOT NULL DEFAULT '0',
  `dt_created` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inbox`
--

LOCK TABLES `inbox` WRITE;
/*!40000 ALTER TABLE `inbox` DISABLE KEYS */;
INSERT INTO `inbox` VALUES (1,1,1,'An account has changed',1,NULL,1,NULL,0,NULL,0,0,'2018-12-20 10:43:47',0),(2,1,1,'test message',2,NULL,1,NULL,0,NULL,0,0,'2018-12-20 10:43:53',0),(3,1,1,'another test message',3,'2018-12-20 10:43:57',0,'2018-12-20 10:43:59',1,NULL,0,1,'2018-12-20 10:43:56',1),(4,1,1,'An account has changed',4,NULL,1,NULL,0,NULL,0,0,'2018-12-20 10:44:07',0),(5,1,3,'test message from fred',5,'2018-12-20 10:44:14',0,NULL,0,NULL,1,0,'2018-12-20 10:44:12',0),(6,3,1,'Re:test message from fred',6,NULL,1,NULL,0,5,0,0,'2018-12-20 10:44:16',0),(7,1,1,'tm1',7,NULL,0,'2018-12-20 10:44:39',1,NULL,0,0,'2018-12-20 10:44:22',0),(8,1,1,'tm2',8,NULL,0,NULL,0,NULL,0,0,'2018-12-20 10:44:25',1),(9,1,1,'tm3',9,NULL,0,'2018-12-20 10:44:39',1,NULL,0,0,'2018-12-20 10:44:27',0),(10,1,1,'tm4',10,NULL,0,NULL,0,NULL,0,0,'2018-12-20 10:44:30',1),(11,1,1,'tm5',11,NULL,1,NULL,0,NULL,0,0,'2018-12-20 10:44:33',0),(12,1,1,'tm6',12,NULL,1,NULL,0,NULL,0,0,'2018-12-20 10:44:36',0);
/*!40000 ALTER TABLE `inbox` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inbox_message`
--

DROP TABLE IF EXISTS `inbox_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inbox_message` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `message` text,
  `digest` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inbox_message`
--

LOCK TABLES `inbox_message` WRITE;
/*!40000 ALTER TABLE `inbox_message` DISABLE KEYS */;
INSERT INTO `inbox_message` VALUES (1,'The following account has been changed:\n','a277761829352afaaaecccf5527c7084f507d0a3'),(2,'<p>content of test message</p>','a86e52c2497b2f8a276893a89e0faa23dcefebce'),(3,'<p>content of another test message</p>','a5f55bccbb44b4ab585cf55f47a063dc13132ccf'),(4,'The following account has been changed:\n','a277761829352afaaaecccf5527c7084f507d0a3'),(5,'<p>content of test message</p>','a86e52c2497b2f8a276893a89e0faa23dcefebce'),(6,'','da39a3ee5e6b4b0d3255bfef95601890afd80709'),(7,'<p>tm1</p>','82c2c2b5e142dd9de0923e27b48b70c0f40dda2d'),(8,'<p>tm2</p>','49fbf8a2fa7e08694c50b209efb80240f2d43a56'),(9,'<p>tm3</p>','eb42a3f70c57ef53f489aea2b03fdf08533ab08b'),(10,'<p>tm4</p>','11de84904b000724b08853a8993ddeac11b512ed'),(11,'<p>tm5</p>','6c7261806e148d9602ceab774a381f17de23c759'),(12,'<p>tm6</p>','06c9fd84a718d661fba7027d5dc6b51c32b59287');
/*!40000 ALTER TABLE `inbox_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lookup`
--

DROP TABLE IF EXISTS `lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lookup` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `weight` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lookup`
--

LOCK TABLES `lookup` WRITE;
/*!40000 ALTER TABLE `lookup` DISABLE KEYS */;
INSERT INTO `lookup` VALUES (1,NULL,'title','mr','Mr',0),(2,NULL,'title','mrs','Mrs',0),(3,NULL,'title','ms','Ms',0),(4,NULL,'YesNo','1','Yes',0),(5,NULL,'YesNo','0','No',0);
/*!40000 ALTER TABLE `lookup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mail_batch`
--

DROP TABLE IF EXISTS `mail_batch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail_batch` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `details` longtext,
  `status` varchar(255) DEFAULT NULL,
  `dt_started` datetime DEFAULT NULL,
  `dt_finished` datetime DEFAULT NULL,
  `user_to_notify` int(11) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `number_sent` int(11) DEFAULT NULL,
  `tag` varchar(255) DEFAULT NULL,
  `is_main_contact` tinyint(1) DEFAULT '0',
  `is_billing_contact` tinyint(1) DEFAULT '0',
  `is_self` tinyint(1) DEFAULT '0',
  `template_id` int(11) DEFAULT NULL,
  `message` longtext,
  `extra_data` varchar(255) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mail_batch`
--

LOCK TABLES `mail_batch` WRITE;
/*!40000 ALTER TABLE `mail_batch` DISABLE KEYS */;
/*!40000 ALTER TABLE `mail_batch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mail_queue`
--

DROP TABLE IF EXISTS `mail_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail_queue` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `to_contact_id` int(11) DEFAULT NULL,
  `batch_id` int(11) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mail_queue`
--

LOCK TABLES `mail_queue` WRITE;
/*!40000 ALTER TABLE `mail_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `mail_queue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migration`
--

DROP TABLE IF EXISTS `migration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migration` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `path` varchar(1024) DEFAULT NULL,
  `classname` varchar(1024) DEFAULT NULL,
  `module` varchar(1024) DEFAULT NULL,
  `batch` int(11) NOT NULL DEFAULT '0',
  `dt_created` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migration`
--

LOCK TABLES `migration` WRITE;
/*!40000 ALTER TABLE `migration` DISABLE KEYS */;
INSERT INTO `migration` VALUES (1,'system/modules/admin/install/migrations/20151030134124-AdminInitialMigration.php','AdminInitialMigration','admin',1,'2018-12-20 10:43:31',1),(2,'system/modules/admin/install/migrations/20170123091600-AdminMigrationSeed.php','AdminMigrationSeed','admin',1,'2018-12-20 10:43:31',1),(3,'system/modules/admin/install/migrations/20151223124824-AdminMigrationBatching.php','AdminMigrationBatching','admin',2,'2018-12-20 10:43:31',NULL),(4,'system/modules/admin/install/migrations/20160803112125-AdminBulkEmails.php','AdminBulkEmails','admin',2,'2018-12-20 10:43:31',NULL),(5,'system/modules/admin/install/migrations/20160831115641-AdminIndexingUpdate.php','AdminIndexingUpdate','admin',2,'2018-12-20 10:43:31',NULL),(6,'system/modules/admin/install/migrations/20170202132659-AdminSetAllCommentsToInternal.php','AdminSetAllCommentsToInternal','admin',2,'2018-12-20 10:43:31',NULL),(7,'system/modules/admin/install/migrations/20170404152100-AdminMysql57Fix.php','AdminMysql57Fix','admin',2,'2018-12-20 10:43:32',NULL),(8,'system/modules/auth/install/migrations/20151113122913-AuthInitialMigration.php','AuthInitialMigration','auth',2,'2018-12-20 10:43:32',NULL),(9,'system/modules/auth/install/migrations/20160831115648-AuthIndexingUpdate.php','AuthIndexingUpdate','auth',2,'2018-12-20 10:43:32',NULL),(10,'system/modules/auth/install/migrations/20170124121700-AuthExternalUser.php','AuthExternalUser','auth',2,'2018-12-20 10:43:32',NULL),(11,'system/modules/auth/install/migrations/20170419115748-AuthMysql57Fix.php','AuthMysql57Fix','auth',2,'2018-12-20 10:43:32',NULL),(12,'system/modules/auth/install/migrations/20170626160400-AuthAddUserLanguage.php','AuthAddUserLanguage','auth',2,'2018-12-20 10:43:32',NULL),(13,'system/modules/auth/install/migrations/20170921115200-AuthAddDefaultToUserLanguage.php','AuthAddDefaultToUserLanguage','auth',2,'2018-12-20 10:43:32',NULL),(14,'system/modules/auth/install/migrations/20171003125308-AuthContactTitles.php','AuthContactTitles','auth',2,'2018-12-20 10:43:32',NULL),(15,'system/modules/channels/install/migrations/20151113122928-ChannelsInitialMigration.php','ChannelsInitialMigration','channels',2,'2018-12-20 10:43:33',NULL),(16,'system/modules/channels/install/migrations/20160203034244-ChannelsWebOption.php','ChannelsWebOption','channels',2,'2018-12-20 10:43:33',NULL),(17,'system/modules/channels/install/migrations/20160831115653-ChannelsIndexingUpdate.php','ChannelsIndexingUpdate','channels',2,'2018-12-20 10:43:33',NULL),(18,'system/modules/channels/install/migrations/20161021154252-ChannelsVerifyPeer.php','ChannelsVerifyPeer','channels',2,'2018-12-20 10:43:33',NULL),(19,'system/modules/favorite/install/migrations/20151113122933-FavoriteInitialMigration.php','FavoriteInitialMigration','favorite',2,'2018-12-20 10:43:33',NULL),(20,'system/modules/favorite/install/migrations/20160831115712-FavoriteIndexingUpdate.php','FavoriteIndexingUpdate','favorite',2,'2018-12-20 10:43:33',NULL),(21,'system/modules/file/install/migrations/20150105101900-FileAdapterMigration.php','FileAdapterMigration','file',2,'2018-12-20 10:43:33',NULL),(22,'system/modules/file/install/migrations/20151113122938-FileInitialMigration.php','FileInitialMigration','file',2,'2018-12-20 10:43:34',NULL),(23,'system/modules/file/install/migrations/20151210142413-FileFixMissingParentId.php','FileFixMissingParentId','file',2,'2018-12-20 10:43:34',NULL),(24,'system/modules/file/install/migrations/20160105101900-FileNewAdapterMigration.php','FileNewAdapterMigration','file',2,'2018-12-20 10:43:34',NULL),(25,'system/modules/file/install/migrations/20160831115717-FileIndexingUpdate.php','FileIndexingUpdate','file',2,'2018-12-20 10:43:34',NULL),(26,'system/modules/form/install/migrations/20160203043421-FormInitialMigration.php','FormInitialMigration','form',2,'2018-12-20 10:43:34',NULL),(27,'system/modules/form/install/migrations/20160204043423-FormAddFormTemplate.php','FormAddFormTemplate','form',2,'2018-12-20 10:43:34',NULL),(28,'system/modules/form/install/migrations/20160218153103-FormOrdering.php','FormOrdering','form',2,'2018-12-20 10:43:34',NULL),(29,'system/modules/form/install/migrations/20160831115722-FormIndexingUpdate.php','FormIndexingUpdate','form',2,'2018-12-20 10:43:35',NULL),(30,'system/modules/form/install/migrations/20170915141141-FormAddApplicationTables.php','FormAddApplicationTables','form',2,'2018-12-20 10:43:35',NULL),(31,'system/modules/form/install/migrations/20170922104422-FormRemoveValueMaskAndType.php','FormRemoveValueMaskAndType','form',2,'2018-12-20 10:43:35',NULL),(32,'system/modules/form/install/migrations/20171103110610-FormMysql57Updates.php','FormMysql57Updates','form',2,'2018-12-20 10:43:35',NULL),(33,'system/modules/form/install/migrations/20180426141537-FormAddFormEvents.php','FormAddFormEvents','form',2,'2018-12-20 10:43:35',NULL),(34,'system/modules/inbox/install/migrations/20151113122946-InboxInitialMigration.php','InboxInitialMigration','inbox',2,'2018-12-20 10:43:35',NULL),(35,'system/modules/main/install/migrations/20151113122953-MainInitialMigration.php','MainInitialMigration','main',2,'2018-12-20 10:43:35',NULL),(36,'system/modules/main/install/migrations/20160831115733-MainIndexingUpdate.php','MainIndexingUpdate','main',2,'2018-12-20 10:43:35',NULL),(37,'system/modules/report/install/migrations/20151113122959-ReportInitialMigration.php','ReportInitialMigration','report',2,'2018-12-20 10:43:35',NULL),(38,'system/modules/report/install/migrations/20160215115309-ReportAutoEmailChanges.php','ReportAutoEmailChanges','report',2,'2018-12-20 10:43:35',NULL),(39,'system/modules/report/install/migrations/20160831115741-ReportIndexingUpdate.php','ReportIndexingUpdate','report',2,'2018-12-20 10:43:36',NULL),(40,'system/modules/report/install/migrations/20170604114343-ReportMysql57Fix.php','ReportMysql57Fix','report',2,'2018-12-20 10:43:36',NULL),(41,'system/modules/search/install/migrations/20151113123007-SearchInitialMigration.php','SearchInitialMigration','search',2,'2018-12-20 10:43:36',NULL),(42,'system/modules/tag/install/migrations/20151113123013-TagInitialMigration.php','TagInitialMigration','tag',2,'2018-12-20 10:43:36',NULL),(43,'system/modules/tag/install/migrations/20170720135300-TagAbstractMigration.php','TagAbstractMigration','tag',2,'2018-12-20 10:43:36',NULL),(44,'system/modules/tag/install/migrations/20170906095900-TagRemoveObsoleteColumns.php','TagRemoveObsoleteColumns','tag',2,'2018-12-20 10:43:36',NULL),(45,'system/modules/task/install/migrations/20151113123020-TaskInitialMigration.php','TaskInitialMigration','task',2,'2018-12-20 10:43:37',NULL),(46,'system/modules/task/install/migrations/20160107131206-TaskAddEffort.php','TaskAddEffort','task',2,'2018-12-20 10:43:37',NULL),(47,'system/modules/task/install/migrations/20160511142253-TaskTaskgroupExtendTitleLength.php','TaskTaskgroupExtendTitleLength','task',2,'2018-12-20 10:43:37',NULL),(48,'system/modules/task/install/migrations/20160718133103-TaskAddPriorityAndTaskType.php','TaskAddPriorityAndTaskType','task',2,'2018-12-20 10:43:37',NULL),(49,'system/modules/task/install/migrations/20160831113402-TaskAddRateLevel.php','TaskAddRateLevel','task',2,'2018-12-20 10:43:37',NULL),(50,'system/modules/task/install/migrations/20160831115825-TaskIndexingUpdate.php','TaskIndexingUpdate','task',2,'2018-12-20 10:43:37',NULL),(51,'system/modules/task/install/migrations/20170131152515-TaskAddSubscriber.php','TaskAddSubscriber','task',2,'2018-12-20 10:43:37',NULL),(52,'system/modules/task/install/migrations/20170330140500-TaskAddDefaultToDtAssigned.php','TaskAddDefaultToDtAssigned','task',2,'2018-12-20 10:43:37',NULL),(53,'system/modules/task/install/migrations/20170406123345-TaskMysql57Fix.php','TaskMysql57Fix','task',2,'2018-12-20 10:43:37',NULL),(54,'system/modules/task/install/migrations/20170711141857-TaskAddAutomaticSubscriptionToTaskGroup.php','TaskAddAutomaticSubscriptionToTaskGroup','task',2,'2018-12-20 10:43:37',NULL),(55,'system/modules/timelog/install/migrations/20151113123025-TimelogInitialMigration.php','TimelogInitialMigration','timelog',2,'2018-12-20 10:43:38',NULL),(56,'system/modules/timelog/install/migrations/20160831115833-TimelogIndexingUpdate.php','TimelogIndexingUpdate','timelog',2,'2018-12-20 10:43:38',NULL),(57,'system/modules/timelog/install/migrations/20170419123950-TimelogMysql57Fix.php','TimelogMysql57Fix','timelog',2,'2018-12-20 10:43:38',NULL);
/*!40000 ALTER TABLE `migration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migration_seed`
--

DROP TABLE IF EXISTS `migration_seed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migration_seed` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migration_seed`
--

LOCK TABLES `migration_seed` WRITE;
/*!40000 ALTER TABLE `migration_seed` DISABLE KEYS */;
INSERT INTO `migration_seed` VALUES (1,'LookupSeeding','2018-12-20 10:43:38','2018-12-20 10:43:38',NULL,NULL,0),(2,'AuditReport','2018-12-20 10:43:38','2018-12-20 10:43:38',NULL,NULL,0),(3,'EmailNotificationTemplate','2018-12-20 10:43:38','2018-12-20 10:43:38',NULL,NULL,0);
/*!40000 ALTER TABLE `migration_seed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `object_history`
--

DROP TABLE IF EXISTS `object_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `object_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `class_name` varchar(255) NOT NULL,
  `object_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `class_name` (`class_name`),
  KEY `object_id` (`object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `object_history`
--

LOCK TABLES `object_history` WRITE;
/*!40000 ALTER TABLE `object_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `object_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `object_history_entry`
--

DROP TABLE IF EXISTS `object_history_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `object_history_entry` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `history_id` bigint(20) NOT NULL,
  `attr_name` varchar(255) DEFAULT NULL,
  `attr_value` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `history_id` (`history_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `object_history_entry`
--

LOCK TABLES `object_history_entry` WRITE;
/*!40000 ALTER TABLE `object_history_entry` DISABLE KEYS */;
/*!40000 ALTER TABLE `object_history_entry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `object_index`
--

DROP TABLE IF EXISTS `object_index`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `object_index` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `class_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `object_id` bigint(20) NOT NULL,
  `content` longtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `class_name` (`class_name`),
  KEY `object_id` (`object_id`),
  FULLTEXT KEY `object_index_content` (`content`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `object_index`
--

LOCK TABLES `object_index` WRITE;
/*!40000 ALTER TABLE `object_index` DISABLE KEYS */;
/*!40000 ALTER TABLE `object_index` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `object_modification`
--

DROP TABLE IF EXISTS `object_modification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `object_modification` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `table_name` varchar(255) NOT NULL,
  `object_id` bigint(20) NOT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `table_name` (`table_name`),
  KEY `object_id` (`object_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `object_modification`
--

LOCK TABLES `object_modification` WRITE;
/*!40000 ALTER TABLE `object_modification` DISABLE KEYS */;
INSERT INTO `object_modification` VALUES (1,'report',1,'2018-12-20 10:43:38','2018-12-20 10:43:38',0,NULL),(2,'user',2,'2018-12-20 10:43:46','2018-12-20 10:43:46',1,1),(3,'user',3,'2018-12-20 10:44:06','2018-12-20 10:44:07',1,1);
/*!40000 ALTER TABLE `object_modification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phinxlog`
--

DROP TABLE IF EXISTS `phinxlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phinxlog` (
  `version` bigint(20) NOT NULL,
  `migration_name` varchar(100) DEFAULT NULL,
  `start_time` timestamp NULL DEFAULT NULL,
  `end_time` timestamp NULL DEFAULT NULL,
  `breakpoint` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phinxlog`
--

LOCK TABLES `phinxlog` WRITE;
/*!40000 ALTER TABLE `phinxlog` DISABLE KEYS */;
/*!40000 ALTER TABLE `phinxlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `printer`
--

DROP TABLE IF EXISTS `printer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `printer` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(512) DEFAULT NULL,
  `server` varchar(512) DEFAULT NULL,
  `port` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `printer`
--

LOCK TABLES `printer` WRITE;
/*!40000 ALTER TABLE `printer` DISABLE KEYS */;
/*!40000 ALTER TABLE `printer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report`
--

DROP TABLE IF EXISTS `report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `report_connection_id` bigint(20) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `module` varchar(255) DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `report_code` text,
  `is_approved` tinyint(1) NOT NULL DEFAULT '1',
  `description` text,
  `sqltype` varchar(255) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `report_connection_id` (`report_connection_id`),
  KEY `is_approved` (`is_approved`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report`
--

LOCK TABLES `report` WRITE;
/*!40000 ALTER TABLE `report` DISABLE KEYS */;
INSERT INTO `report` VALUES (1,NULL,'Audit report','Audit',NULL,'[[dt_from||date||Date From]]\n\n[[dt_to||date||Date To]]\n\n[[user_id||select||User||select u.id as value, concat(c.firstname,\' \',c.lastname) as title from user u, contact c where u.contact_id = c.id order by title]]\n\n[[module||select||Module||select distinct module as value, module as title from audit order by module asc]]\n\n[[action||select||Action||select distinct action as value, concat(module,\'/\',action) as title from audit order by title]]\n\n@@Audit Report||\n\nselect \na.dt_created as Date, \nconcat(c.firstname,\' \',c.lastname) as User,  \na.module as Module,\na.path as Url,\na.db_class as \'Class\',\na.db_action as \'Action\',\na.db_id as \'DB Id\'\n\nfrom audit a\n\nleft join user u on u.id = a.creator_id\nleft join contact c on c.id = u.contact_id\n\nwhere \na.dt_created >= \'{{dt_from}} 00:00:00\' \nand a.dt_created <= \'{{dt_to}} 23:59:59\' \nand (\'{{module}}\' = \'\' or a.module = \'{{module}}\')\nand (\'{{action}}\' = \'\' or a.action = \'{{action}}\') \nand (\'{{user_id}}\' = \'\' or a.creator_id = \'{{user_id}}\')\n\n@@\n',1,'Shows audit information',NULL,0);
/*!40000 ALTER TABLE `report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report_connection`
--

DROP TABLE IF EXISTS `report_connection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report_connection` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `db_driver` varchar(255) DEFAULT NULL,
  `db_host` varchar(255) DEFAULT NULL,
  `db_port` varchar(255) DEFAULT NULL,
  `db_database` varchar(255) DEFAULT NULL,
  `db_file` varchar(255) DEFAULT NULL,
  `s_db_user` varchar(1024) DEFAULT NULL,
  `s_db_password` varchar(1024) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_connection`
--

LOCK TABLES `report_connection` WRITE;
/*!40000 ALTER TABLE `report_connection` DISABLE KEYS */;
/*!40000 ALTER TABLE `report_connection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report_feed`
--

DROP TABLE IF EXISTS `report_feed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report_feed` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `report_id` bigint(20) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `report_key` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `report_id` (`report_id`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_feed`
--

LOCK TABLES `report_feed` WRITE;
/*!40000 ALTER TABLE `report_feed` DISABLE KEYS */;
/*!40000 ALTER TABLE `report_feed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report_member`
--

DROP TABLE IF EXISTS `report_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report_member` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `report_id` bigint(20) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `is_email_recipient` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `report_id` (`report_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_member`
--

LOCK TABLES `report_member` WRITE;
/*!40000 ALTER TABLE `report_member` DISABLE KEYS */;
INSERT INTO `report_member` VALUES (1,1,NULL,'OWNER',0,0);
/*!40000 ALTER TABLE `report_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report_template`
--

DROP TABLE IF EXISTS `report_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report_template` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `report_id` bigint(20) DEFAULT NULL,
  `template_id` bigint(20) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `is_email_template` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `report_id` (`report_id`),
  KEY `template_id` (`template_id`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_template`
--

LOCK TABLES `report_template` WRITE;
/*!40000 ALTER TABLE `report_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `report_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rest_session`
--

DROP TABLE IF EXISTS `rest_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rest_session` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `token` varchar(256) NOT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rest_session`
--

LOCK TABLES `rest_session` WRITE;
/*!40000 ALTER TABLE `rest_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `rest_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `session_id` varchar(100) NOT NULL,
  `session_data` text NOT NULL,
  `expires` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tag` varchar(255) NOT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `is_deleted_2` (`is_deleted`,`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag`
--

LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag_assign`
--

DROP TABLE IF EXISTS `tag_assign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag_assign` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `object_class` varchar(200) DEFAULT NULL,
  `object_id` bigint(20) DEFAULT NULL,
  `tag_id` varchar(255) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `object_class` (`object_class`,`object_id`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag_assign`
--

LOCK TABLES `tag_assign` WRITE;
/*!40000 ALTER TABLE `tag_assign` DISABLE KEYS */;
/*!40000 ALTER TABLE `tag_assign` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task`
--

DROP TABLE IF EXISTS `task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `is_closed` tinyint(1) NOT NULL DEFAULT '0',
  `parent_id` bigint(20) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `task_group_id` bigint(20) NOT NULL,
  `status` varchar(255) NOT NULL,
  `priority` varchar(255) DEFAULT NULL,
  `task_type` varchar(255) DEFAULT NULL,
  `assignee_id` bigint(20) NOT NULL,
  `first_assignee_id` bigint(20) DEFAULT NULL,
  `dt_assigned` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dt_first_assigned` datetime DEFAULT NULL,
  `dt_completed` datetime DEFAULT NULL,
  `dt_planned` datetime DEFAULT NULL,
  `dt_due` datetime DEFAULT NULL,
  `estimate_hours` int(11) DEFAULT NULL,
  `description` text,
  `latitude` varchar(20) DEFAULT NULL,
  `longitude` varchar(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `effort` varchar(255) DEFAULT NULL,
  `rate` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `is_closed` (`is_closed`),
  KEY `parent_id` (`parent_id`),
  KEY `task_group_id` (`task_group_id`),
  KEY `assignee_id` (`assignee_id`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task`
--

LOCK TABLES `task` WRITE;
/*!40000 ALTER TABLE `task` DISABLE KEYS */;
/*!40000 ALTER TABLE `task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_data`
--

DROP TABLE IF EXISTS `task_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_data` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_id` bigint(20) NOT NULL,
  `data_key` varchar(100) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `task_id` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_data`
--

LOCK TABLES `task_data` WRITE;
/*!40000 ALTER TABLE `task_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_group`
--

DROP TABLE IF EXISTS `task_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `can_assign` varchar(50) NOT NULL,
  `can_view` varchar(50) NOT NULL,
  `can_create` varchar(50) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `description` text,
  `task_group_type` varchar(50) NOT NULL,
  `default_assignee_id` bigint(20) DEFAULT NULL,
  `default_priority` varchar(255) DEFAULT NULL,
  `default_task_type` varchar(255) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `is_automatic_subscription` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `is_active` (`is_active`),
  KEY `default_assignee_id` (`default_assignee_id`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_group`
--

LOCK TABLES `task_group` WRITE;
/*!40000 ALTER TABLE `task_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_group_member`
--

DROP TABLE IF EXISTS `task_group_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_group_member` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_group_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `role` varchar(50) NOT NULL,
  `priority` int(11) NOT NULL DEFAULT '1',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `task_group_id` (`task_group_id`),
  KEY `user_id` (`user_id`),
  KEY `is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_group_member`
--

LOCK TABLES `task_group_member` WRITE;
/*!40000 ALTER TABLE `task_group_member` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_group_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_group_notify`
--

DROP TABLE IF EXISTS `task_group_notify`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_group_notify` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_group_id` bigint(20) NOT NULL,
  `role` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `value` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `task_group_id` (`task_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_group_notify`
--

LOCK TABLES `task_group_notify` WRITE;
/*!40000 ALTER TABLE `task_group_notify` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_group_notify` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_group_user_notify`
--

DROP TABLE IF EXISTS `task_group_user_notify`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_group_user_notify` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `task_group_id` bigint(20) NOT NULL,
  `role` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `value` tinyint(1) NOT NULL DEFAULT '0',
  `task_creation` tinyint(1) NOT NULL DEFAULT '0',
  `task_details` tinyint(1) NOT NULL DEFAULT '0',
  `task_comments` tinyint(1) NOT NULL DEFAULT '0',
  `time_log` tinyint(1) NOT NULL DEFAULT '0',
  `task_documents` tinyint(1) NOT NULL DEFAULT '0',
  `task_pages` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `task_group_id` (`task_group_id`),
  KEY `user_id` (`user_id`),
  KEY `value` (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_group_user_notify`
--

LOCK TABLES `task_group_user_notify` WRITE;
/*!40000 ALTER TABLE `task_group_user_notify` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_group_user_notify` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_object`
--

DROP TABLE IF EXISTS `task_object`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_object` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_id` bigint(20) NOT NULL,
  `key` varchar(255) NOT NULL,
  `table_name` varchar(255) NOT NULL,
  `object_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `task_id` (`task_id`),
  KEY `table_name` (`table_name`),
  KEY `object_id` (`object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_object`
--

LOCK TABLES `task_object` WRITE;
/*!40000 ALTER TABLE `task_object` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_object` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_subscriber`
--

DROP TABLE IF EXISTS `task_subscriber`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_subscriber` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_id` bigint(20) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_subscriber`
--

LOCK TABLES `task_subscriber` WRITE;
/*!40000 ALTER TABLE `task_subscriber` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_subscriber` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_time`
--

DROP TABLE IF EXISTS `task_time`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_time` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `dt_start` datetime NOT NULL,
  `dt_end` datetime NOT NULL,
  `comment_id` bigint(20) NOT NULL,
  `time_type` varchar(255) DEFAULT NULL,
  `is_suspect` tinyint(1) NOT NULL DEFAULT '0',
  `dt_created` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_time`
--

LOCK TABLES `task_time` WRITE;
/*!40000 ALTER TABLE `task_time` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_time` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_user_notify`
--

DROP TABLE IF EXISTS `task_user_notify`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_user_notify` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `task_id` bigint(20) NOT NULL,
  `task_creation` tinyint(1) NOT NULL DEFAULT '0',
  `task_details` tinyint(1) NOT NULL DEFAULT '0',
  `task_comments` tinyint(1) NOT NULL DEFAULT '0',
  `time_log` tinyint(1) NOT NULL DEFAULT '0',
  `task_documents` tinyint(1) NOT NULL DEFAULT '0',
  `task_pages` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `task_id` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_user_notify`
--

LOCK TABLES `task_user_notify` WRITE;
/*!40000 ALTER TABLE `task_user_notify` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_user_notify` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `template`
--

DROP TABLE IF EXISTS `template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `template` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `module` varchar(255) DEFAULT NULL,
  `template_title` text,
  `template_body` longtext,
  `test_title_json` text,
  `test_body_json` text,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `template`
--

LOCK TABLES `template` WRITE;
/*!40000 ALTER TABLE `template` DISABLE KEYS */;
INSERT INTO `template` VALUES (1,'Task Email Template',NULL,'notification_email','task',NULL,'<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\" \"http://www.w3.org/TR/REC-html40/loose.dtd\">\n<html style=\"min-height: 100%; background: #f3f3f3;\">\n<head><span class=\"preheader\"></span></head>\n<body style=\"width: 100% !important; min-width: 100%; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; box-sizing: border-box; color: #0a0a0a; font-family: Helvetica, Arial, sans-serif; font-weight: 400; text-align: left; line-height: 19px; font-size: 16px; margin: 0; padding: 0;\">\n<style type=\"text/css\">\n@media only screen and (max-width:596px) {\n  .small-float-center {\n    text-align: center !important;\n  }\n  .small-text-center {\n    text-align: center !important;\n  }\n  .small-float-center {\n    margin: 0 auto !important; float: none !important;\n  }\n  .small-text-left {\n    text-align: left !important;\n  }\n  .small-text-right {\n    text-align: right !important;\n  }\n  table.body table.container .hide-for-large {\n    display: block !important; width: auto !important; overflow: visible !important;\n  }\n  table.body table.container .row.hide-for-large {\n    display: table !important; width: 100% !important;\n  }\n  table.body table.container .show-for-large {\n    display: none !important; width: 0; mso-hide: all; overflow: hidden;\n  }\n  td.small-1 {\n    display: inline-block !important;\n  }\n  td.small-10 {\n    display: inline-block !important;\n  }\n  td.small-11 {\n    display: inline-block !important;\n  }\n  td.small-12 {\n    display: inline-block !important;\n  }\n  td.small-2 {\n    display: inline-block !important;\n  }\n  td.small-3 {\n    display: inline-block !important;\n  }\n  td.small-4 {\n    display: inline-block !important;\n  }\n  td.small-5 {\n    display: inline-block !important;\n  }\n  td.small-7 {\n    display: inline-block !important;\n  }\n  td.small-8 {\n    display: inline-block !important;\n  }\n  td.small-9 {\n    display: inline-block !important;\n  }\n  th.small-1 {\n    display: inline-block !important;\n  }\n  th.small-10 {\n    display: inline-block !important;\n  }\n  th.small-11 {\n    display: inline-block !important;\n  }\n  th.small-12 {\n    display: inline-block !important;\n  }\n  th.small-2 {\n    display: inline-block !important;\n  }\n  th.small-3 {\n    display: inline-block !important;\n  }\n  th.small-4 {\n    display: inline-block !important;\n  }\n  th.small-5 {\n    display: inline-block !important;\n  }\n  th.small-7 {\n    display: inline-block !important;\n  }\n  th.small-8 {\n    display: inline-block !important;\n  }\n  th.small-9 {\n    display: inline-block !important;\n  }\n  table.body img {\n    width: auto !important; height: auto !important;\n  }\n  table.body center {\n    min-width: 0 !important;\n  }\n  table.body .container {\n    width: 95% !important;\n  }\n  table.body .column {\n    height: auto !important; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; box-sizing: border-box; padding-left: 16px !important; padding-right: 16px !important;\n  }\n  table.body .columns {\n    height: auto !important; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; box-sizing: border-box; padding-left: 16px !important; padding-right: 16px !important;\n  }\n  table.body .collapse .column {\n    padding-left: 0 !important; padding-right: 0 !important;\n  }\n  table.body .collapse .columns {\n    padding-left: 0 !important; padding-right: 0 !important;\n  }\n  table.body .column .column {\n    padding-left: 0 !important; padding-right: 0 !important;\n  }\n  table.body .column .columns {\n    padding-left: 0 !important; padding-right: 0 !important;\n  }\n  table.body .columns .column {\n    padding-left: 0 !important; padding-right: 0 !important;\n  }\n  table.body .columns .columns {\n    padding-left: 0 !important; padding-right: 0 !important;\n  }\n  td.small-1 {\n    width: 8.33333% !important;\n  }\n  th.small-1 {\n    width: 8.33333% !important;\n  }\n  td.small-2 {\n    width: 16.66667% !important;\n  }\n  th.small-2 {\n    width: 16.66667% !important;\n  }\n  td.small-3 {\n    width: 25% !important;\n  }\n  th.small-3 {\n    width: 25% !important;\n  }\n  td.small-4 {\n    width: 33.33333% !important;\n  }\n  th.small-4 {\n    width: 33.33333% !important;\n  }\n  td.small-5 {\n    width: 41.66667% !important;\n  }\n  th.small-5 {\n    width: 41.66667% !important;\n  }\n  td.small-6 {\n    display: inline-block !important; width: 50% !important;\n  }\n  th.small-6 {\n    display: inline-block !important; width: 50% !important;\n  }\n  td.small-7 {\n    width: 58.33333% !important;\n  }\n  th.small-7 {\n    width: 58.33333% !important;\n  }\n  td.small-8 {\n    width: 66.66667% !important;\n  }\n  th.small-8 {\n    width: 66.66667% !important;\n  }\n  td.small-9 {\n    width: 75% !important;\n  }\n  th.small-9 {\n    width: 75% !important;\n  }\n  td.small-10 {\n    width: 83.33333% !important;\n  }\n  th.small-10 {\n    width: 83.33333% !important;\n  }\n  td.small-11 {\n    width: 91.66667% !important;\n  }\n  th.small-11 {\n    width: 91.66667% !important;\n  }\n  td.small-12 {\n    width: 100% !important;\n  }\n  th.small-12 {\n    width: 100% !important;\n  }\n  .column td.small-12 {\n    display: block !important; width: 100% !important;\n  }\n  .column th.small-12 {\n    display: block !important; width: 100% !important;\n  }\n  .columns td.small-12 {\n    display: block !important; width: 100% !important;\n  }\n  .columns th.small-12 {\n    display: block !important; width: 100% !important;\n  }\n  table.body td.small-offset-1 {\n    margin-left: 8.33333% !important;\n  }\n  table.body th.small-offset-1 {\n    margin-left: 8.33333% !important;\n  }\n  table.body td.small-offset-2 {\n    margin-left: 16.66667% !important;\n  }\n  table.body th.small-offset-2 {\n    margin-left: 16.66667% !important;\n  }\n  table.body td.small-offset-3 {\n    margin-left: 25% !important;\n  }\n  table.body th.small-offset-3 {\n    margin-left: 25% !important;\n  }\n  table.body td.small-offset-4 {\n    margin-left: 33.33333% !important;\n  }\n  table.body th.small-offset-4 {\n    margin-left: 33.33333% !important;\n  }\n  table.body td.small-offset-5 {\n    margin-left: 41.66667% !important;\n  }\n  table.body th.small-offset-5 {\n    margin-left: 41.66667% !important;\n  }\n  table.body td.small-offset-6 {\n    margin-left: 50% !important;\n  }\n  table.body th.small-offset-6 {\n    margin-left: 50% !important;\n  }\n  table.body td.small-offset-7 {\n    margin-left: 58.33333% !important;\n  }\n  table.body th.small-offset-7 {\n    margin-left: 58.33333% !important;\n  }\n  table.body td.small-offset-8 {\n    margin-left: 66.66667% !important;\n  }\n  table.body th.small-offset-8 {\n    margin-left: 66.66667% !important;\n  }\n  table.body td.small-offset-9 {\n    margin-left: 75% !important;\n  }\n  table.body th.small-offset-9 {\n    margin-left: 75% !important;\n  }\n  table.body td.small-offset-10 {\n    margin-left: 83.33333% !important;\n  }\n  table.body th.small-offset-10 {\n    margin-left: 83.33333% !important;\n  }\n  table.body td.small-offset-11 {\n    margin-left: 91.66667% !important;\n  }\n  table.body th.small-offset-11 {\n    margin-left: 91.66667% !important;\n  }\n  table.body table.columns td.expander {\n    display: none !important;\n  }\n  table.body table.columns th.expander {\n    display: none !important;\n  }\n  table.body .right-text-pad {\n    padding-left: 10px !important;\n  }\n  table.body .text-pad-right {\n    padding-left: 10px !important;\n  }\n  table.body .left-text-pad {\n    padding-right: 10px !important;\n  }\n  table.body .text-pad-left {\n    padding-right: 10px !important;\n  }\n  table.menu {\n    width: 100% !important;\n  }\n  table.menu td {\n    width: auto !important; display: inline-block !important;\n  }\n  table.menu th {\n    width: auto !important; display: inline-block !important;\n  }\n  table.menu.small-vertical td {\n    display: block !important;\n  }\n  table.menu.small-vertical th {\n    display: block !important;\n  }\n  table.menu.vertical td {\n    display: block !important;\n  }\n  table.menu.vertical th {\n    display: block !important;\n  }\n  table.menu[align=center] {\n    width: auto !important;\n  }\n}\n</style>\n<table class=\"body\" style=\"border-spacing: 0; border-collapse: collapse; vertical-align: top; text-align: left; height: 100%; width: 100%; min-width:100%; color: #0a0a0a; font-family: Helvetica, Arial, sans-serif; font-weight: 400; line-height: 19px; font-size: 16px; background: #f3f3f3; margin: 0; padding: 0;\" bgcolor=\"#f3f3f3\"><tr style=\"vertical-align: top; text-align: left; padding: 0;\" align=\"left\">\n<td class=\"center\" align=\"center\" valign=\"top\" style=\"word-wrap: break-word; -webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto; border-collapse: collapse !important; vertical-align: top; text-align: left; color: #0a0a0a; font-family: Helvetica, Arial, sans-serif; font-weight: 400; line-height: 19px; font-size: 16px; margin: 0; padding: 0;\">\n          <table class=\"container\" style=\"border-spacing: 0; border-collapse: collapse; vertical-align: top; text-align: inherit; width: 580px; min-width: 580px; background: #fefefe; margin: 0 auto; padding: 0;\" bgcolor=\"#fefefe\"><tbody><tr style=\"vertical-align: top; text-align: left; padding: 0;\" align=\"left\"><td style=\"word-wrap: break-word; -webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto; border-collapse: collapse !important; vertical-align: top; text-align: left; color: #0a0a0a; font-family: Helvetica, Arial, sans-serif; font-weight: 400; line-height: 19px; font-size: 16px; margin: 0; padding: 0;\" align=\"left\" valign=\"top\">\n            <table class=\"row cmfive-heading\" style=\"border-spacing: 0; border-collapse: collapse; vertical-align: top; text-align: left; width: 100%; min-width:100%; position: relative; display: table; background: #444; padding: 0;\" bgcolor=\"#444\"><tbody><tr style=\"vertical-align: top; text-align: left; padding: 0;\" align=\"left\">\n<th class=\"small-12 columns first\" style=\"color: #0a0a0a; font-family: Helvetica, Arial, sans-serif; font-weight: 400; text-align: left; line-height: 19px; font-size: 16px; margin: 0 auto; padding: 0px;\" align=\"left\">\n                <table style=\"border-spacing: 0; border-collapse: collapse; vertical-align: top; text-align: left; width: 100%; min-width:100%; padding: 0;\"><tr style=\"vertical-align: top; text-align: left; padding: 0;\" align=\"left\">\n<th style=\"color: #0a0a0a; font-family: Helvetica, Arial, sans-serif; font-weight: 400; text-align: left; line-height: 19px; font-size: 16px; margin: 0; padding: 0;\" align=\"left\">\n                      <center data-parsed=\"\" style=\"width: 100%; min-width: 100%;\">\n                        <img class=\"small-float-center float-center\" src=\"{{ logo_url }}\" align=\"center\" style=\"clear: both; text-decoration: none; outline: 0; -ms-interpolation-mode: bicubic; width: auto; max-width: 300px; display: block; float: none; text-align: center; margin: 0 auto;\">\n</center>\n                    </th>\n                  </tr></table>\n</th>\n            </tr></tbody></table>\n<center data-parsed=\"\" style=\"width: 100%; min-width: 100%;\">\n              <table class=\"container float-center\" style=\"border-spacing: 0; border-collapse: collapse; vertical-align: top; text-align: center; width: 580px; min-width: 580px; float: none; background: #fefefe; margin: 0 auto; padding: 0;\" bgcolor=\"#fefefe\"><tbody><tr style=\"vertical-align: top; text-align: left; padding: 0;\" align=\"left\"><td style=\"word-wrap: break-word; -webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto; border-collapse: collapse !important; vertical-align: top; text-align: left; color: #0a0a0a; font-family: Helvetica, Arial, sans-serif; font-weight: 400; line-height: 19px; font-size: 16px; margin: 0; padding: 0;\" align=\"left\" valign=\"top\">\n                <table class=\"row\" style=\"border-spacing: 0; border-collapse: collapse; vertical-align: top; text-align: left; width: 100%; min-width: 100%; position: relative; display: table; padding: 0;\"><tbody><tr style=\"vertical-align: top; text-align: left; padding: 0;\" align=\"left\">\n<th class=\"cmfive-status-heading small-12 large-12 columns first last\" style=\"width: 564px; min-width: 564px; color: #0a0a0a; font-family: Helvetica, Arial, sans-serif; font-weight: 400; text-align: left; line-height: 19px; font-size: 16px; background: #efefef; margin: 0 auto; padding: 16px;\" align=\"left\" bgcolor=\"#efefef\">\n                    <table style=\"border-spacing: 0; border-collapse: collapse; vertical-align: top; text-align: left; width: 100%; min-width:100%; padding: 0;\"><tr style=\"vertical-align: top; text-align: left; padding: 0;\" align=\"left\">\n<th style=\"color: #0a0a0a; font-family: Helvetica, Arial, sans-serif; font-weight: 400; text-align: left; line-height: 19px; font-size: 16px; margin: 0; padding: 0;\" align=\"left\">\n                            <span align=\"center\" class=\"float-center\" style=\"line-height: normal; height: 100%; font-size: 26pt; font-weight: lighter; color: #444; text-align: center; display: inline-block; width: 100%; min-width:100%;\">{{ status }}</span>\n                        </th>\n                        <th class=\"expander\" style=\"visibility: hidden; width: 0; color: #0a0a0a; font-family: Helvetica, Arial, sans-serif; font-weight: 400; text-align: left; line-height: 19px; font-size: 16px; margin: 0; padding: 0;\" align=\"left\"></th>\n                      </tr></table>\n</th>\n                  </tr></tbody></table>\n<table class=\"row collapse\" style=\"border-spacing: 0; border-collapse: collapse; vertical-align: top; text-align: left; width: 100%; min-width:100%; position: relative; display: table; padding: 0;\"><tbody><tr style=\"vertical-align: top; text-align: left; padding: 0;\" align=\"left\">\n<th class=\"small-12 large-12 columns first last\" style=\"width: 588px; min-width: 588px;color: #0a0a0a; font-family: Helvetica, Arial, sans-serif; font-weight: 400; text-align: left; line-height: 19px; font-size: 16px; margin: 0 auto; padding: 0 0 16px;\" align=\"left\">\n                    <table style=\"border-spacing: 0; border-collapse: collapse; vertical-align: top; text-align: left; width: 100%; min-width:100%; padding: 0;\">\n                      {% for title, value in fields %}\n                      <tr style=\"vertical-align: top; text-align: left; padding: 0;\" align=\"left\">\n<th style=\"color: #0a0a0a; font-family: Helvetica, Arial, sans-serif; font-weight: 400; text-align: left; line-height: 19px; font-size: 16px; margin: 0; padding: 0;\" align=\"left\">\n                          <table class=\"row cmfive-data-row\" style=\"border-spacing: 0; border-collapse: collapse; vertical-align: top; text-align: left; width: 100%; min-width:100%; position: relative; display: table; padding: 0;\"><tbody><tr style=\"vertical-align: top; text-align: left; padding: 0;\" align=\"left\">\n<th class=\"cmfive-data-row-heading small-12 large-6 columns first\" style=\"width: 50%; min-width:50%; color: #0a0a0a; font-family: Helvetica, Arial, sans-serif; font-weight: 400; text-align: left; line-height: 19px; font-size: 16px; border-top-color: #000; border-top-width: 1px; border-top-style: solid; vertical-align: middle; background: #cdcdcd; margin: 0 auto; padding: 15px 20px 16px 16px;\" align=\"left\" bgcolor=\"#cdcdcd\" valign=\"middle\">\n                              \n                                    <span class=\"small-text-center large-text-right\" style=\"width: 100%; min-width:100%; display: inline-block; font-size: 18pt; font-weight: lighter; line-height: normal; text-align: right; color: #000;\">{{ title }}</span>\n                                  \n                            </th>\n                            <th class=\"cmfive-data-row-value small-12 large-6 columns last\" style=\"width: 50%; min-width:50%; color: #0a0a0a; font-family: Helvetica, Arial, sans-serif; font-weight: 400; text-align: left; line-height: 19px; font-size: 16px; border-top-color: #000; border-top-width: 1px; border-top-style: solid; margin: 0 auto; padding: 15px 16px 16px 20px;\" align=\"left\">\n                              <table style=\"border-spacing: 0; border-collapse: collapse; vertical-align: top; text-align: left; width: 100%; min-width: 100%; padding: 0;\"><tr style=\"vertical-align: top; text-align: left; padding: 0;\" align=\"left\">\n<th style=\"color: #0a0a0a; font-family: Helvetica, Arial, sans-serif; font-weight: 400; text-align: left; line-height: 19px; font-size: 16px; margin: 0; padding: 0;\" align=\"left\">\n                                    <span class=\"small-text-center\" style=\"width: 100%; min-width: 100%; display: inline-block; font-size: 18pt; font-weight: lighter; line-height: normal;\">{{ value | raw }}</span>\n                                  </th>\n                                </tr></table>\n</th>\n                            </tr></tbody></table>\n</th>\n                      </tr>\n                      {% endfor %}\n                    </table>\n</th>\n                  </tr></tbody></table>\n                {% if footer %}\n                <table class=\"row\" style=\"border-spacing: 0; border-collapse: collapse; vertical-align: top; text-align: left; width: 100%; min-width: 100%; position: relative; display: table; padding: 0;\"><tbody><tr style=\"vertical-align: top; text-align: left; padding: 0;\" align=\"left\">\n<th class=\"small-12 large-12 columns first last\" style=\"width: 564px; min-width: 564px; color: #0a0a0a; font-family: Helvetica, Arial, sans-serif; font-weight: 400; text-align: left; line-height: 19px; font-size: 16px; margin: 0 auto; padding: 0 16px 16px;\" align=\"left\">\n                    <table style=\"border-spacing: 0; border-collapse: collapse; vertical-align: top; text-align: left; width: 100%; min-width: 100%; padding: 0;\"><tr style=\"vertical-align: top; text-align: left; padding: 0;\" align=\"left\">\n<th style=\"color: #0a0a0a; font-family: Helvetica, Arial, sans-serif; font-weight: 400; text-align: left; line-height: 19px; font-size: 16px; margin: 0; padding: 0;\" align=\"left\">\n                          Description: {{ footer | raw }}\n                        </th>\n                        <th class=\"expander\" style=\"visibility: hidden; width: 0; color: #0a0a0a; font-family: Helvetica, Arial, sans-serif; font-weight: 400; text-align: left; line-height: 19px; font-size: 16px; margin: 0; padding: 0;\" align=\"left\"></th>\n                      </tr></table>\n</th>\n                  </tr></tbody></table>\n                {% endif %}\n                {% if can_view_task | default(true) %}\n                <table class=\"row\" style=\"background-color: #5eb2e1; border-spacing: 0; border-collapse: collapse; vertical-align: top; text-align: left; width: 100%; min-width: 100%; position: relative; display: table; padding: 0;\">\n                    <tbody>\n                      <tr style=\"vertical-align: top; text-align: left; padding: 0;\" align=\"left\">\n              <th class=\"cmfive-button small-12 large-12 columns first last\" style=\"width: 564px; min-width: 564px; color: #0a0a0a; margin: 0 auto;\" align=\"left\">\n                            <table style=\"border-spacing: 0; border-collapse: collapse; vertical-align: top; text-align: left; width: 100%; min-width:100%; padding: 0;\">\n                                    <tr style=\"vertical-align: top; text-align: left; padding: 0;\" align=\"left\">\n                    <th style=\"margin: 0; padding: 0;\" align=\"left\">\n                                          <center data-parsed=\"\" style=\"width: 100%; min-width: 100%;\">\n                                            <a class=\"button expand float-center\" style=\"text-align: center; padding: 16px 0px; text-decoration: none; color: white; font-family: Helvetica, Arial, sans-serif; font-weight: 400; line-height: 1.3; margin: 0 0 0px; height: 100%; width: 100%; min-width:100%; display: inline-block;\" target=\"_blank\" href=\"{{ action_url }}\" align=\"center\">View this task</a>\n                                          </center>\n                                        </th>\n                                  <th class=\"expander\" style=\"visibility: hidden; width: 0; color: #0a0a0a; font-family: Helvetica, Arial, sans-serif; font-weight: 400; text-align: left; line-height: 19px; font-size: 16px; margin: 0; padding: 0;\" align=\"left\"></th>\n                              </tr>\n                                </table>\n              </th>\n                      </tr>\n                    </tbody>\n                </table>\n                {% endif %}\n                </td></tr></tbody></table>\n</center>\n            </td></tr></tbody></table>\n</td>\n      </tr></table>\n<!-- prevent Gmail on iOS font size manipulation --><div style=\"display: none; white-space: nowrap; font: 15px courier;\">                                                             </div>\n</body>\n</html>\n',NULL,'{\"status\":\"[42] New task created\",\"footer\":\"<p>The president has voiced the urgency to finish the detector ASAP, little does she know I have no idea what I\'m doing, people in the fleet are starting to attack one another!<\\/p>\",\"action_url\":\"http:\\/\\/cmfive.com\",\"logo_url\":\"http:\\/\\/cmfive.com\\/wp-content\\/uploads\\/2014\\/05\\/cmfive-logo-for-header.png\",\"fields\":{\"Assigned to\":\"Gaius Baltar\",\"Type\":\"Support Ticket\",\"Title\":\"Finish Cylon Detector\",\"Due\":\"04-05-2092\",\"Status\":\"New\",\"Priority\":\"Critical\"},\"can_view_task\":true}',1,'2018-12-20 10:43:38','2018-12-20 10:43:38',NULL,NULL,0);
/*!40000 ALTER TABLE `template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timelog`
--

DROP TABLE IF EXISTS `timelog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `timelog` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `object_class` varchar(255) DEFAULT NULL,
  `object_id` bigint(20) NOT NULL,
  `dt_start` datetime NOT NULL,
  `dt_end` datetime DEFAULT NULL,
  `time_type` varchar(255) DEFAULT NULL,
  `is_suspect` tinyint(1) NOT NULL DEFAULT '0',
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `user_id` (`user_id`),
  KEY `object_class` (`object_class`),
  KEY `object_id` (`object_id`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timelog`
--

LOCK TABLES `timelog` WRITE;
/*!40000 ALTER TABLE `timelog` DISABLE KEYS */;
/*!40000 ALTER TABLE `timelog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `login` varchar(32) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `password_salt` varchar(255) DEFAULT NULL,
  `contact_id` bigint(20) DEFAULT NULL,
  `password_reset_token` varchar(40) DEFAULT NULL,
  `dt_password_reset_at` timestamp NULL DEFAULT NULL,
  `redirect_url` varchar(255) NOT NULL DEFAULT 'main/index',
  `is_admin` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_group` tinyint(1) NOT NULL DEFAULT '0',
  `dt_lastlogin` datetime DEFAULT NULL,
  `dt_created` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `is_external` tinyint(1) NOT NULL DEFAULT '0',
  `language` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `is_admin` (`is_admin`),
  KEY `is_active` (`is_active`),
  KEY `is_deleted_2` (`is_deleted`),
  KEY `contact_id` (`contact_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','ca1e51f19afbe6e0fb51dde5bcf01ab73e52c7cd','9b618fbc7f9509fc28ebea98becfdd58',1,NULL,NULL,'main/index',1,1,0,'2018-12-20 10:44:19','2012-04-27 06:31:07',0,0,''),(2,'inboxreader','e0ac64bd1feb91c109decee21b7b04ebc2e3615d','891328872fe002f4df2b17b775b8021c',2,NULL,NULL,'main/index',0,1,0,'2018-12-20 10:43:48','2018-12-20 10:43:46',0,0,''),(3,'fred','7b66703c894d82a52ea7736ab9eb434833464c7c','cbaad05cd86aa481c29b1179d3eadca6',3,NULL,NULL,'main/index',0,1,0,'2018-12-20 10:44:17','2018-12-20 10:44:06',0,0,'');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_role`
--

DROP TABLE IF EXISTS `user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `role` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`role`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_role`
--

LOCK TABLES `user_role` WRITE;
/*!40000 ALTER TABLE `user_role` DISABLE KEYS */;
INSERT INTO `user_role` VALUES (1,2,'inbox_reader'),(2,2,'user'),(4,3,'inbox_reader'),(3,3,'inbox_sender'),(5,3,'user');
/*!40000 ALTER TABLE `user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `widget_config`
--

DROP TABLE IF EXISTS `widget_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `widget_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `destination_module` varchar(255) NOT NULL,
  `source_module` varchar(255) NOT NULL,
  `widget_name` varchar(255) NOT NULL,
  `custom_config` text NOT NULL,
  `dt_created` datetime DEFAULT NULL,
  `dt_modified` datetime DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `modifier_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `user_id` (`user_id`),
  KEY `is_deleted_2` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `widget_config`
--

LOCK TABLES `widget_config` WRITE;
/*!40000 ALTER TABLE `widget_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `widget_config` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-12-20 10:45:05
