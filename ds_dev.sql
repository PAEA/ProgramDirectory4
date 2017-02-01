-- MySQL dump 10.13  Distrib 5.5.54, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: ds_dev
-- ------------------------------------------------------
-- Server version	5.5.54-0ubuntu0.14.04.1

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
-- Table structure for table `about`
--

DROP TABLE IF EXISTS `about`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `about` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state` varchar(20) DEFAULT NULL,
  `university` varchar(255) NOT NULL,
  `school` varchar(255) NOT NULL,
  `dean` varchar(50) DEFAULT NULL,
  `general_information` text,
  `mission` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `about`
--

LOCK TABLES `about` WRITE;
/*!40000 ALTER TABLE `about` DISABLE KEYS */;
INSERT INTO `about` VALUES (1,'Alabama','University of Alabama at Birmingham','School of Dentistry','Michael S. Reddy, D.M.D., D.M.Sc., Dean','The University of Alabama at Birmingham School of Dentistry (UABSOD), located on the campus of the University of Alabama at Birmingham, is an integral part of the large complex of medical facilities on this urban campus at the periphery of downtown Birmingham (metropolitan population: approximately one million). The School of Dentistry was created in 1945 by an act of the state legislature, and the first class matriculated in 1948. Students at the UABSOD pursue their professional education utilizing modern equipment in recently renovated facilities.\r','Our mission is to optimize oral health in Alabama and beyond; our vision is to lead oral health care; our core values are excellence, innovation, patient-centered care and unity of purpose.'),(2,'Arizona','A.T. Still University','Arizona School of Dentistry & Oral Health','Jack Dillenburg, D.D.S., M.P.H., Dean','The Arizona School of Dentistry & Oral Health (ASDOH) prepares caring, technologically adept dentists to become community and educational leaders. The school offers students an experience-rich learning environment where health professionals approach patient health as part of a team. ASDOH is part of A.T. Still University, which also includes the Kirksville College of Osteopathic Medicine, Arizona School of Health Sciences, the College of Graduate Health Studies and the School of Osteopathic Medicine in Arizona.','Educate caring, technologically adept, community-responsive dentists who will seek lifelong learning.\rInculcate a strong foundation comprising critical inquiry, evidence-based practice, research and cultural competency.'),(3,'Arizona','Midwestern University','College of Dental Medicine-Arizona','P. Bradford Smith, D.D.S., Dean','The College of Dental Medicine-Arizona is part of the Glendale, AZ, campus of Midwestern University, which was founded in 1900. The Glendale campus, situated on 146 acres, 15 miles northwest of downtown Phoenix, grew from a single building in 1996 to a full-service university with more than 34 buildings (covering 1,465,032 square feet) and more than 2,925 students. The Glendale campus comprises more than five colleges and 17 programs offering a variety of graduate degrees, including doctoral degree programs. The four-year ental curriculum leads to a D.M.D. degree. The College of Dental Medicine-Arizona graduated its first class in 2012.','Our mission is to graduate well-qualified general dentists and to improve oral health through research, scholarly activity and service to the public.\rOur core values are:\r• Maintaining a student-friendly environment.\r• Promoting ethics/professionalism.\r• Advocating collegiality and teamwork.\r• Focusing on a general dentistry curriculum.\r• Assuring competence for general practice.\r• Delivering comprehensive, patient-centered care.'),(4,'California','Herman Ostrow School of Dentistry of USC','','Avishai Sadan, D.M.D., M.B.A., Dean','The Herman Ostrow School of Dentistry is a private institution founded in 1897. The schoolhas become recognized for the excellence of its faculty in the clinical disciplines. Indeed, many procedures and techniques used in everyday dental practice were originated by University of Southern California faculty members. Programs of the school include those leading to a D.D.S., a B.S. in dental hygiene, certificate programs in advanced (specialty) education and continuing education for the practicing dentist, the Advanced Standing Program for International Dentists for foreign dental school graduates and the graduate program in craniofacial biology leading to the M.S. or Ph.D. degree.','Our mission is to be dedicated to lifelong learning, flexibility and openness to new ideas, we are committed to improving the health of all through education and training, innovation and discovery.\rOur vision is to serve as global leaders in educational innovation, research, teaching and patient care; fostering collaborations locally, inationally and internationally. \rOur core values are to celebrate diversity, demonstrate empathy and respect for others, adhere to the highest standards of our profession, improve the dental, craniofacial and general health of our global communites.'),(5,'California','Loma Linda University',' School of Dentistry','Ronald J. Dailey, Ph.D., Dean','Loma Linda University (LLU) represents distinction in quality Christian education. A private university owned and operated by the Seventh-Day Adventist Church, the university has established a reputation for leadership in mission service, clinical excellence, research and advancements in the health-related sciences. Located 60 miles from Los Angeles in one of the fastest growing areas nationwide, LLU comprises eight health science schools and has an annual enrollment of more than 4,500 students from more than 100 countries. The school offers eight advanced dental education programs and has 122 full-time faculty for an excellent student-faculty ratio of three to one. ','Our mission is to further the teaching and healing ministry of Jesus Christ: Students learn to provide high-quality oral health care based on sound biologic principles.\rOur vision is to be a preeminent health-care organization. We seek to represent God in all we do. We are committed to excellent, innovative, comprehensive student education and whole-person patient care.\rOur core values are belief in God; respect for the individual; principled spirituality; student-focused, empathetic care; commitment to service; pursuit of truth; progressive excellence; analytic thinking; and effective communication.');
/*!40000 ALTER TABLE `about` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ar_internal_metadata`
--

DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ar_internal_metadata`
--

LOCK TABLES `ar_internal_metadata` WRITE;
/*!40000 ALTER TABLE `ar_internal_metadata` DISABLE KEYS */;
INSERT INTO `ar_internal_metadata` VALUES ('environment','development','2017-02-01 00:19:41','2017-02-01 00:19:41');
/*!40000 ALTER TABLE `ar_internal_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curriculum`
--

DROP TABLE IF EXISTS `curriculum`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `curriculum` (
  `school_id` int(11) NOT NULL DEFAULT '0',
  `state` varchar(20) DEFAULT NULL,
  `university` varchar(255) NOT NULL,
  `school` varchar(255) NOT NULL,
  `curriculum` text,
  `research_opportunities` varchar(3) DEFAULT NULL,
  `research_types` varchar(10) DEFAULT NULL,
  `degree_programs` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`school_id`),
  KEY `ix_schoolid` (`school_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curriculum`
--

LOCK TABLES `curriculum` WRITE;
/*!40000 ALTER TABLE `curriculum` DISABLE KEYS */;
INSERT INTO `curriculum` VALUES (1,'Alabama','University of Alabama at Birmingham','School of Dentistry','The objective of the program at the University of Alabama at Birmingham is to produce competent and caring oral health care providers. Our goal is to foster an academic environment that encourages the process of inquiry and the scientific method of problem solving. \rWhile much of the first two years of school is focused on basic science education, students interact with patients very early in the curriculum. The program is organized so that dental students function as assistants in their first year and hygienists in their second year; the third and fourth years are devoted to comprehensive care of patients.\rSpecialty electives are available in the fourth year for students who progress briskly through the curriculum. The school emphasizes progressive education techniques, which include traditional lectures, small-group interactions, problem-based learning and a systems-based basic science education.','Yes','','Ph.D., M.B.A., M.P.H.'),(2,'Arizona','A.T. Still University','Arizona School of Dentistry & Oral Health','The curriculum at the Arizona School of Dentistry & Oral Health is designed to produce graduates who are technologically adept, professionally competent, patient-centered and compassionate.\rThe curriculum emphasizes patient-care experiences through simulation, integration of biomedical and clinical sciences and problem-solving scenarios to achieve clinical excellence. The curriculum includes a strong component of public health, leadership and practice through weekly learning modules.\rStudents have the opportunity to interact with faculty, practicing dentists and national leaders to discuss cases in a regularly scheduled “grand rounds” format.','Yes','','M.P.H.'),(3,'Arizona','Midwestern University','College of Dental Medicine-Arizona','The curriculum emphasizes integrated disciplines that both enhance learning and fully prepare students to practice general dentistry providing total patient care.\rThe basic science curriculum is organized by body systems, rather than by biomedical discipline, and spans five academic quarters. This systems-based approach, combined with clinical case studies, improves the learning experience for entry to patient care and prepares students for Part I of the National Dental Board Examination.\rThe preclinical curriculum is organized by tooth segments, rather than by dental disciplines. This highly integrated coursework spans six academic quarters of instruction in the simulation laboratory, emphasizing competency in a wide variety of clinical procedures. The coursework stresses patient simulation, technical quality, high efficiency and self-assessment. Students begin clinical care on a limited basis in the second year.\rThe foundation of the clinical curriculum in the third and fourth academic years rests in the practice of general dentistry organized in practice groups led by general dentist faculty members. This eight-quarter curriculum emphasizes comprehensive patient-centered care, competency of all students in a full range of patient care services, and practice management and efficiency.\rThe curriculum also prepares students for Part II of the National Board Dental Examination and clinical licensure examinations.','Yes','','No combined degree programs available.'),(4,'California','','Herman Ostrow School of Dentistry of USC','The curricular goals are the following:\r1. To use student-centered, inquiry-based methods in all aspects of basic, preclinical and clinical science instruction throughout all four years that will encourage students to develop lifelong problem-solving and group learning skills.\r2. To encourage students to question materials presented and to develop a collegial interaction with the faculty—all areas of instruction occur in a professional atmosphere, and there is no activity that demeans students or creates an atmosphere in which student inquiry is repressed.\r3. To vertically integrate the curriculum so that all three sciences and clinical skills are organized to emphasize the direct relevance of basic science learning outcomes to clinical problems.\r4. To develop dental graduates who are:\r›› Dedicated to lifelong, self-motivated learning.\r›› Accomplished in the methods required to solve problems in a clinical setting.\r›› Able to effectively understand and respond to changes in the profession.','Yes','','Ph.D., M.S., B.A./B.S.'),(5,'California','Loma Linda University','School of Dentistry','LLUSD’s program is a traditional dental curriculum with emphasis in clinical training. Graduates are skilled in providing quality dental care that is comprehensive in its scope and preventive in its goals.\r• Year 1: Basic sciences with introduction to clinical sciences.\r• Year 2: Applied sciences and introduction to clinical practice.\r• Year 3: Clinical sciences with extensive patient contact.\r• Year 4: Delivery of comprehensive dental care.','Yes','','Ph.D., M.P.H., M.S., B.A./B.S.');
/*!40000 ALTER TABLE `curriculum` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fast_facts`
--

DROP TABLE IF EXISTS `fast_facts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fast_facts` (
  `school_id` int(11) NOT NULL DEFAULT '0',
  `state` varchar(20) DEFAULT NULL,
  `university` varchar(255) NOT NULL,
  `school` varchar(255) NOT NULL,
  `type_of_institution` varchar(50) DEFAULT NULL,
  `year_opened` char(4) DEFAULT NULL,
  `term_type` varchar(50) DEFAULT NULL,
  `time_to_degree` smallint(6) DEFAULT NULL,
  `start_month` varchar(10) DEFAULT NULL,
  `doctoral_degree` varchar(10) DEFAULT NULL,
  `targeted_predoctoral` smallint(6) DEFAULT NULL,
  `targeted_class_size` smallint(6) DEFAULT NULL,
  `campus_setting` varchar(20) DEFAULT NULL,
  `campus_housing` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`school_id`),
  KEY `ix_schoolid` (`school_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fast_facts`
--

LOCK TABLES `fast_facts` WRITE;
/*!40000 ALTER TABLE `fast_facts` DISABLE KEYS */;
INSERT INTO `fast_facts` VALUES (1,'Alabama','University of Alabama at Birmingham','School of Dentistry','Public','1948','Semester',48,'July','D.M.D.',240,60,'Urban','Yes'),(2,'Arizona','A.T. Still University','Arizona School of Dentistry & Oral Health','Private','2003','Semester',48,'July','D.M.D.',300,76,'Suburban','No'),(3,'Arizona','Midwestern University','College of Dental Medicine-Arizona','Private','2008','Quarter',46,'August','D.M.D.',560,140,'Suburban','Yes'),(4,'California','','Herman Ostrow School of Dentistry of USC','Private','1897','Trimester',40,'August','D.D.S.',580,144,'Urban','Yes'),(5,'California','Loma Linda University','School of Dentistry','Private','1953','Quarter',45,'August','D.D.S.',400,100,'Suburban','Yes');
/*!40000 ALTER TABLE `fast_facts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `general_information`
--

DROP TABLE IF EXISTS `general_information`;
/*!50001 DROP VIEW IF EXISTS `general_information`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `general_information` (
  `id` tinyint NOT NULL,
  `state` tinyint NOT NULL,
  `university` tinyint NOT NULL,
  `school` tinyint NOT NULL,
  `dean` tinyint NOT NULL,
  `general_information` tinyint NOT NULL,
  `mission` tinyint NOT NULL,
  `curriculum` tinyint NOT NULL,
  `research_opportunities` tinyint NOT NULL,
  `research_types` tinyint NOT NULL,
  `degree_programs` tinyint NOT NULL,
  `type_of_institution` tinyint NOT NULL,
  `year_opened` tinyint NOT NULL,
  `term_type` tinyint NOT NULL,
  `time_to_degree` tinyint NOT NULL,
  `start_month` tinyint NOT NULL,
  `doctoral_degree` tinyint NOT NULL,
  `targeted_predoctoral` tinyint NOT NULL,
  `targeted_class_size` tinyint NOT NULL,
  `campus_setting` tinyint NOT NULL,
  `campus_housing` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20170201030605');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schools`
--

DROP TABLE IF EXISTS `schools`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schools` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state` varchar(255) DEFAULT NULL,
  `university` varchar(255) DEFAULT NULL,
  `school` varchar(255) DEFAULT NULL,
  `dean` varchar(255) DEFAULT NULL,
  `general_information` text,
  `mission` text,
  `curriculum` text,
  `research_opportunities` varchar(255) DEFAULT NULL,
  `research_types` varchar(255) DEFAULT NULL,
  `degree_programs` varchar(255) DEFAULT NULL,
  `type_of_institution` varchar(255) DEFAULT NULL,
  `year_opened` varchar(255) DEFAULT NULL,
  `term_type` varchar(255) DEFAULT NULL,
  `time_to_degree` varchar(255) DEFAULT NULL,
  `start_month` varchar(255) DEFAULT NULL,
  `doctoral_degree` varchar(255) DEFAULT NULL,
  `targeted_predoctoral` varchar(255) DEFAULT NULL,
  `targeted_class_size` varchar(255) DEFAULT NULL,
  `campus_setting` varchar(255) DEFAULT NULL,
  `campus_housing` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schools`
--

LOCK TABLES `schools` WRITE;
/*!40000 ALTER TABLE `schools` DISABLE KEYS */;
INSERT INTO `schools` VALUES (2,'Alabama','University of Alabama at Birmingham','School of Dentistry','Michael S. Reddy, D.M.D., D.M.Sc., Dean','The University of Alabama at Birmingham School of Dentistry (UABSOD), located on the campus of the University of Alabama at Birmingham, is an integral part of the large complex of medical facilities on this urban campus at the periphery of downtown Birmingham (metropolitan population: approximately one million). The School of Dentistry was created in 1945 by an act of the state legislature, and the first class matriculated in 1948. Students at the UABSOD pursue their professional education utilizing modern equipment in recently renovated facilities.\r','Our mission is to optimize oral health in Alabama and beyond; our vision is to lead oral health care; our core values are excellence, innovation, patient-centered care and unity of purpose.','The objective of the program at the University of Alabama at Birmingham is to produce competent and caring oral health care providers. Our goal is to foster an academic environment that encourages the process of inquiry and the scientific method of problem solving. \rWhile much of the first two years of school is focused on basic science education, students interact with patients very early in the curriculum. The program is organized so that dental students function as assistants in their first year and hygienists in their second year; the third and fourth years are devoted to comprehensive care of patients.\rSpecialty electives are available in the fourth year for students who progress briskly through the curriculum. The school emphasizes progressive education techniques, which include traditional lectures, small-group interactions, problem-based learning and a systems-based basic science education.','Yes','','Ph.D., M.B.A., M.P.H.','Public','1948','Semester','48','July','D.M.D.','240','60','Urban','Yes','2017-02-01 03:49:20','2017-02-01 03:49:20'),(3,'Arizona','A.T. Still University','Arizona School of Dentistry & Oral Health','Jack Dillenburg, D.D.S., M.P.H., Dean','The Arizona School of Dentistry & Oral Health (ASDOH) prepares caring, technologically adept dentists to become community and educational leaders. The school offers students an experience-rich learning environment where health professionals approach patient health as part of a team. ASDOH is part of A.T. Still University, which also includes the Kirksville College of Osteopathic Medicine, Arizona School of Health Sciences, the College of Graduate Health Studies and the School of Osteopathic Medicine in Arizona.','Educate caring, technologically adept, community-responsive dentists who will seek lifelong learning.\rInculcate a strong foundation comprising critical inquiry, evidence-based practice, research and cultural competency.','The curriculum at the Arizona School of Dentistry & Oral Health is designed to produce graduates who are technologically adept, professionally competent, patient-centered and compassionate.\rThe curriculum emphasizes patient-care experiences through simulation, integration of biomedical and clinical sciences and problem-solving scenarios to achieve clinical excellence. The curriculum includes a strong component of public health, leadership and practice through weekly learning modules.\rStudents have the opportunity to interact with faculty, practicing dentists and national leaders to discuss cases in a regularly scheduled “grand rounds” format.','Yes','','M.P.H.','Private','2003','Semester','48','July','D.M.D.','300','76','Suburban','No','2017-02-01 03:49:20','2017-02-01 03:49:20'),(4,'Arizona','Midwestern University','College of Dental Medicine-Arizona','P. Bradford Smith, D.D.S., Dean','The College of Dental Medicine-Arizona is part of the Glendale, AZ, campus of Midwestern University, which was founded in 1900. The Glendale campus, situated on 146 acres, 15 miles northwest of downtown Phoenix, grew from a single building in 1996 to a full-service university with more than 34 buildings (covering 1,465,032 square feet) and more than 2,925 students. The Glendale campus comprises more than five colleges and 17 programs offering a variety of graduate degrees, including doctoral degree programs. The four-year ental curriculum leads to a D.M.D. degree. The College of Dental Medicine-Arizona graduated its first class in 2012.','Our mission is to graduate well-qualified general dentists and to improve oral health through research, scholarly activity and service to the public.\rOur core values are:\r• Maintaining a student-friendly environment.\r• Promoting ethics/professionalism.\r• Advocating collegiality and teamwork.\r• Focusing on a general dentistry curriculum.\r• Assuring competence for general practice.\r• Delivering comprehensive, patient-centered care.','The curriculum emphasizes integrated disciplines that both enhance learning and fully prepare students to practice general dentistry providing total patient care.\rThe basic science curriculum is organized by body systems, rather than by biomedical discipline, and spans five academic quarters. This systems-based approach, combined with clinical case studies, improves the learning experience for entry to patient care and prepares students for Part I of the National Dental Board Examination.\rThe preclinical curriculum is organized by tooth segments, rather than by dental disciplines. This highly integrated coursework spans six academic quarters of instruction in the simulation laboratory, emphasizing competency in a wide variety of clinical procedures. The coursework stresses patient simulation, technical quality, high efficiency and self-assessment. Students begin clinical care on a limited basis in the second year.\rThe foundation of the clinical curriculum in the third and fourth academic years rests in the practice of general dentistry organized in practice groups led by general dentist faculty members. This eight-quarter curriculum emphasizes comprehensive patient-centered care, competency of all students in a full range of patient care services, and practice management and efficiency.\rThe curriculum also prepares students for Part II of the National Board Dental Examination and clinical licensure examinations.','Yes','','No combined degree programs available.','Private','2008','Quarter','46','August','D.M.D.','560','140','Suburban','Yes','2017-02-01 03:49:20','2017-02-01 03:49:20'),(5,'California','Herman Ostrow School of Dentistry of USC','','Avishai Sadan, D.M.D., M.B.A., Dean','The Herman Ostrow School of Dentistry is a private institution founded in 1897. The schoolhas become recognized for the excellence of its faculty in the clinical disciplines. Indeed, many procedures and techniques used in everyday dental practice were originated by University of Southern California faculty members. Programs of the school include those leading to a D.D.S., a B.S. in dental hygiene, certificate programs in advanced (specialty) education and continuing education for the practicing dentist, the Advanced Standing Program for International Dentists for foreign dental school graduates and the graduate program in craniofacial biology leading to the M.S. or Ph.D. degree.','Our mission is to be dedicated to lifelong learning, flexibility and openness to new ideas, we are committed to improving the health of all through education and training, innovation and discovery.\rOur vision is to serve as global leaders in educational innovation, research, teaching and patient care; fostering collaborations locally, inationally and internationally. \rOur core values are to celebrate diversity, demonstrate empathy and respect for others, adhere to the highest standards of our profession, improve the dental, craniofacial and general health of our global communites.','The curricular goals are the following:\r1. To use student-centered, inquiry-based methods in all aspects of basic, preclinical and clinical science instruction throughout all four years that will encourage students to develop lifelong problem-solving and group learning skills.\r2. To encourage students to question materials presented and to develop a collegial interaction with the faculty—all areas of instruction occur in a professional atmosphere, and there is no activity that demeans students or creates an atmosphere in which student inquiry is repressed.\r3. To vertically integrate the curriculum so that all three sciences and clinical skills are organized to emphasize the direct relevance of basic science learning outcomes to clinical problems.\r4. To develop dental graduates who are:\r›› Dedicated to lifelong, self-motivated learning.\r›› Accomplished in the methods required to solve problems in a clinical setting.\r›› Able to effectively understand and respond to changes in the profession.','Yes','','Ph.D., M.S., B.A./B.S.','Private','1897','Trimester','40','August','D.D.S.','580','144','Urban','Yes','2017-02-01 03:49:20','2017-02-01 03:49:20'),(6,'California','Loma Linda University',' School of Dentistry','Ronald J. Dailey, Ph.D., Dean','Loma Linda University (LLU) represents distinction in quality Christian education. A private university owned and operated by the Seventh-Day Adventist Church, the university has established a reputation for leadership in mission service, clinical excellence, research and advancements in the health-related sciences. Located 60 miles from Los Angeles in one of the fastest growing areas nationwide, LLU comprises eight health science schools and has an annual enrollment of more than 4,500 students from more than 100 countries. The school offers eight advanced dental education programs and has 122 full-time faculty for an excellent student-faculty ratio of three to one. ','Our mission is to further the teaching and healing ministry of Jesus Christ: Students learn to provide high-quality oral health care based on sound biologic principles.\rOur vision is to be a preeminent health-care organization. We seek to represent God in all we do. We are committed to excellent, innovative, comprehensive student education and whole-person patient care.\rOur core values are belief in God; respect for the individual; principled spirituality; student-focused, empathetic care; commitment to service; pursuit of truth; progressive excellence; analytic thinking; and effective communication.','LLUSD’s program is a traditional dental curriculum with emphasis in clinical training. Graduates are skilled in providing quality dental care that is comprehensive in its scope and preventive in its goals.\r• Year 1: Basic sciences with introduction to clinical sciences.\r• Year 2: Applied sciences and introduction to clinical practice.\r• Year 3: Clinical sciences with extensive patient contact.\r• Year 4: Delivery of comprehensive dental care.','Yes','','Ph.D., M.P.H., M.S., B.A./B.S.','Private','1953','Quarter','45','August','D.D.S.','400','100','Suburban','Yes','2017-02-01 03:49:20','2017-02-01 03:49:20');
/*!40000 ALTER TABLE `schools` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `general_information`
--

/*!50001 DROP TABLE IF EXISTS `general_information`*/;
/*!50001 DROP VIEW IF EXISTS `general_information`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `general_information` AS (select `a`.`id` AS `id`,`a`.`state` AS `state`,`a`.`university` AS `university`,`a`.`school` AS `school`,`a`.`dean` AS `dean`,`a`.`general_information` AS `general_information`,`a`.`mission` AS `mission`,`c`.`curriculum` AS `curriculum`,`c`.`research_opportunities` AS `research_opportunities`,`c`.`research_types` AS `research_types`,`c`.`degree_programs` AS `degree_programs`,`f`.`type_of_institution` AS `type_of_institution`,`f`.`year_opened` AS `year_opened`,`f`.`term_type` AS `term_type`,`f`.`time_to_degree` AS `time_to_degree`,`f`.`start_month` AS `start_month`,`f`.`doctoral_degree` AS `doctoral_degree`,`f`.`targeted_predoctoral` AS `targeted_predoctoral`,`f`.`targeted_class_size` AS `targeted_class_size`,`f`.`campus_setting` AS `campus_setting`,`f`.`campus_housing` AS `campus_housing` from (`fast_facts` `f` left join (`curriculum` `c` left join `about` `a` on((`a`.`id` = `c`.`school_id`))) on((`a`.`id` = `f`.`school_id`)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-02-01 18:41:03
