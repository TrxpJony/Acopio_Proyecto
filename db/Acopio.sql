CREATE DATABASE  IF NOT EXISTS `acopio` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `acopio`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: acopio
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `carrito`
--

DROP TABLE IF EXISTS `carrito`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carrito` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` bigint DEFAULT NULL,
  `material_id` varchar(10) NOT NULL,
  `cantidad` int NOT NULL,
  `fecha_agregado` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `material_id` (`material_id`),
  KEY `carrito_ibfk_1` (`usuario_id`),
  CONSTRAINT `carrito_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `carrito_ibfk_2` FOREIGN KEY (`material_id`) REFERENCES `materiales` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carrito`
--

LOCK TABLES `carrito` WRITE;
/*!40000 ALTER TABLE `carrito` DISABLE KEYS */;
INSERT INTO `carrito` VALUES (1,1,'m004',1,'2024-11-24 17:44:53'),(2,1,'m005',1,'2024-11-24 17:44:55'),(16,1989865911,'1877405367',1,'2024-11-27 14:30:01');
/*!40000 ALTER TABLE `carrito` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devoluciondetalle`
--

DROP TABLE IF EXISTS `devoluciondetalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `devoluciondetalle` (
  `id` varchar(10) NOT NULL,
  `cantidad` int DEFAULT NULL,
  `descripcion` text,
  `material_id` varchar(10) DEFAULT NULL,
  `usuario_id` bigint DEFAULT NULL,
  `nombre_usuario` varchar(100) DEFAULT NULL,
  `numero_telefono` varchar(15) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_material` (`material_id`),
  KEY `devoluciondetalle_ibfk_1` (`usuario_id`),
  CONSTRAINT `devoluciondetalle_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `fk_material` FOREIGN KEY (`material_id`) REFERENCES `materiales` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devoluciondetalle`
--

LOCK TABLES `devoluciondetalle` WRITE;
/*!40000 ALTER TABLE `devoluciondetalle` DISABLE KEYS */;
/*!40000 ALTER TABLE `devoluciondetalle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `materiales`
--

DROP TABLE IF EXISTS `materiales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `materiales` (
  `id` varchar(10) NOT NULL,
  `identificador` varchar(15) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `tipo` varchar(50) DEFAULT NULL,
  `cantidad_disponible` int DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL,
  `descripcion` text,
  `color` varchar(50) DEFAULT NULL,
  `img` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `materiales`
--

LOCK TABLES `materiales` WRITE;
/*!40000 ALTER TABLE `materiales` DISABLE KEYS */;
INSERT INTO `materiales` VALUES ('1876841851','104949123213','Taladro','devolutivo',0,'nuevo','taladro','amarillo','taladro.jpg'),('1877405367','454874163','bafle','devolutivo',4,'usado','para la music','negro','bafle.avif'),('1948288079','1465626974','cable HDMI','consumible',18,'nuevo','cable hdmi 3.0','negro','hdmi.jpg'),('2887682962','123151515','prueba','consumible',9,'nuevo','nuevo huevo','negro','DALL·E 2024-11-28 15.31.55 - A vertical activity diagram for a system managing inventory and material loans for instructors at SENA, titled \'Centro de Acopio\'. The background is g.webp'),('m004','101001142467','Kit estudiante-Arduino','devolutivo',242,'nuevo','1-Placa arduino UNO R3          1- cable UBS (im)    1-Base de  plastico facil de emsablar para sostener la placa                  1- Multimetro            1-Conector clip sin conector de pila 9v   1- Pila 9v     20- 5mm LEDs (varios colores)    5-Resistores(560Ω)       5-Resistores(220Ω)        1- placa de protipado       1-resistor (1kΩ)   1-resistor (10kΩ)   1-servomotor pequeño                                       2-potenciometros(10Ω)          2-perillas para potenciometros                       2 -condesadores(100uF)        5-botones pulsadores          1-piezo 1-fototransitor           2-resistores(4.7KΩ)                          1-cable de conexion con puntas (negro)                                         1-cable de conexion con puntas (rojo)                              1-sensor de temperatura         1-cable de conexion20cm  hembra-macho(rojo)                1-cable de conexion20cm  hembra-macho(negro)  3-sets de tornillos y tuercos M3','verde','arduino.jpg'),('m005','984651073','Pulidora','devolutivo',21,'usado','Pulidora angular 4-1/2 pulg, 820W, 6 amperes, velocidad: 11000/min (rpm)','naranja','pulidora.jpg'),('MAT003','1234564','Material Prueba3','consumible',100,'nuevo','Este es un material de prueba.','azul','imagenprueb2a.jpg');
/*!40000 ALTER TABLE `materiales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `peticion_detalle`
--

DROP TABLE IF EXISTS `peticion_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `peticion_detalle` (
  `id` int NOT NULL AUTO_INCREMENT,
  `peticion_id` varchar(15) DEFAULT NULL,
  `material_id` varchar(10) NOT NULL,
  `cantidad` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `peticion_id` (`peticion_id`),
  KEY `material_id` (`material_id`),
  CONSTRAINT `peticion_detalle_ibfk_1` FOREIGN KEY (`peticion_id`) REFERENCES `peticiones` (`id`),
  CONSTRAINT `peticion_detalle_ibfk_2` FOREIGN KEY (`material_id`) REFERENCES `materiales` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `peticion_detalle`
--

LOCK TABLES `peticion_detalle` WRITE;
/*!40000 ALTER TABLE `peticion_detalle` DISABLE KEYS */;
INSERT INTO `peticion_detalle` VALUES (1,'P001','m004',1),(2,'P001','m005',1),(4,'P001','M004',2),(5,'P001','M005',1),(14,'P1732735355626','1877405367',1),(15,'P1732735477274','m005',1),(16,'P1732735477274','1876841851',1),(18,'P1732735648559','1948288079',1),(19,'P1732735699680','m004',1),(20,'P1732742838622','1877405367',1),(21,'P1732742838622','1948288079',1),(23,'P1732830306970','1876841851',1),(24,'P1732830306970','1948288079',1),(25,'P1732830306970','1877405367',1),(26,'P1732836759278','m005',1),(27,'P1732881166925','1876841851',1),(28,'P1732881166925','1876841851',1),(29,'P1732881166925','m004',5),(30,'P1732881166925','m004',1),(47,'P1732893256606','1877405367',1),(48,'P1732893256606','1876841851',1),(50,'P1733183110246','1876841851',1),(51,'P1733183157251','1876841851',1),(52,'P1733183389491','1876841851',1),(53,'P1733184146096','1876841851',1),(54,'P1733184597996','1876841851',1),(55,'P1733184832425','1876841851',1),(56,'P1733186472731','1876841851',1),(57,'P1733187786834','1876841851',1),(58,'P1733187893179','1877405367',1);
/*!40000 ALTER TABLE `peticion_detalle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `peticiones`
--

DROP TABLE IF EXISTS `peticiones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `peticiones` (
  `id` varchar(20) NOT NULL,
  `usuario_id` bigint DEFAULT NULL,
  `nombre_usuario` varchar(100) DEFAULT NULL,
  `numero_telefono` varchar(15) DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `peticiones_ibfk_1` (`usuario_id`),
  CONSTRAINT `peticiones_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `peticiones`
--

LOCK TABLES `peticiones` WRITE;
/*!40000 ALTER TABLE `peticiones` DISABLE KEYS */;
INSERT INTO `peticiones` VALUES ('P001',1,'Juan','1234567890','Pendiente'),('P1732735355626',1860331151,'david','3006560988','Aceptado'),('P1732735477274',1989865911,'jony','3006130984','Aceptado'),('P1732735648559',1989865911,'jony','3006130984','Pendiente'),('P1732735699680',1989865911,'jony','3006130984','Pendiente'),('P1732742838622',1860331151,'david','3006560988','Aceptado'),('P1732830306970',1948187608,'brenda','3256984411','Aceptado'),('P1732836759278',1860331151,'david','3006560988','Pendiente'),('P1732881166925',1860331151,'david','3006560988','Pendiente'),('P1732881168404',1860331151,'david','3006560988','Pendiente'),('P1732881173843',1860331151,'david','3006560988','Pendiente'),('P1732881183666',1860331151,'david','3006560988','Pendiente'),('P1732893256606',2893048472,'carolina forero','3202443456','Aceptado'),('P1733183110246',1860331151,'david','3006560988','Pendiente'),('P1733183119881',1860331151,'david','3006560988','Pendiente'),('P1733183157251',1860331151,'david','3006560988','Pendiente'),('P1733183158228',1860331151,'david','3006560988','Pendiente'),('P1733183389491',1860331151,'david','3006560988','Pendiente'),('P1733183390672',1860331151,'david','3006560988','Pendiente'),('P1733183397074',1860331151,'david','3006560988','Pendiente'),('P1733183398379',1860331151,'david','3006560988','Pendiente'),('P1733183398470',1860331151,'david','3006560988','Pendiente'),('P1733183398865',1860331151,'david','3006560988','Pendiente'),('P1733183413333',1860331151,'david','3006560988','Pendiente'),('P1733183413536',1860331151,'david','3006560988','Pendiente'),('P1733183413747',1860331151,'david','3006560988','Pendiente'),('P1733183413904',1860331151,'david','3006560988','Pendiente'),('P1733183414917',1860331151,'david','3006560988','Pendiente'),('P1733183415011',1860331151,'david','3006560988','Pendiente'),('P1733183415402',1860331151,'david','3006560988','Pendiente'),('P1733183415978',1860331151,'david','3006560988','Pendiente'),('P1733183416651',1860331151,'david','3006560988','Pendiente'),('P1733183416958',1860331151,'david','3006560988','Pendiente'),('P1733183417527',1860331151,'david','3006560988','Pendiente'),('P1733183417771',1860331151,'david','3006560988','Pendiente'),('P1733183419059',1860331151,'david','3006560988','Pendiente'),('P1733183419693',1860331151,'david','3006560988','Pendiente'),('P1733183420342',1860331151,'david','3006560988','Pendiente'),('P1733183420624',1860331151,'david','3006560988','Pendiente'),('P1733183421493',1860331151,'david','3006560988','Pendiente'),('P1733183422414',1860331151,'david','3006560988','Pendiente'),('P1733183422869',1860331151,'david','3006560988','Pendiente'),('P1733183423224',1860331151,'david','3006560988','Pendiente'),('P1733183423886',1860331151,'david','3006560988','Pendiente'),('P1733183424326',1860331151,'david','3006560988','Pendiente'),('P1733183424996',1860331151,'david','3006560988','Pendiente'),('P1733183425799',1860331151,'david','3006560988','Pendiente'),('P1733183426495',1860331151,'david','3006560988','Pendiente'),('P1733183427306',1860331151,'david','3006560988','Pendiente'),('P1733183428002',1860331151,'david','3006560988','Pendiente'),('P1733183428759',1860331151,'david','3006560988','Pendiente'),('P1733183429077',1860331151,'david','3006560988','Pendiente'),('P1733183429920',1860331151,'david','3006560988','Pendiente'),('P1733183430393',1860331151,'david','3006560988','Pendiente'),('P1733183430916',1860331151,'david','3006560988','Pendiente'),('P1733183431255',1860331151,'david','3006560988','Pendiente'),('P1733183431577',1860331151,'david','3006560988','Pendiente'),('P1733183432313',1860331151,'david','3006560988','Pendiente'),('P1733183432738',1860331151,'david','3006560988','Pendiente'),('P1733183433198',1860331151,'david','3006560988','Pendiente'),('P1733183433959',1860331151,'david','3006560988','Pendiente'),('P1733183434752',1860331151,'david','3006560988','Pendiente'),('P1733183435165',1860331151,'david','3006560988','Pendiente'),('P1733183435973',1860331151,'david','3006560988','Pendiente'),('P1733183436389',1860331151,'david','3006560988','Pendiente'),('P1733183436779',1860331151,'david','3006560988','Pendiente'),('P1733183437301',1860331151,'david','3006560988','Pendiente'),('P1733183437677',1860331151,'david','3006560988','Pendiente'),('P1733183438015',1860331151,'david','3006560988','Pendiente'),('P1733183438768',1860331151,'david','3006560988','Pendiente'),('P1733183439530',1860331151,'david','3006560988','Pendiente'),('P1733183440314',1860331151,'david','3006560988','Pendiente'),('P1733184146096',1860331151,'david','3006560988','Pendiente'),('P1733184597996',1860331151,'david','3006560988','Pendiente'),('P1733184599140',1860331151,'david','3006560988','Pendiente'),('P1733184599237',1860331151,'david','3006560988','Pendiente'),('P1733184599478',1860331151,'david','3006560988','Pendiente'),('P1733184832425',1860331151,'david','3006560988','Pendiente'),('P1733184832937',1860331151,'david','3006560988','Pendiente'),('P1733184833007',1860331151,'david','3006560988','Pendiente'),('P1733186472731',1860331151,'david','3006560988','Pendiente'),('P1733186482352',1860331151,'david','3006560988','Pendiente'),('P1733186483718',1860331151,'david','3006560988','Pendiente'),('P1733186483822',1860331151,'david','3006560988','Pendiente'),('P1733187786834',1860331151,'david','3006560988','Pendiente'),('P1733187792731',1860331151,'david','3006560988','Pendiente'),('P1733187893179',1860331151,'david','3006560988','Pendiente'),('P1733187893271',1860331151,'david','3006560988','Pendiente');
/*!40000 ALTER TABLE `peticiones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id` bigint NOT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `contraseña` varchar(255) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `telefono` bigint DEFAULT NULL,
  `rol` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'usuario123@example.com','12345678','Juan',1234567890,'instructor'),(1813254292,'jodavelo3040@gmail.com','7ea0e6fa695034bff007a29c25273e53','Jonathan',3006130984,'administrador'),(1860331151,'david@gmail.com','5e8667a439c68f5145dd2fcbecf02209','david',3006560988,'instructor'),(1948187608,'bren@gmail.com','545c1d133d8eac625526bfef0088c323','brenda',3256984411,'instructor'),(1989689682,'estebanvargas29@hotmail.com','7ea0e6fa695034bff007a29c25273e53','Esteban',3215689456,'instructor'),(1989865911,'jonypasra@gmail.com','7ea0e6fa695034bff007a29c25273e53','jony',3006130984,'instructor'),(2882035600,'david1011jimenez@gmail.com','7ea0e6fa695034bff007a29c25273e53','Santiago',3043350702,'administrador'),(2882172516,'juaaley250@gmail.com','7ea0e6fa695034bff007a29c25273e53','sebastian',3098765467,'instructor'),(2893048472,'cfsanchez@sena.edu.co','ebcab5bb9a9fe0396594d4b8f147e127','carolina forero',3202443456,'instructor'),(2939431673,'Gtorres@soy.sena.edu.co','7ea0e6fa695034bff007a29c25273e53','Gustavo Torres',3017303456,'instructor');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-03  8:02:06
