/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.11-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: website_monitoring
-- ------------------------------------------------------
-- Server version	10.11.11-MariaDB-0ubuntu0.24.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `monitored_sites`
--

DROP TABLE IF EXISTS `monitored_sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `monitored_sites` (
  `ms_id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `url` varchar(2083) NOT NULL,
  `text_match` text NOT NULL,
  `match_type` enum('html','checksum') NOT NULL DEFAULT 'html',
  `status` enum('active','inactive','error') NOT NULL DEFAULT 'active',
  `last_result` text DEFAULT NULL,
  `last_check_datetime` datetime DEFAULT NULL,
  `cookies` text DEFAULT NULL,
  `method` enum('GET','POST') NOT NULL DEFAULT 'GET',
  `post_data` text DEFAULT NULL,
  `headers` text DEFAULT NULL,
  `response_time` float DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ms_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `monitored_sites`
--

LOCK TABLES `monitored_sites` WRITE;
/*!40000 ALTER TABLE `monitored_sites` DISABLE KEYS */;
INSERT INTO `monitored_sites` VALUES
(1,'Mitco Official Website','https://mitco.pk','<ul class=\"menu\"><li class=\"item-435 level1 current active\"><a href=\"/\"><span class=\"item-title\">Home</span></a></li><li class=\"item-468 level1\"><a href=\"/index.php/preset-styles\"><span class=\"item-title\">AboutUs</span></a></li><li class=\"item-465 level1\"><a href=\"/index.php/why-us\"><span class=\"item-title\">WhyUs</span></a></li><li class=\"item-467 level1 parent\"><a href=\"/index.php/products\"><span class=\"item-title\">Products</span></a></li><li class=\"item-469 level1 parent\"><a href=\"/index.php/services\"><span class=\"item-title\">Services</span></a></li><li class=\"item-470 level1\"><a href=\"/index.php/partners\"><span class=\"item-title\">Partners</span></a></li><li class=\"item-612 level1\"><a href=\"/index.php/clients\"><span class=\"item-title\">Clients</span></a></li><li class=\"item-613 level1\"><a href=\"http://www.mitco.pk/jobs/Apply.php\" onclick=\"window.open(this.href,\'targetWindow\',\'toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes,\');return false;\"><span class=\"item-title\">Career</span></a></li><li class=\"item-618 level1 parent\"><a href=\"#\"><span class=\"item-title\">Gallery</span></a></li></ul>','html','inactive','Match found','2025-05-05 17:55:49','mp_844407e91b119d6a00359efeff26eaa4_mixpanel=%7B%22distinct_id%22%3A%20%22%24device%3A19463a485c760d-00cf5c13ec09d5-16462c6e-13c680-19463a485c760d%22%2C%22%24device_id%22%3A%20%2219463a485c760d-00cf5c13ec09d5-16462c6e-13c680-19463a485c760d%22%2C%22%24initial_referrer%22%3A%20%22%24direct%22%2C%22%24initial_referring_domain%22%3A%20%22%24direct%22%2C%22__mps%22%3A%20%7B%7D%2C%22__mpso%22%3A%20%7B%22%24initial_referrer%22%3A%20%22%24direct%22%2C%22%24initial_referring_domain%22%3A%20%22%24direct%22%7D%2C%22__mpus%22%3A%20%7B%7D%2C%22__mpa%22%3A%20%7B%7D%2C%22__mpu%22%3A%20%7B%7D%2C%22__mpr%22%3A%20%5B%5D%2C%22__mpap%22%3A%20%5B%5D%7D; cc65269af8046ad56faa1b8b536f9f37=io3s5uq86vd8uirnqcgsevar36','GET',NULL,'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36',0,'2025-02-26 13:07:01','2025-05-05 12:58:33'),
(2,'Fintech Transformation Services (Pvt.) Ltd.','https://ftsl.com.pk','<div class=\"module_container\"><div class=\"mod-custom mod-custom__address\"><p>FintechTransformationServices(Pvt.)Ltd.<br/>202Q,Block2,PECHS,Karachi<br/>Pakistan</p></div></div>','html','inactive','Match found','2025-05-05 17:55:49',NULL,'GET',NULL,NULL,0,'2025-03-04 05:17:13','2025-05-05 12:58:33'),
(3,'Path Education','https://patheducation.org','<div class=\"module\"><p class=\"text-center\">Copyright©2025RahnumaPublicSchool,PathEducationSociety.AllRightsReserved.</p><!--<p class=\"pull-right\">Designedby<a href=\"https://www.themexpert.com/\" title=\"Visit ThemeXpert!\" >ThemeXpert</a></small></p>--></div>','html','inactive','Match not found','2025-05-05 17:49:04',NULL,'GET',NULL,NULL,0,'2025-03-04 06:21:01','2025-05-05 13:07:58'),
(4,'Al Rahim','https://alrahim.com','<ul class=\"sub-menu elementor-nav-menu--dropdown\"><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-4298\"><a class=\"elementor-sub-item\" href=\"https://alrahim.com/hhk-oil-pvt-limited/\" tabindex=\"-1\">HHKOil(Bio-diesel)</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-4291\"><a class=\"elementor-sub-item\" href=\"https://alrahim.com/al-hamd-bulk-storage-company/\" tabindex=\"-1\">AlHamdBulkStorage</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-4293\"><a class=\"elementor-sub-item\" href=\"https://alrahim.com/al-noor-petroleum-industries-pvt-ltd-company/\" tabindex=\"-1\">AlNoorPetroleum</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-4294\"><a class=\"elementor-sub-item\" href=\"https://alrahim.com/al-rahim-agri-processing-pvt-ltd-company/\" tabindex=\"-1\">AlRahimAgriProcessing</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-4295\"><a class=\"elementor-sub-item\" href=\"https://alrahim.com/al-noor-terminal-pvt-ltd-company/\" tabindex=\"-1\">Al-NoorTerminalPvtLtd</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-4296\"><a class=\"elementor-sub-item\" href=\"https://alrahim.com/al-rahim-tank-terminal-pvt-ltd-company/\" tabindex=\"-1\">AlRahimTankTerminal</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-4297\"><a class=\"elementor-sub-item\" href=\"https://alrahim.com/al-rahim-trading-co-pvt-ltd-company/\" tabindex=\"-1\">AlRahimTrading</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-7298\"><a class=\"elementor-sub-item\" href=\"https://alrahim.com/al-rahim-controlled-atmosphere-storage-pvt-ltd-company/\" tabindex=\"-1\">ARCAS</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-4299\"><a class=\"elementor-sub-item\" href=\"https://alrahim.com/jamia-lubricant-industries-pvt-limited-company/\" tabindex=\"-1\">JamiaLubricants</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-4300\"><a class=\"elementor-sub-item\" href=\"https://alrahim.com/karachi-bulk-storage-and-terminals-pvt-ltd-company/\" tabindex=\"-1\">KarachiBulkStorage&amp;Terminals</a></li></ul>','html','active','Match not found','2025-05-05 18:09:00',NULL,'GET',NULL,NULL,0,'2025-03-04 06:35:03','2025-05-05 13:09:00'),
(5,'Aventis International','https://aventisintl.com','<div class=\"container\"><div class=\"one_half\"><b>Copyright©2015AventisInternationalShipping&amp;Logistics(Pvt.)LimitedAllrightsreserved.</b></div><div class=\"one_half last\"><!--<ul class=\"footer_social_links\"><li><a href=\"#\"><i class=\"fa fa-facebook\"></i></a></li><li><a href=\"#\"><i class=\"fa fa-twitter\"></i></a></li><li><a href=\"#\"><i class=\"fa fa-google-plus\"></i></a></li><li><a href=\"#\"><i class=\"fa fa-linkedin\"></i></a></li><li><a href=\"#\"><i class=\"fa fa-skype\"></i></a></li><li><a href=\"#\"><i class=\"fa fa-flickr\"></i></a></li><li><a href=\"#\"><i class=\"fa fa-html5\"></i></a></li><li><a href=\"#\"><i class=\"fa fa-youtube\"></i></a></li><li><a href=\"#\"><i class=\"fa fa-rss\"></i></a></li></ul>--></div></div>','html','inactive','Match not found','2025-05-05 17:54:41',NULL,'GET',NULL,NULL,0,'2025-03-04 07:03:24','2025-05-05 12:54:41');
/*!40000 ALTER TABLE `monitored_sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'website_monitoring'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-06 11:37:14
