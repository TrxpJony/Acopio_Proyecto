CREATE DATABASE  IF NOT EXISTS `acopio` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `acopio`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: acopio
-- ------------------------------------------------------
-- Server version	8.0.36

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
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
INSERT INTO `materiales` VALUES ('1876841851','104949123213','Taladro','devolutivo',5,'nuevo','taladro','amarillo','taladro.jpg'),('1877405367','454874163','bafle','devolutivo',1,'usado','para la music','negro','bafle.avif'),('1948288079','1465626974','cable HDMI','consumible',20,'nuevo','cable hdmi 3.0','negro','hdmi.jpg'),('m004','101001142467','Kit estudiante-Arduino','devolutivo',249,'nuevo','1-Placa arduino UNO R3          1- cable UBS (im)    1-Base de  plastico facil de emsablar para sostener la placa                  1- Multimetro            1-Conector clip sin conector de pila 9v   1- Pila 9v     20- 5mm LEDs (varios colores)    5-Resistores(560Ω)       5-Resistores(220Ω)        1- placa de protipado       1-resistor (1kΩ)   1-resistor (10kΩ)   1-servomotor pequeño                                       2-potenciometros(10Ω)          2-perillas para potenciometros                       2 -condesadores(100uF)        5-botones pulsadores          1-piezo 1-fototransitor           2-resistores(4.7KΩ)                          1-cable de conexion con puntas (negro)                                         1-cable de conexion con puntas (rojo)                              1-sensor de temperatura         1-cable de conexion20cm  hembra-macho(rojo)                1-cable de conexion20cm  hembra-macho(negro)  3-sets de tornillos y tuercos M3','verde','arduino.jpg'),('m005','','Pulidora','devolutivo',1,'usado','Pulidora angular 4-1/2 pulg, 820W, 6 amperes, velocidad: 11000/min (rpm)','naranja','pulidora.jpg'),('MAT003','1234564','Material Prueba3','consumible',100,'nuevo','Este es un material de prueba.','azul','imagenprueb2a.jpg');
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
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `peticion_detalle`
--

LOCK TABLES `peticion_detalle` WRITE;
/*!40000 ALTER TABLE `peticion_detalle` DISABLE KEYS */;
INSERT INTO `peticion_detalle` VALUES (1,'P001','m004',1),(2,'P001','m005',1),(4,'P001','M004',2),(5,'P001','M005',1),(14,'P1732735355626','1877405367',1),(15,'P1732735477274','m005',1),(16,'P1732735477274','1876841851',1),(18,'P1732735648559','1948288079',1),(19,'P1732735699680','m004',1),(20,'P1732742838622','1877405367',1),(21,'P1732742838622','1948288079',1),(23,'P1732830306970','1876841851',1),(24,'P1732830306970','1948288079',1),(25,'P1732830306970','1877405367',1),(26,'P1733324433272','1876841851',1),(27,'P1733326577494','1877405367',1),(28,'P1733326577494','m005',1),(29,'P1733326577494','1876841851',1),(30,'P1733329150959','1948288079',1),(31,'P1733329150959','1877405367',1);
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
  `fecha_peticion` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de la petición',
  `fecha_devolucion` datetime DEFAULT NULL COMMENT 'Fecha de devolución seleccionada por el usuario',
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
INSERT INTO `peticiones` VALUES ('P001',1,'Juan','1234567890','Pendiente','2024-12-03 18:55:07',NULL),('P1732735355626',1860331151,'david','3006560988','Aceptado','2024-12-03 18:55:07',NULL),('P1732735477274',1989865911,'jony','3006130984','Aceptado','2024-12-03 18:55:07',NULL),('P1732735648559',1989865911,'jony','3006130984','Pendiente','2024-12-03 18:55:07',NULL),('P1732735699680',1989865911,'jony','3006130984','Pendiente','2024-12-03 18:55:07',NULL),('P1732742838622',1860331151,'david','3006560988','Aceptado','2024-12-03 18:55:07',NULL),('P1732830306970',1948187608,'brenda','3256984411','Aceptado','2024-12-03 18:55:07',NULL),('P1733324433272',3265936564,'vega','3006130984','Pendiente','2024-12-04 15:00:33','2024-12-05 00:00:00'),('P1733326577494',3265936564,'vega','3006130984','Aceptado','2024-12-04 15:36:17','2024-12-10 00:00:00'),('P1733329150959',3265936564,'vega','3006130984','Pendiente','2024-12-04 16:19:10','2024-12-06 00:00:00');
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
INSERT INTO `usuarios` VALUES (1,'usuario123@example.com','12345678','Juan',1234567890,'instructor'),(1813254292,'jodavelo3040@gmail.com','7ea0e6fa695034bff007a29c25273e53','Jonathan',3006130984,'administrador'),(1860331151,'david@gmail.com','5e8667a439c68f5145dd2fcbecf02209','david',3006560988,'instructor'),(1948187608,'bren@gmail.com','545c1d133d8eac625526bfef0088c323','brenda',3256984411,'instructor'),(1989689682,'estebanvargas29@hotmail.com','7ea0e6fa695034bff007a29c25273e53','Esteban',3215689456,'instructor'),(1989865911,'jonypasra@gmail.com','7ea0e6fa695034bff007a29c25273e53','jony',3006130984,'instructor'),(3265936564,'jdvega074@soy.sena.edu.co','6bcd3b64337dd5e78112a26bf20017ef','vega',3006130984,'instructor');
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

-- Dump completed on 2024-12-04 12:29:36
