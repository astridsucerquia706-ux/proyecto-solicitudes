-- MySQL dump 10.13  Distrib 8.4.3, for Win64 (x86_64)
--
-- Host: localhost    Database: solicitudes
-- ------------------------------------------------------
-- Server version	8.4.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activities`
--

DROP TABLE IF EXISTS `activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activities` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint unsigned NOT NULL,
  `activity_type_id` bigint unsigned NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date` date NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `activities_student_id_foreign` (`student_id`),
  KEY `activities_activity_type_id_foreign` (`activity_type_id`),
  CONSTRAINT `activities_activity_type_id_foreign` FOREIGN KEY (`activity_type_id`) REFERENCES `activity_types` (`id`),
  CONSTRAINT `activities_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activities`
--

LOCK TABLES `activities` WRITE;
/*!40000 ALTER TABLE `activities` DISABLE KEYS */;
INSERT INTO `activities` VALUES (1,1,2,'Semillero de Bases de Datos','2026-03-10','Participación en el semillero del programa','2026-11-21 13:51:50','2026-11-21 13:51:50'),(2,1,5,'Torneo interno de voleibol','2026-05-22','Equipo femenino de la facultad','2026-11-21 13:51:50','2026-11-21 13:51:50'),(3,2,1,'Congreso de Ingeniería 2026','2026-04-18','Asistente','2026-11-21 13:51:50','2026-11-21 13:51:50'),(4,2,3,'Prototipo de inventarios','2026-09-05','Apoyo en el desarrollo','2026-11-21 13:51:50','2026-11-21 13:51:50'),(5,4,5,'Selección de fútbol sala','2026-08-15',NULL,'2026-11-21 13:51:50','2026-11-21 13:51:50'),(6,5,4,'Artículo en revista estudiantil','2026-06-01','Coautora','2026-11-21 13:51:50','2026-11-21 13:51:50'),(7,5,1,'Encuentro de Semilleros','2026-10-02','Ponente','2026-11-21 13:51:50','2026-11-21 13:51:50');
/*!40000 ALTER TABLE `activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `activity_types`
--

DROP TABLE IF EXISTS `activity_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_types` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `activity_types_name_unique` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_types`
--

LOCK TABLES `activity_types` WRITE;
/*!40000 ALTER TABLE `activity_types` DISABLE KEYS */;
INSERT INTO `activity_types` VALUES (1,'Congreso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(2,'Semillero de investigación','2026-11-21 13:51:50','2026-11-21 13:51:50'),(3,'Proyecto de investigación','2026-11-21 13:51:50','2026-11-21 13:51:50'),(4,'Publicación','2026-11-21 13:51:50','2026-11-21 13:51:50'),(5,'Deporte','2026-11-21 13:51:50','2026-11-21 13:51:50'),(6,'Otro','2026-11-21 13:51:50','2026-11-21 13:51:50');
/*!40000 ALTER TABLE `activity_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audits`
--

DROP TABLE IF EXISTS `audits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audits` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `table_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `record_id` bigint unsigned NOT NULL,
  `action` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `old_values` json DEFAULT NULL,
  `new_values` json DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `audits_user_id_foreign` (`user_id`),
  CONSTRAINT `audits_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `chk_audits_action` CHECK ((`action` in (_utf8mb4'INSERT',_utf8mb4'UPDATE',_utf8mb4'DELETE')))
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audits`
--

LOCK TABLES `audits` WRITE;
/*!40000 ALTER TABLE `audits` DISABLE KEYS */;
INSERT INTO `audits` VALUES (1,'requests',1,'INSERT',NULL,'{\"reason\": \"Cambié de horario en el trabajo y no puedo asistir a las clases de la tarde.\", \"status\": \"pendiente\", \"enrollment_id\": 8}',3,'2026-11-21 08:51:50'),(2,'requests',2,'INSERT',NULL,'{\"reason\": \"Tengo carga académica alta y prefiero ver Física Mecánica el próximo semestre.\", \"status\": \"pendiente\", \"enrollment_id\": 28}',4,'2026-11-21 08:51:50'),(3,'requests',3,'INSERT',NULL,'{\"reason\": \"No me está yendo bien en los parciales.\", \"status\": \"pendiente\", \"enrollment_id\": 45}',6,'2026-11-21 08:51:50'),(4,'requests',4,'INSERT',NULL,'{\"reason\": \"Problemas de salud que me impiden asistir durante varias semanas.\", \"status\": \"pendiente\", \"enrollment_id\": 60}',7,'2026-11-21 08:51:50'),(5,'enrollments',28,'UPDATE','{\"grade\": null, \"status\": \"en_curso\"}','{\"grade\": null, \"status\": \"cancelada\"}',1,'2026-11-21 08:51:50'),(6,'requests',2,'UPDATE','{\"status\": \"pendiente\", \"observation\": null, \"reviewer_id\": null}','{\"status\": \"aprobada\", \"observation\": \"Se aprueba: la solicitud está dentro de las fechas del calendario académico.\", \"reviewer_id\": 1}',1,'2026-11-21 08:51:50'),(7,'requests',3,'UPDATE','{\"status\": \"pendiente\", \"observation\": null, \"reviewer_id\": null}','{\"status\": \"rechazada\", \"observation\": \"Se rechaza: el bajo rendimiento no es causal de cancelación; se recomienda tutoría.\", \"reviewer_id\": 1}',1,'2026-11-21 08:51:50'),(8,'enrollments',8,'UPDATE','{\"grade\": null, \"status\": \"en_curso\"}','{\"grade\": null, \"status\": \"cancelada\"}',1,'2026-11-21 08:54:56'),(9,'requests',1,'UPDATE','{\"status\": \"pendiente\", \"observation\": null, \"reviewer_id\": null}','{\"status\": \"aprobada\", \"observation\": \"Se aprueba la cancelación por cruce con el horario laboral.\", \"reviewer_id\": 1}',1,'2026-11-21 08:54:56');
/*!40000 ALTER TABLE `audits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enrollments`
--

DROP TABLE IF EXISTS `enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enrollments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint unsigned NOT NULL,
  `subject_id` bigint unsigned NOT NULL,
  `period_id` bigint unsigned NOT NULL,
  `grade` decimal(2,1) DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'en_curso',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `enrollments_student_id_subject_id_period_id_unique` (`student_id`,`subject_id`,`period_id`),
  KEY `enrollments_subject_id_foreign` (`subject_id`),
  KEY `enrollments_period_id_foreign` (`period_id`),
  CONSTRAINT `enrollments_period_id_foreign` FOREIGN KEY (`period_id`) REFERENCES `periods` (`id`),
  CONSTRAINT `enrollments_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`),
  CONSTRAINT `enrollments_subject_id_foreign` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`),
  CONSTRAINT `chk_enrollments_grade` CHECK ((`grade` between 0.0 and 5.0)),
  CONSTRAINT `chk_enrollments_status` CHECK ((`status` in (_utf8mb4'en_curso',_utf8mb4'aprobada',_utf8mb4'reprobada',_utf8mb4'cancelada')))
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enrollments`
--

LOCK TABLES `enrollments` WRITE;
/*!40000 ALTER TABLE `enrollments` DISABLE KEYS */;
INSERT INTO `enrollments` VALUES (1,1,1,3,4.2,'aprobada','2026-11-21 13:51:49','2026-11-21 13:51:49'),(2,1,2,3,3.4,'aprobada','2026-11-21 13:51:49','2026-11-21 13:51:49'),(3,1,3,3,4.5,'aprobada','2026-11-21 13:51:49','2026-11-21 13:51:49'),(4,1,4,3,3.8,'aprobada','2026-11-21 13:51:49','2026-11-21 13:51:49'),(5,1,5,3,4.6,'aprobada','2026-11-21 13:51:49','2026-11-21 13:51:49'),(6,1,6,3,4.0,'aprobada','2026-11-21 13:51:49','2026-11-21 13:51:49'),(7,1,7,4,NULL,'en_curso','2026-11-21 13:51:49','2026-11-21 13:51:49'),(8,1,8,4,NULL,'cancelada','2026-11-21 13:51:49','2026-11-21 13:54:56'),(9,1,9,4,NULL,'en_curso','2026-11-21 13:51:49','2026-11-21 13:51:49'),(10,1,10,4,NULL,'en_curso','2026-11-21 13:51:49','2026-11-21 13:51:49'),(11,1,11,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(12,2,1,1,3.8,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(13,2,2,1,2.5,'reprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(14,2,3,1,4.0,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(15,2,4,1,3.6,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(16,2,5,1,4.2,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(17,2,6,1,4.5,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(18,2,2,2,3.2,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(19,2,7,2,3.9,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(20,2,9,2,4.1,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(21,2,10,2,3.3,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(22,2,11,2,3.7,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(23,2,8,3,3.5,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(24,2,12,3,4.0,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(25,2,13,3,3.4,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(26,2,16,3,3.9,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(27,2,17,3,4.3,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(28,2,14,4,NULL,'cancelada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(29,2,15,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(30,2,18,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(31,2,19,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(32,2,22,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(33,3,1,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(34,3,2,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(35,3,3,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(36,3,4,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(37,3,5,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(38,3,6,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(39,4,59,3,4.4,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(40,4,60,3,3.0,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(41,4,61,3,3.9,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(42,4,62,3,4.1,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(43,4,63,3,3.5,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(44,4,64,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(45,4,65,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(46,4,66,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(47,4,67,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(48,4,68,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(49,5,59,2,3.6,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(50,5,60,2,2.8,'reprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(51,5,61,2,4.1,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(52,5,62,2,3.9,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(53,5,63,2,4.0,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(54,5,60,3,3.5,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(55,5,64,3,4.0,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(56,5,66,3,3.8,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(57,5,68,3,3.6,'aprobada','2026-11-21 13:51:50','2026-11-21 13:51:50'),(58,5,65,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(59,5,67,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(60,5,69,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(61,5,70,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(62,5,72,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50'),(63,5,73,4,NULL,'en_curso','2026-11-21 13:51:50','2026-11-21 13:51:50');
/*!40000 ALTER TABLE `enrollments` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_enrollments_before_update` BEFORE UPDATE ON `enrollments` FOR EACH ROW BEGIN
                IF NEW.grade IS NOT NULL AND NEW.status <> 'cancelada'
                   AND (OLD.grade IS NULL OR NEW.grade <> OLD.grade) THEN
                    SET NEW.status = IF(NEW.grade >= 3.0, 'aprobada', 'reprobada');
                END IF;
            END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_enrollments_after_update` AFTER UPDATE ON `enrollments` FOR EACH ROW BEGIN
                IF NOT (OLD.status <=> NEW.status) OR NOT (OLD.grade <=> NEW.grade) THEN
                    INSERT INTO audits (table_name, record_id, action, old_values, new_values, user_id, created_at)
                    VALUES ('enrollments', NEW.id, 'UPDATE',
                            JSON_OBJECT('status', OLD.status, 'grade', OLD.grade),
                            JSON_OBJECT('status', NEW.status, 'grade', NEW.grade),
                            @app_user_id, NOW());
                END IF;
            END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'2019_12_14_000001_create_personal_access_tokens_table',1),(2,'2026_11_20_000001_create_roles_table',1),(3,'2026_11_20_000002_create_users_table',1),(4,'2026_11_20_000003_create_programs_table',1),(5,'2026_11_20_000004_create_students_table',1),(6,'2026_11_20_000005_create_subjects_table',1),(7,'2026_11_20_000006_create_prerequisites_table',1),(8,'2026_11_20_000007_create_periods_table',1),(9,'2026_11_20_000008_create_enrollments_table',1),(10,'2026_11_20_000009_create_activity_types_table',1),(11,'2026_11_20_000010_create_activities_table',1),(12,'2026_11_20_000011_create_requests_table',1),(13,'2026_11_20_000012_create_audits_table',1),(14,'2026_11_20_000013_create_triggers',1),(15,'2026_11_20_000014_create_procedures',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `periods`
--

DROP TABLE IF EXISTS `periods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `periods` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `periods_name_unique` (`name`),
  CONSTRAINT `chk_periods_dates` CHECK ((`end_date` > `start_date`))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `periods`
--

LOCK TABLES `periods` WRITE;
/*!40000 ALTER TABLE `periods` DISABLE KEYS */;
INSERT INTO `periods` VALUES (1,'2025-1','2025-01-27','2025-06-07','2026-11-21 13:51:49','2026-11-21 13:51:49'),(2,'2025-2','2025-07-28','2025-12-06','2026-11-21 13:51:49','2026-11-21 13:51:49'),(3,'2026-1','2026-01-26','2026-06-06','2026-11-21 13:51:49','2026-11-21 13:51:49'),(4,'2026-2','2026-07-27','2026-12-05','2026-11-21 13:51:49','2026-11-21 13:51:49');
/*!40000 ALTER TABLE `periods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
INSERT INTO `personal_access_tokens` VALUES (4,'App\\Models\\User',3,'api','4f6a6b48dc894cad6765128d1f024fcd6f4b72daa0d49aea7b8b3b1ce15c86bf','[\"*\"]','2026-11-21 13:56:19',NULL,'2026-11-21 13:55:44','2026-11-21 13:56:19');
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prerequisites`
--

DROP TABLE IF EXISTS `prerequisites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prerequisites` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `subject_id` bigint unsigned NOT NULL,
  `required_subject_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `prerequisites_subject_id_required_subject_id_unique` (`subject_id`,`required_subject_id`),
  KEY `prerequisites_required_subject_id_foreign` (`required_subject_id`),
  CONSTRAINT `prerequisites_required_subject_id_foreign` FOREIGN KEY (`required_subject_id`) REFERENCES `subjects` (`id`),
  CONSTRAINT `prerequisites_subject_id_foreign` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`),
  CONSTRAINT `chk_prerequisites_distinct` CHECK ((`subject_id` <> `required_subject_id`))
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prerequisites`
--

LOCK TABLES `prerequisites` WRITE;
/*!40000 ALTER TABLE `prerequisites` DISABLE KEYS */;
INSERT INTO `prerequisites` VALUES (1,7,1,NULL,NULL),(2,8,2,NULL,NULL),(3,9,1,NULL,NULL),(4,10,4,NULL,NULL),(5,11,6,NULL,NULL),(6,12,9,NULL,NULL),(7,13,7,NULL,NULL),(8,14,8,NULL,NULL),(9,15,8,NULL,NULL),(10,16,11,NULL,NULL),(11,18,12,NULL,NULL),(12,18,13,NULL,NULL),(13,19,7,NULL,NULL),(14,20,8,NULL,NULL),(15,21,14,NULL,NULL),(16,22,16,NULL,NULL),(17,23,18,NULL,NULL),(18,24,13,NULL,NULL),(19,25,19,NULL,NULL),(20,26,15,NULL,NULL),(21,27,22,NULL,NULL),(22,28,21,NULL,NULL),(23,29,23,NULL,NULL),(24,30,24,NULL,NULL),(25,31,23,NULL,NULL),(26,32,20,NULL,NULL),(27,34,27,NULL,NULL),(28,35,29,NULL,NULL),(29,36,30,NULL,NULL),(30,37,30,NULL,NULL),(31,38,20,NULL,NULL),(32,40,34,NULL,NULL),(33,41,31,NULL,NULL),(34,42,38,NULL,NULL),(35,44,19,NULL,NULL),(36,45,39,NULL,NULL),(37,46,40,NULL,NULL),(38,47,45,NULL,NULL),(39,48,43,NULL,NULL),(40,49,36,NULL,NULL),(41,51,35,NULL,NULL),(42,52,46,NULL,NULL),(43,53,47,NULL,NULL),(44,54,47,NULL,NULL),(45,55,48,NULL,NULL),(46,58,52,NULL,NULL),(47,64,59,NULL,NULL),(48,65,60,NULL,NULL),(49,66,59,NULL,NULL),(50,67,60,NULL,NULL),(51,68,63,NULL,NULL),(52,69,64,NULL,NULL),(53,70,64,NULL,NULL),(54,71,61,NULL,NULL),(55,72,66,NULL,NULL),(56,73,68,NULL,NULL),(57,74,69,NULL,NULL),(58,75,70,NULL,NULL),(59,76,71,NULL,NULL),(60,77,72,NULL,NULL),(61,79,73,NULL,NULL),(62,80,77,NULL,NULL),(63,81,75,NULL,NULL),(64,82,76,NULL,NULL),(65,83,77,NULL,NULL),(66,85,79,NULL,NULL),(67,86,80,NULL,NULL),(68,86,81,NULL,NULL),(69,87,83,NULL,NULL),(70,89,82,NULL,NULL),(71,91,85,NULL,NULL);
/*!40000 ALTER TABLE `prerequisites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programs`
--

DROP TABLE IF EXISTS `programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `programs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `programs_name_unique` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programs`
--

LOCK TABLES `programs` WRITE;
/*!40000 ALTER TABLE `programs` DISABLE KEYS */;
INSERT INTO `programs` VALUES (1,'Ingeniería de Software','2026-11-21 13:51:48','2026-11-21 13:51:48'),(2,'Tecnología en Desarrollo de Software','2026-11-21 13:51:48','2026-11-21 13:51:48');
/*!40000 ALTER TABLE `programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requests`
--

DROP TABLE IF EXISTS `requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requests` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `enrollment_id` bigint unsigned NOT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pendiente',
  `reviewer_id` bigint unsigned DEFAULT NULL,
  `observation` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `decided_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `requests_enrollment_id_foreign` (`enrollment_id`),
  KEY `requests_reviewer_id_foreign` (`reviewer_id`),
  CONSTRAINT `requests_enrollment_id_foreign` FOREIGN KEY (`enrollment_id`) REFERENCES `enrollments` (`id`),
  CONSTRAINT `requests_reviewer_id_foreign` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`id`),
  CONSTRAINT `chk_requests_status` CHECK ((`status` in (_utf8mb4'pendiente',_utf8mb4'aprobada',_utf8mb4'rechazada')))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requests`
--

LOCK TABLES `requests` WRITE;
/*!40000 ALTER TABLE `requests` DISABLE KEYS */;
INSERT INTO `requests` VALUES (1,8,'Cambié de horario en el trabajo y no puedo asistir a las clases de la tarde.','aprobada',1,'Se aprueba la cancelación por cruce con el horario laboral.','2026-11-21 08:51:50','2026-11-21 08:54:56','2026-11-21 08:54:56'),(2,28,'Tengo carga académica alta y prefiero ver Física Mecánica el próximo semestre.','aprobada',1,'Se aprueba: la solicitud está dentro de las fechas del calendario académico.','2026-11-21 08:51:50','2026-11-21 08:51:50','2026-11-21 08:51:50'),(3,45,'No me está yendo bien en los parciales.','rechazada',1,'Se rechaza: el bajo rendimiento no es causal de cancelación; se recomienda tutoría.','2026-11-21 08:51:50','2026-11-21 08:51:50','2026-11-21 08:51:50'),(4,60,'Problemas de salud que me impiden asistir durante varias semanas.','pendiente',NULL,NULL,'2026-11-21 08:51:50','2026-11-21 08:51:50',NULL);
/*!40000 ALTER TABLE `requests` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_requests_before_insert` BEFORE INSERT ON `requests` FOR EACH ROW BEGIN
                DECLARE v_status VARCHAR(20);
                DECLARE v_pending INT;

                SELECT status INTO v_status FROM enrollments WHERE id = NEW.enrollment_id;
                IF v_status IS NULL OR v_status <> 'en_curso' THEN
                    SIGNAL SQLSTATE '45000'
                        SET MESSAGE_TEXT = 'Solo se puede solicitar la cancelación de una materia en curso';
                END IF;

                SELECT COUNT(*) INTO v_pending FROM requests
                WHERE enrollment_id = NEW.enrollment_id AND status = 'pendiente';
                IF v_pending > 0 THEN
                    SIGNAL SQLSTATE '45000'
                        SET MESSAGE_TEXT = 'Ya existe una solicitud pendiente para esta materia';
                END IF;

                SET NEW.status = 'pendiente';
                SET NEW.reviewer_id = NULL;
                SET NEW.observation = NULL;
                SET NEW.decided_at = NULL;
            END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_requests_after_insert` AFTER INSERT ON `requests` FOR EACH ROW BEGIN
                INSERT INTO audits (table_name, record_id, action, old_values, new_values, user_id, created_at)
                VALUES ('requests', NEW.id, 'INSERT', NULL,
                        JSON_OBJECT('enrollment_id', NEW.enrollment_id, 'reason', NEW.reason, 'status', NEW.status),
                        @app_user_id, NOW());
            END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_requests_before_update` BEFORE UPDATE ON `requests` FOR EACH ROW BEGIN
                IF OLD.status <> 'pendiente' AND NEW.status <> OLD.status THEN
                    SIGNAL SQLSTATE '45000'
                        SET MESSAGE_TEXT = 'La solicitud ya fue resuelta y no se puede cambiar';
                END IF;

                IF OLD.status = 'pendiente' AND NEW.status IN ('aprobada', 'rechazada') THEN
                    IF NEW.observation IS NULL OR TRIM(NEW.observation) = '' THEN
                        SIGNAL SQLSTATE '45000'
                            SET MESSAGE_TEXT = 'La observación es obligatoria para aprobar o rechazar';
                    END IF;
                    SET NEW.decided_at = NOW();
                END IF;
            END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_requests_after_update` AFTER UPDATE ON `requests` FOR EACH ROW BEGIN
                IF NEW.status = 'aprobada' AND OLD.status <> 'aprobada' THEN
                    UPDATE enrollments SET status = 'cancelada', updated_at = NOW()
                    WHERE id = NEW.enrollment_id;
                END IF;

                INSERT INTO audits (table_name, record_id, action, old_values, new_values, user_id, created_at)
                VALUES ('requests', NEW.id, 'UPDATE',
                        JSON_OBJECT('status', OLD.status, 'reviewer_id', OLD.reviewer_id, 'observation', OLD.observation),
                        JSON_OBJECT('status', NEW.status, 'reviewer_id', NEW.reviewer_id, 'observation', NEW.observation),
                        @app_user_id, NOW());
            END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_unique` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'estudiante','2026-11-21 13:51:48','2026-11-21 13:51:48'),(2,'docente','2026-11-21 13:51:48','2026-11-21 13:51:48');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `program_id` bigint unsigned NOT NULL,
  `document` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `gender` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stratum` tinyint unsigned DEFAULT NULL,
  `city` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `students_user_id_unique` (`user_id`),
  UNIQUE KEY `students_document_unique` (`document`),
  KEY `students_program_id_foreign` (`program_id`),
  CONSTRAINT `students_program_id_foreign` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`),
  CONSTRAINT `students_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `chk_students_stratum` CHECK ((`stratum` between 1 and 6))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (1,3,1,'1001234567','3001112233','Calle 50 # 40-20','2005-03-14','Femenino',2,'Medellín','2026-11-21 13:51:49','2026-11-21 13:51:49'),(2,4,1,'1002345678','3012223344','Carrera 70 # 30-15','2004-08-02','Masculino',3,'Bello','2026-11-21 13:51:49','2026-11-21 13:51:49'),(3,5,1,'1003456789','3023334455',NULL,'2007-01-20','Femenino',1,'Medellín','2026-11-21 13:51:49','2026-11-21 13:51:49'),(4,6,2,'1004567890','3034445566',NULL,'2003-11-09','Masculino',2,'Itagüí','2026-11-21 13:51:49','2026-11-21 13:51:49'),(5,7,2,'1005678901','3045556677',NULL,'2005-06-30','Femenino',3,'Envigado','2026-11-21 13:51:49','2026-11-21 13:51:49');
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subjects`
--

DROP TABLE IF EXISTS `subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subjects` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `program_id` bigint unsigned NOT NULL,
  `code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `credits` tinyint unsigned NOT NULL,
  `semester` tinyint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `subjects_code_unique` (`code`),
  KEY `subjects_program_id_foreign` (`program_id`),
  CONSTRAINT `subjects_program_id_foreign` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`),
  CONSTRAINT `chk_subjects_credits` CHECK ((`credits` > 0)),
  CONSTRAINT `chk_subjects_semester` CHECK ((`semester` between 1 and 10))
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subjects`
--

LOCK TABLES `subjects` WRITE;
/*!40000 ALTER TABLE `subjects` DISABLE KEYS */;
INSERT INTO `subjects` VALUES (1,1,'ISW101','Fundamentos de Programación',3,1,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(2,1,'ISW102','Cálculo Diferencial',4,1,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(3,1,'ISW103','Introducción a la Ingeniería de Software',2,1,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(4,1,'ISW104','Matemáticas Discretas',3,1,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(5,1,'ISW105','Comunicación Oral y Escrita',2,1,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(6,1,'ISW106','Inglés I',2,1,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(7,1,'ISW201','Programación Orientada a Objetos',3,2,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(8,1,'ISW202','Cálculo Integral',4,2,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(9,1,'ISW203','Bases de Datos I',3,2,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(10,1,'ISW204','Álgebra Lineal',3,2,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(11,1,'ISW205','Inglés II',2,2,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(12,1,'ISW301','Bases de Datos II',3,3,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(13,1,'ISW302','Estructuras de Datos',3,3,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(14,1,'ISW303','Física Mecánica',3,3,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(15,1,'ISW304','Cálculo Multivariable',3,3,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(16,1,'ISW305','Inglés III',2,3,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(17,1,'ISW306','Ética Profesional',2,3,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(18,1,'ISW401','Ingeniería de Software I',3,4,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(19,1,'ISW402','Programación Web',3,4,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(20,1,'ISW403','Estadística y Probabilidad',3,4,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(21,1,'ISW404','Física Eléctrica',3,4,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(22,1,'ISW405','Inglés IV',2,4,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(23,1,'ISW501','Ingeniería de Software II',3,5,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(24,1,'ISW502','Sistemas Operativos',3,5,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(25,1,'ISW503','Desarrollo Móvil',3,5,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(26,1,'ISW504','Métodos Numéricos',3,5,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(27,1,'ISW505','Inglés V',2,5,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(28,1,'ISW506','Arquitectura de Computadores',3,5,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(29,1,'ISW601','Arquitectura de Software',3,6,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(30,1,'ISW602','Redes de Computadores',3,6,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(31,1,'ISW603','Pruebas de Software',3,6,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(32,1,'ISW604','Investigación de Operaciones',3,6,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(33,1,'ISW605','Emprendimiento',2,6,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(34,1,'ISW606','Inglés VI',2,6,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(35,1,'ISW701','Gestión de Proyectos de Software',3,7,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(36,1,'ISW702','Seguridad Informática',3,7,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(37,1,'ISW703','Computación en la Nube',3,7,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(38,1,'ISW704','Inteligencia Artificial',3,7,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(39,1,'ISW705','Metodología de la Investigación',2,7,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(40,1,'ISW706','Inglés VII',2,7,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(41,1,'ISW801','Calidad de Software',3,8,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(42,1,'ISW802','Aprendizaje Automático',3,8,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(43,1,'ISW803','Electiva Profesional I',3,8,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(44,1,'ISW804','Interacción Humano-Computador',3,8,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(45,1,'ISW805','Seminario de Investigación',2,8,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(46,1,'ISW806','Inglés VIII',2,8,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(47,1,'ISW901','Proyecto de Grado I',4,9,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(48,1,'ISW902','Electiva Profesional II',3,9,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(49,1,'ISW903','Auditoría de Sistemas',3,9,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(50,1,'ISW904','Legislación Informática',2,9,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(51,1,'ISW905','Gerencia de Tecnologías de la Información',3,9,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(52,1,'ISW906','Inglés IX',2,9,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(53,1,'ISW1001','Proyecto de Grado II',4,10,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(54,1,'ISW1002','Práctica Profesional',6,10,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(55,1,'ISW1003','Electiva Profesional III',3,10,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(56,1,'ISW1004','Innovación Tecnológica',2,10,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(57,1,'ISW1005','Seminario de Grado',2,10,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(58,1,'ISW1006','Inglés X',2,10,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(59,2,'TDS101','Algoritmos',3,1,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(60,2,'TDS102','Matemáticas Básicas',3,1,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(61,2,'TDS103','Introducción a la Informática',2,1,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(62,2,'TDS104','Comunicación Oral y Escrita',2,1,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(63,2,'TDS105','Inglés I',2,1,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(64,2,'TDS201','Programación Estructurada',3,2,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(65,2,'TDS202','Estadística',3,2,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(66,2,'TDS203','Bases de Datos',3,2,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(67,2,'TDS204','Lógica Matemática',3,2,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(68,2,'TDS205','Inglés II',2,2,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(69,2,'TDS301','Programación Orientada a Objetos',3,3,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(70,2,'TDS302','Desarrollo Web',3,3,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(71,2,'TDS303','Sistemas Operativos',3,3,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(72,2,'TDS304','Análisis de Sistemas',3,3,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(73,2,'TDS305','Inglés III',2,3,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(74,2,'TDS401','Desarrollo Móvil',3,4,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(75,2,'TDS402','Desarrollo Web Avanzado',3,4,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(76,2,'TDS403','Redes',3,4,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(77,2,'TDS404','Ingeniería de Requisitos',3,4,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(78,2,'TDS405','Ética Profesional',2,4,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(79,2,'TDS406','Inglés IV',2,4,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(80,2,'TDS501','Pruebas de Software',3,5,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(81,2,'TDS502','Servicios Web',3,5,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(82,2,'TDS503','Seguridad de la Información',3,5,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(83,2,'TDS504','Gestión de Proyectos',3,5,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(84,2,'TDS505','Emprendimiento',2,5,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(85,2,'TDS506','Inglés V',2,5,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(86,2,'TDS601','Proyecto Integrador',4,6,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(87,2,'TDS602','Práctica Profesional',6,6,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(88,2,'TDS603','Electiva Tecnológica',3,6,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(89,2,'TDS604','Computación en la Nube',3,6,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(90,2,'TDS605','Seminario',2,6,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(91,2,'TDS606','Inglés VI',2,6,'2026-11-21 13:51:49','2026-11-21 13:51:49');
/*!40000 ALTER TABLE `subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_role_id_foreign` (`role_id`),
  CONSTRAINT `users_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Carlos Ramírez','docente1@pascualbravo.test','$2y$10$uRg4TRmFz3WIUbe1UWwwCuzsIiC4aFa.VnNo8pXO9a26jcGxqjXuS',2,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(2,'Marta Restrepo','docente2@pascualbravo.test','$2y$10$uRg4TRmFz3WIUbe1UWwwCuzsIiC4aFa.VnNo8pXO9a26jcGxqjXuS',2,'2026-11-21 13:51:48','2026-11-21 13:51:48'),(3,'Laura Gómez','laura.gomez@pascualbravo.test','$2y$10$uRg4TRmFz3WIUbe1UWwwCuzsIiC4aFa.VnNo8pXO9a26jcGxqjXuS',1,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(4,'Andrés Ríos','andres.rios@pascualbravo.test','$2y$10$uRg4TRmFz3WIUbe1UWwwCuzsIiC4aFa.VnNo8pXO9a26jcGxqjXuS',1,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(5,'Valentina Torres','valentina.torres@pascualbravo.test','$2y$10$uRg4TRmFz3WIUbe1UWwwCuzsIiC4aFa.VnNo8pXO9a26jcGxqjXuS',1,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(6,'Santiago Herrera','santiago.herrera@pascualbravo.test','$2y$10$uRg4TRmFz3WIUbe1UWwwCuzsIiC4aFa.VnNo8pXO9a26jcGxqjXuS',1,'2026-11-21 13:51:49','2026-11-21 13:51:49'),(7,'Camila Ospina','camila.ospina@pascualbravo.test','$2y$10$uRg4TRmFz3WIUbe1UWwwCuzsIiC4aFa.VnNo8pXO9a26jcGxqjXuS',1,'2026-11-21 13:51:49','2026-11-21 13:51:49');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'solicitudes'
--
/*!50003 DROP FUNCTION IF EXISTS `fn_promedio_estudiante` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_promedio_estudiante`(p_student_id BIGINT UNSIGNED) RETURNS decimal(3,2)
    READS SQL DATA
BEGIN
                DECLARE v_average DECIMAL(3,2);
                SELECT AVG(grade) INTO v_average
                FROM enrollments
                WHERE student_id = p_student_id AND status IN ('aprobada', 'reprobada');
                RETURN v_average;
            END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_promedios_por_programa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_promedios_por_programa`()
BEGIN
                DECLARE v_done INT DEFAULT 0;
                DECLARE v_program_id BIGINT UNSIGNED;
                DECLARE v_program_name VARCHAR(100);
                DECLARE v_average DECIMAL(3,2);
                DECLARE v_students INT;

                DECLARE cur_programs CURSOR FOR SELECT id, name FROM programs ORDER BY name;
                DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;

                DROP TEMPORARY TABLE IF EXISTS tmp_promedios;
                CREATE TEMPORARY TABLE tmp_promedios (
                    programa VARCHAR(100),
                    estudiantes INT,
                    promedio DECIMAL(3,2)
                );

                OPEN cur_programs;
                recorrer: LOOP
                    FETCH cur_programs INTO v_program_id, v_program_name;
                    IF v_done = 1 THEN
                        LEAVE recorrer;
                    END IF;

                    SELECT COUNT(*) INTO v_students FROM students WHERE program_id = v_program_id;

                    SELECT AVG(e.grade) INTO v_average
                    FROM enrollments e
                    JOIN students s ON s.id = e.student_id
                    WHERE s.program_id = v_program_id AND e.status IN ('aprobada', 'reprobada');

                    INSERT INTO tmp_promedios VALUES (v_program_name, v_students, v_average);
                END LOOP;
                CLOSE cur_programs;

                SELECT programa, estudiantes, promedio FROM tmp_promedios;
                DROP TEMPORARY TABLE tmp_promedios;
            END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_reporte_solicitudes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reporte_solicitudes`(IN p_period_id BIGINT UNSIGNED)
BEGIN
                SELECT p.name AS periodo, r.status AS estado, COUNT(*) AS cantidad
                FROM requests r
                JOIN enrollments e ON e.id = r.enrollment_id
                JOIN periods p ON p.id = e.period_id
                WHERE p_period_id IS NULL OR e.period_id = p_period_id
                GROUP BY p.name, r.status
                ORDER BY p.name, r.status;
            END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_resolver_solicitud` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_resolver_solicitud`(
                IN p_request_id BIGINT UNSIGNED,
                IN p_reviewer_id BIGINT UNSIGNED,
                IN p_decision VARCHAR(20),
                IN p_observation VARCHAR(255)
            )
BEGIN
                DECLARE v_status VARCHAR(20);

                DECLARE EXIT HANDLER FOR SQLEXCEPTION
                BEGIN
                    ROLLBACK;
                    RESIGNAL;
                END;

                IF p_decision NOT IN ('aprobada', 'rechazada') THEN
                    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La decisión debe ser aprobada o rechazada';
                END IF;

                START TRANSACTION;

                SELECT status INTO v_status FROM requests WHERE id = p_request_id FOR UPDATE;
                IF v_status IS NULL THEN
                    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La solicitud no existe';
                END IF;
                IF v_status <> 'pendiente' THEN
                    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La solicitud ya fue resuelta';
                END IF;

                UPDATE requests
                SET status = p_decision,
                    reviewer_id = p_reviewer_id,
                    observation = p_observation,
                    updated_at = NOW()
                WHERE id = p_request_id;

                COMMIT;
            END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-21  9:01:33
