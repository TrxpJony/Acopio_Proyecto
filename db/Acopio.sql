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
  `usuario_id` varchar(10) DEFAULT NULL,
  `nombre_usuario` varchar(100) DEFAULT NULL,
  `numero_telefono` varchar(15) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`),
  KEY `fk_material` (`material_id`),
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
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `sumar_cantidad_material` AFTER INSERT ON `devoluciondetalle` FOR EACH ROW BEGIN
    -- Actualizar la cantidad disponible del material
    UPDATE materiales
    SET cantidad_disponible = cantidad_disponible + NEW.cantidad
    WHERE id = (SELECT material_id FROM peticiones WHERE usuario_id = NEW.usuario_id LIMIT 1);
    -- Actualizar el estado de la petición a 'finalizado'
    UPDATE peticiones
    SET estado = 'finalizado'
    WHERE usuario_id = NEW.usuario_id
    AND material_id = (SELECT material_id FROM peticiones WHERE usuario_id = NEW.usuario_id LIMIT 1)
    AND estado != 'finalizado';  -- Solo actualizar si el estado no es ya 'finalizado'
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
INSERT INTO `materiales` VALUES ('1876841851','104949123213','Taladro','devolutivo',1,'nuevo','taladro','amarillo','taladro.jpg'),('1877405367','454874163','bafle','devolutivo',1,'usado','para la music','negro','bafle.avif'),('1948288079','1465626974','cable HDMI','consumible',20,'nuevo','cable hdmi 3.0','negro','hdmi.jpg'),('m004','101001142467','Kit estudiante-Arduino','devolutivo',249,'nuevo','1-Placa arduino UNO R3          1- cable UBS (im)    1-Base de  plastico facil de emsablar para sostener la placa                  1- Multimetro            1-Conector clip sin conector de pila 9v   1- Pila 9v     20- 5mm LEDs (varios colores)    5-Resistores(560Ω)       5-Resistores(220Ω)        1- placa de protipado       1-resistor (1kΩ)   1-resistor (10kΩ)   1-servomotor pequeño                                       2-potenciometros(10Ω)          2-perillas para potenciometros                       2 -condesadores(100uF)        5-botones pulsadores          1-piezo 1-fototransitor           2-resistores(4.7KΩ)                          1-cable de conexion con puntas (negro)                                         1-cable de conexion con puntas (rojo)                              1-sensor de temperatura         1-cable de conexion20cm  hembra-macho(rojo)                1-cable de conexion20cm  hembra-macho(negro)  3-sets de tornillos y tuercos M3','verde','arduino.jpg'),('m005','','Pulidora','devolutivo',1,'usado','Pulidora angular 4-1/2 pulg, 820W, 6 amperes, velocidad: 11000/min (rpm)','naranja','pulidora.jpg');
/*!40000 ALTER TABLE `materiales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `peticiones`
--

DROP TABLE IF EXISTS `peticiones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `peticiones` (
  `id` varchar(10) NOT NULL,
  `usuario_id` varchar(10) DEFAULT NULL,
  `nombre_usuario` varchar(100) DEFAULT NULL,
  `numero_telefono` varchar(15) DEFAULT NULL,
  `entrega_aproximada` date DEFAULT NULL,
  `devolucion_aproximada` date DEFAULT NULL,
  `material_id` varchar(10) DEFAULT NULL,
  `cantidad` int DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`),
  KEY `material_id` (`material_id`),
  CONSTRAINT `peticiones_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `peticiones_ibfk_2` FOREIGN KEY (`material_id`) REFERENCES `materiales` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `peticiones`
--

LOCK TABLES `peticiones` WRITE;
/*!40000 ALTER TABLE `peticiones` DISABLE KEYS */;
/*!40000 ALTER TABLE `peticiones` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `descontar_cantidad_material` AFTER INSERT ON `peticiones` FOR EACH ROW BEGIN
    UPDATE materiales
    SET cantidad_disponible = cantidad_disponible - NEW.cantidad
    WHERE id = NEW.material_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id` varchar(10) NOT NULL,
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
INSERT INTO `usuarios` VALUES ('001','usuario123@example.com','password123','Juan',1234567890,'instructor'),('1813254292','jodavelo3040@gmail.com','7ea0e6fa695034bff007a29c25273e53','Jonathan',3006130984,'administrador'),('1860331151','david@gmail.com','7ea0e6fa695034bff007a29c25273e53','david',3006560988,'instructor'),('1948187608','bren@gmail.com','7ea0e6fa695034bff007a29c25273e53','brenda',3256984411,'instructor'),('1989689682','estebanvargas29@hotmail.com','7ea0e6fa695034bff007a29c25273e53','Esteban',3215689456,'instructor'),('1989865911','jonypasra@gmail.com','7ea0e6fa695034bff007a29c25273e53','jony',3006130984,'instructor'),('q001','ayuda@example.com','password123','Julio',1234567890,'instructor'),('u003','pedro@example.com','123456','Pedro Martínez',NULL,'instructor'),('u004','prueba@example.com','12345678','prueba',NULL,'instructor'),('u005','a2@example.com','12345678','prue2',NULL,'instructor'),('u006','admin@example.com','12345678','admin',NULL,'adminitrador'),('u007','admin1@example.com','12345678','admin1',NULL,'administrador');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'acopio'
--

--
-- Dumping routines for database 'acopio'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-18 23:48:37
