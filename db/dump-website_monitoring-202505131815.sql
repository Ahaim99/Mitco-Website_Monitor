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
  `alert_email` varchar(255) DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `monitored_sites`
--

LOCK TABLES `monitored_sites` WRITE;
/*!40000 ALTER TABLE `monitored_sites` DISABLE KEYS */;
INSERT INTO `monitored_sites` VALUES
(1,'Mitco Official Website','https://mitco.pk','alihamza.aimviz99@gmail.com','<div class=\"inner\"><div id=\"footermenu\" class=\"clearfix\"><div class=\"tp_module\"><ul class=\"menu\"><li  class=\"item-435 level1  current active\"><a href=\"/\" ><span class=\"item-title\">Home</span></a></li><li  class=\"item-468 level1\"><a href=\"/index.php/preset-styles\" ><span class=\"item-title\">AboutUs</span></a></li><li  class=\"item-465 level1\"><a href=\"/index.php/why-us\" ><span class=\"item-title\">WhyUs</span></a></li><li  class=\"item-467 level1  parent\"><a href=\"/index.php/products\" ><span class=\"item-title\">Products</span></a></li><li  class=\"item-469 level1  parent\"><a href=\"/index.php/services\" ><span class=\"item-title\">Services</span></a></li><li  class=\"item-470 level1\"><a href=\"/index.php/partners\" ><span class=\"item-title\">Partners</span></a></li><li  class=\"item-612 level1\"><a href=\"/index.php/clients\" ><span class=\"item-title\">Clients</span></a></li><li  class=\"item-613 level1\"><a href=\"http://www.mitco.pk/jobs/Apply.php\" onclick=\"window.open(this.href,\'targetWindow\',\'toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes,\');return false;\" ><span class=\"item-title\">Career</span></a></li><li  class=\"item-618 level1  parent\"><a href=\"#\" ><span class=\"item-title\">Gallery</span></a></li></ul></div>','html','active','Match found','2025-05-13 18:10:53','mp_844407e91b119d6a00359efeff26eaa4_mixpanel=%7B%22distinct_id%22%3A%20%22%24device%3A19463a485c760d-00cf5c13ec09d5-16462c6e-13c680-19463a485c760d%22%2C%22%24device_id%22%3A%20%2219463a485c760d-00cf5c13ec09d5-16462c6e-13c680-19463a485c760d%22%2C%22%24initial_referrer%22%3A%20%22%24direct%22%2C%22%24initial_referring_domain%22%3A%20%22%24direct%22%2C%22__mps%22%3A%20%7B%7D%2C%22__mpso%22%3A%20%7B%22%24initial_referrer%22%3A%20%22%24direct%22%2C%22%24initial_referring_domain%22%3A%20%22%24direct%22%7D%2C%22__mpus%22%3A%20%7B%7D%2C%22__mpa%22%3A%20%7B%7D%2C%22__mpu%22%3A%20%7B%7D%2C%22__mpr%22%3A%20%5B%5D%2C%22__mpap%22%3A%20%5B%5D%7D; cc65269af8046ad56faa1b8b536f9f37=io3s5uq86vd8uirnqcgsevar36','GET',NULL,'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36',0,'2025-02-26 13:07:01','2025-05-13 13:10:53'),
(2,'Fintech Transformation Services (Pvt.) Ltd.','https://ftsl.com.pk','alihamza.aimviz99@gmail.com','<div class=\"moduletable address  span5\"><div class=\"module_container\"><div class=\"mod-custom mod-custom__address\"  ><p>FintechTransformationServices(Pvt.)Ltd.<br />202Q,Block2,PECHS,Karachi<br />Pakistan</p></div>','html','active','Match found','2025-05-13 18:10:54',NULL,'GET',NULL,NULL,0,'2025-03-04 05:17:13','2025-05-13 13:10:54'),
(3,'Path Education','https://patheducation.org','ali.hamza@mitco.pk','<section class=\"t3-copyright\"><div class=\"container\"><div class=\"row\"><div class=\"col-md-12 copyright \"><div class=\"module\"><p class=\"text-center\">Copyright&#169;2025RahnumaPublicSchool,PathEducationSociety.AllRightsReserved.</p><!--<p class=\"pull-right\">Designedby<a href=\"https://www.themexpert.com/\" title=\"Visit ThemeXpert!\" >ThemeXpert</a></small></p>--></div><!--<div class=\"module\"><p class=\"pull-left\"></p><p class=\"pull-right\">Designedby<a href=\"https://www.themexpert.com/\" title=\"Visit ThemeXpert!\">ThemeXpert</a></p></div>--></div></div></div></section>','html','active','Match found','2025-05-13 18:10:55',NULL,'GET',NULL,NULL,0,'2025-03-04 06:21:01','2025-05-13 13:10:55'),
(4,'Al Rahim','https://alrahim.com','ali.hamza@mitco.pk','<div class=\"elementor-element elementor-element-e92ae66 e-flex e-con-boxed e-con e-parent\" data-id=\"e92ae66\" data-element_type=\"container\"><div class=\"e-con-inner\"><div class=\"elementor-element elementor-element-55e36f0 elementor-widget elementor-widget-nav-menu\" data-id=\"55e36f0\" data-element_type=\"widget\" data-settings=\"{&quot;layout&quot;:&quot;dropdown&quot;,&quot;submenu_icon&quot;:{&quot;value&quot;:&quot;&lt;svg class=\\&quot;e-font-icon-svg e-fas-caret-down\\&quot; viewBox=\\&quot;0 0 320 512\\&quot; xmlns=\\&quot;http:\\/\\/www.w3.org\\/2000\\/svg\\&quot;&gt;&lt;path d=\\&quot;M31.3 192h257.3c17.8 0 26.7 21.5 14.1 34.1L174.1 354.8c-7.8 7.8-20.5 7.8-28.3 0L17.2 226.1C4.6 213.5 13.5 192 31.3 192z\\&quot;&gt;&lt;\\/path&gt;&lt;\\/svg&gt;&quot;,&quot;library&quot;:&quot;fa-solid&quot;}}\" data-widget_type=\"nav-menu.default\"><div class=\"elementor-widget-container\"><nav class=\"elementor-nav-menu--dropdown elementor-nav-menu__container\" aria-hidden=\"true\"><ul id=\"menu-2-55e36f0\" class=\"elementor-nav-menu\"><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-home current-menu-item page_item page-item-43 current_page_item menu-item-54\"><a href=\"https://alrahim.com/\" aria-current=\"page\" class=\"elementor-item elementor-item-active\" tabindex=\"-1\">Home</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-has-children menu-item-7983\"><a href=\"https://alrahim.com/our-story/\" class=\"elementor-item\" tabindex=\"-1\">OurStory</a><ul class=\"sub-menu elementor-nav-menu--dropdown\"><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-7333\"><a href=\"https://alrahim.com/vision-mission/\" class=\"elementor-sub-item\" tabindex=\"-1\">Vision&amp;Mission</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-7977\"><a href=\"https://alrahim.com/leadership/\" class=\"elementor-sub-item\" tabindex=\"-1\">Leadership</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-9328\"><a href=\"https://alrahim.com/management-team/\" class=\"elementor-sub-item\" tabindex=\"-1\">ManagementTeam</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-3128\"><a href=\"https://alrahim.com/messages-from-board/\" class=\"elementor-sub-item\" tabindex=\"-1\">MessagesfromBoard</a></li></ul></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-2484\"><a href=\"https://alrahim.com/services/\" class=\"elementor-item\" tabindex=\"-1\">Services</a></li><li class=\"menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children menu-item-4301\"><a href=\"https://alrahim.com/company/\" class=\"elementor-item\" tabindex=\"-1\">Companies</a><ul class=\"sub-menu elementor-nav-menu--dropdown\"><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-4298\"><a href=\"https://alrahim.com/hhk-oil-pvt-limited/\" class=\"elementor-sub-item\" tabindex=\"-1\">HHKOil(Bio-diesel)</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-4291\"><a href=\"https://alrahim.com/al-hamd-bulk-storage-company/\" class=\"elementor-sub-item\" tabindex=\"-1\">AlHamdBulkStorage</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-4293\"><a href=\"https://alrahim.com/al-noor-petroleum-industries-pvt-ltd-company/\" class=\"elementor-sub-item\" tabindex=\"-1\">AlNoorPetroleum</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-4294\"><a href=\"https://alrahim.com/al-rahim-agri-processing-pvt-ltd-company/\" class=\"elementor-sub-item\" tabindex=\"-1\">AlRahimAgriProcessing</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-4295\"><a href=\"https://alrahim.com/al-noor-terminal-pvt-ltd-company/\" class=\"elementor-sub-item\" tabindex=\"-1\">Al-NoorTerminalPvtLtd</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-4296\"><a href=\"https://alrahim.com/al-rahim-tank-terminal-pvt-ltd-company/\" class=\"elementor-sub-item\" tabindex=\"-1\">AlRahimTankTerminal</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-4297\"><a href=\"https://alrahim.com/al-rahim-trading-co-pvt-ltd-company/\" class=\"elementor-sub-item\" tabindex=\"-1\">AlRahimTrading</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-7298\"><a href=\"https://alrahim.com/al-rahim-controlled-atmosphere-storage-pvt-ltd-company/\" class=\"elementor-sub-item\" tabindex=\"-1\">ARCAS</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-4299\"><a href=\"https://alrahim.com/jamia-lubricant-industries-pvt-limited-company/\" class=\"elementor-sub-item\" tabindex=\"-1\">JamiaLubricants</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-4300\"><a href=\"https://alrahim.com/karachi-bulk-storage-and-terminals-pvt-ltd-company/\" class=\"elementor-sub-item\" tabindex=\"-1\">KarachiBulkStorage&#038;Terminals</a></li></ul></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-3127\"><a href=\"https://alrahim.com/health-safety/\" class=\"elementor-item\" tabindex=\"-1\">Health&amp;Safety</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-7006\"><a href=\"https://alrahim.com/accreditations/\" class=\"elementor-item\" tabindex=\"-1\">Accreditations</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-11996\"><a href=\"https://alrahim.com/our-clients/\" class=\"elementor-item\" tabindex=\"-1\">Clients</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-3126\"><a href=\"https://alrahim.com/join-us/\" class=\"elementor-item\" tabindex=\"-1\">JoinUs</a></li><li class=\"menu-item menu-item-type-post_type menu-item-object-page menu-item-2485\"><a href=\"https://alrahim.com/contact-us/\" class=\"elementor-item\" tabindex=\"-1\">ContactUs</a></li></ul></nav></div>','html','active','Match found','2025-05-13 18:10:56',NULL,'GET',NULL,NULL,0,'2025-03-04 06:35:03','2025-05-13 13:10:56'),
(5,'Aventis International','https://aventisintl.com','ali.hamza@mitco.pk','<div class=\"copyright_info\"><div class=\"container\"><div class=\"one_half\"><b>Copyright©2015AventisInternationalShipping&Logistics(Pvt.)LimitedAllrightsreserved.</b></div>','html','active','Match found','2025-05-13 18:10:57',NULL,'GET',NULL,NULL,0,'2025-03-04 07:03:24','2025-05-13 13:10:57'),
(10,'APX Website','https://apxwebsite.xs.net.pk/index.php/en','alihamza.aimviz99@gmail.com','<div id=\"sppb-addon-wrapper-1684169440889\" class=\"sppb-addon-wrapper\"><div id=\"sppb-addon-1684169440889\" class=\"clearfix \"     ><div class=\"sppb-addon sppb-addon-raw-html \"><h4 class=\"sppb-addon-title\">OfficeAddress</h4><div class=\"sppb-addon-content\"><ul class=\"list-items\"><li><span class=\"fa fa-map-marker-alt mrr-10 text-primary\"></span>187/B,Block2,P.E.C.H.S,NearMcDonald,Karachi-Pakistan</li><li><span class=\"fas fa-envelope mrr-10 text-primary\"></span>info@apxlog.com</li><li><span class=\"fas fa-phone-alt mrr-10 text-primary\"></span>+923008208588</li></ul></div>','html','active','Match found','2025-05-13 18:10:58',NULL,'GET',NULL,NULL,0,'2025-05-13 07:37:11','2025-05-13 13:10:58');
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

-- Dump completed on 2025-05-13 18:15:58
