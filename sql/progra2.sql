SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `bodega` ;
CREATE SCHEMA IF NOT EXISTS `bodega` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
DROP SCHEMA IF EXISTS `produccion` ;
CREATE SCHEMA IF NOT EXISTS `produccion` ;
USE `bodega` ;

-- -----------------------------------------------------
-- Table `bodega`.`proveedores`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bodega`.`proveedores` ;

CREATE TABLE IF NOT EXISTS `bodega`.`proveedores` (
  `idproveedores` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion` TEXT NOT NULL,
  PRIMARY KEY (`idproveedores`))
ENGINE = InnoDB
COMMENT = 'proveedores de materias primas\n	';


-- -----------------------------------------------------
-- Table `bodega`.`materiales`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bodega`.`materiales` ;

CREATE TABLE IF NOT EXISTS `bodega`.`materiales` (
  `idmateriales` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `precio` DECIMAL(10,2) NOT NULL,
  `medida` VARCHAR(45) NOT NULL,
  `cantidad` INT UNSIGNED NOT NULL,
  `categoria` VARCHAR(45) NOT NULL,
  `familia` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idmateriales`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bodega`.`departamento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bodega`.`departamento` ;

CREATE TABLE IF NOT EXISTS `bodega`.`departamento` (
  `iddepartamento` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion` TEXT NOT NULL,
  PRIMARY KEY (`iddepartamento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bodega`.`empleado`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bodega`.`empleado` ;

CREATE TABLE IF NOT EXISTS `bodega`.`empleado` (
  `idempleado` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido` VARCHAR(45) NOT NULL,
  `cargo` VARCHAR(45) NOT NULL,
  `iddepartamento` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idempleado`),
  INDEX `fk_empleado_1_idx` (`iddepartamento` ASC),
  CONSTRAINT `fk_empleado_1`
    FOREIGN KEY (`iddepartamento`)
    REFERENCES `bodega`.`departamento` (`iddepartamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bodega`.`ordenes_de_compra`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bodega`.`ordenes_de_compra` ;

CREATE TABLE IF NOT EXISTS `bodega`.`ordenes_de_compra` (
  `idordenes` INT UNSIGNED NOT NULL,
  `idproveedores` INT UNSIGNED NOT NULL,
  `fecha` TIMESTAMP NOT NULL,
  `encargado` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idordenes`),
  INDEX `fk_ordenes_de_compra_1_idx` (`idproveedores` ASC),
  INDEX `fk_ordenes_de_compra_2_idx` (`encargado` ASC),
  CONSTRAINT `fk_ordenes_de_compra_1`
    FOREIGN KEY (`idproveedores`)
    REFERENCES `bodega`.`proveedores` (`idproveedores`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ordenes_de_compra_2`
    FOREIGN KEY (`encargado`)
    REFERENCES `bodega`.`empleado` (`idempleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bodega`.`detalle_orden`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bodega`.`detalle_orden` ;

CREATE TABLE IF NOT EXISTS `bodega`.`detalle_orden` (
  `iddetalle` INT UNSIGNED NOT NULL,
  `idordenes` INT UNSIGNED NOT NULL,
  `cantidad` INT UNSIGNED NOT NULL,
  `idmateriales` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`iddetalle`, `idordenes`),
  INDEX `fk_detalle_orden_1_idx` (`idordenes` ASC),
  INDEX `fk_detalle_orden_2_idx` (`idmateriales` ASC),
  CONSTRAINT `fk_detalle_orden_1`
    FOREIGN KEY (`idordenes`)
    REFERENCES `bodega`.`ordenes_de_compra` (`idordenes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_detalle_orden_2`
    FOREIGN KEY (`idmateriales`)
    REFERENCES `bodega`.`materiales` (`idmateriales`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bodega`.`salida_de_bodega`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bodega`.`salida_de_bodega` ;

CREATE TABLE IF NOT EXISTS `bodega`.`salida_de_bodega` (
  `idsalida` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `fecha` TIMESTAMP NOT NULL,
  `encargado` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idsalida`),
  INDEX `fk_salida_de_bodega_1_idx` (`encargado` ASC),
  CONSTRAINT `fk_salida_de_bodega_1`
    FOREIGN KEY (`encargado`)
    REFERENCES `bodega`.`empleado` (`idempleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bodega`.`detalle_salida`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bodega`.`detalle_salida` ;

CREATE TABLE IF NOT EXISTS `bodega`.`detalle_salida` (
  `iddetalle_salida` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idsalida` INT UNSIGNED NOT NULL,
  `cantidad` INT UNSIGNED NOT NULL,
  `idmateriales` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`iddetalle_salida`, `idsalida`),
  INDEX `fk_detalle_salida_1_idx` (`idmateriales` ASC),
  INDEX `fk_detalle_salida_2_idx` (`idsalida` ASC),
  CONSTRAINT `fk_detalle_salida_1`
    FOREIGN KEY (`idmateriales`)
    REFERENCES `bodega`.`materiales` (`idmateriales`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_detalle_salida_2`
    FOREIGN KEY (`idsalida`)
    REFERENCES `bodega`.`salida_de_bodega` (`idsalida`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bodega`.`devoluciones`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bodega`.`devoluciones` ;

CREATE TABLE IF NOT EXISTS `bodega`.`devoluciones` (
  `iddevoluciones` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idordenes` INT UNSIGNED NOT NULL,
  `motivo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`iddevoluciones`),
  INDEX `fk_devoluciones_1_idx` (`idordenes` ASC),
  CONSTRAINT `fk_devoluciones_1`
    FOREIGN KEY (`idordenes`)
    REFERENCES `bodega`.`ordenes_de_compra` (`idordenes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bodega`.`pagos_proveedores`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bodega`.`pagos_proveedores` ;

CREATE TABLE IF NOT EXISTS `bodega`.`pagos_proveedores` (
  `idpagos` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idordenes` INT UNSIGNED NOT NULL,
  `fecha` TIMESTAMP NOT NULL,
  `idempleado` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idpagos`),
  INDEX `fk_pagos_proveedores_1_idx` (`idordenes` ASC),
  INDEX `fk_pagos_proveedores_2_idx` (`idempleado` ASC),
  CONSTRAINT `fk_pagos_proveedores_1`
    FOREIGN KEY (`idordenes`)
    REFERENCES `bodega`.`ordenes_de_compra` (`idordenes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pagos_proveedores_2`
    FOREIGN KEY (`idempleado`)
    REFERENCES `bodega`.`empleado` (`idempleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `produccion` ;

-- -----------------------------------------------------
-- Table `produccion`.`productos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `produccion`.`productos` ;

CREATE TABLE IF NOT EXISTS `produccion`.`productos` (
  `idproductos` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `numero_parte` INT UNSIGNED NOT NULL,
  `descripcion` TEXT NOT NULL,
  `manual` VARCHAR(45) NOT NULL,
  `archivos_digitales` VARCHAR(80) NOT NULL,
  `info_adicional` TEXT NULL,
  `cantiadad` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idproductos`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `produccion`.`clientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `produccion`.`clientes` ;

CREATE TABLE IF NOT EXISTS `produccion`.`clientes` (
  `idclientes` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido` VARCHAR(45) NOT NULL,
  `cedula` VARCHAR(45) NOT NULL,
  `localizacion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idclientes`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `produccion`.`precios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `produccion`.`precios` ;

CREATE TABLE IF NOT EXISTS `produccion`.`precios` (
  `idprecios` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idproductos` INT UNSIGNED NOT NULL,
  `precio` INT UNSIGNED NOT NULL,
  `fecha` TIMESTAMP NOT NULL,
  PRIMARY KEY (`idprecios`, `idproductos`),
  INDEX `fk_precios_1_idx` (`idproductos` ASC),
  CONSTRAINT `fk_precios_1`
    FOREIGN KEY (`idproductos`)
    REFERENCES `produccion`.`productos` (`idproductos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `produccion`.`ventas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `produccion`.`ventas` ;

CREATE TABLE IF NOT EXISTS `produccion`.`ventas` (
  `idventas` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idclientes` INT UNSIGNED NOT NULL,
  `fecha` TIMESTAMP NOT NULL,
  PRIMARY KEY (`idventas`),
  INDEX `fk_ventas_1_idx` (`idclientes` ASC),
  CONSTRAINT `fk_ventas_1`
    FOREIGN KEY (`idclientes`)
    REFERENCES `produccion`.`clientes` (`idclientes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `produccion`.`detalle_ventas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `produccion`.`detalle_ventas` ;

CREATE TABLE IF NOT EXISTS `produccion`.`detalle_ventas` (
  `iddetalle_ventas` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idventas` INT UNSIGNED NOT NULL,
  `cantidad` INT UNSIGNED NOT NULL,
  `idproductos` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`iddetalle_ventas`, `idventas`),
  INDEX `fk_detalle_ventas_1_idx` (`idventas` ASC),
  CONSTRAINT `fk_detalle_ventas_1`
    FOREIGN KEY (`idventas`)
    REFERENCES `produccion`.`ventas` (`idventas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_detalle_ventas_2`
    FOREIGN KEY (`idproductos`)
    REFERENCES `produccion`.`productos` (`idproductos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE `bodega`;

DELIMITER $$

USE `bodega`$$
DROP TRIGGER IF EXISTS `bodega`.`entrada_material` $$
USE `bodega`$$
CREATE TRIGGER `entrada_material` 
AFTER INSERT ON `detalle_orden` FOR EACH ROW
BEGIN
	UPDATE materiales
	SET materiales.cantidad = materiales.cantidad + (SELECT cantidad FROM detalle_orden ORDER BY iddetalle, idordenes DESC LIMIT 1)
	WHERE materiales.idmateriales = (SELECT idmateriales FROM detalle_orden ORDER BY iddetalle, idordenes DESC LIMIT 1);
END
$$


USE `bodega`$$
DROP TRIGGER IF EXISTS `bodega`.`salida_material` $$
USE `bodega`$$
CREATE TRIGGER `salida_material` 
AFTER INSERT ON `detalle_salida` FOR EACH ROW
BEGIN
	UPDATE materiales
	SET materiales.cantidad = materiales.cantidad - detalle_salida.cantidad
	WHERE detalle_salida.iddetalle_salida = NEW.iddetalle_salida;
END
$$


DELIMITER ;
USE `produccion`;

DELIMITER $$

USE `produccion`$$
DROP TRIGGER IF EXISTS `produccion`.`agregar_cantidad` $$
USE `produccion`$$
CREATE TRIGGER `agregar_cantidad` 
AFTER INSERT ON `productos` FOR EACH ROW 
BEGIN	
	UPDATE productos
		SET productos.cantidad = productos.cantidad + 1
		WHERE productos.idproductos = NEW.idproductos;
END$$


USE `produccion`$$
DROP TRIGGER IF EXISTS `produccion`.`quitar_productos` $$
USE `produccion`$$
CREATE TRIGGER `quitar_productos` 
AFTER INSERT ON `detalle_ventas` FOR EACH ROW
BEGIN 
	UPDATE productos
	SET productos.cantidad = productos.cantidad - detalle_ventas.cantidad
	WHERE detalle_ventas.iddetalle_ventas = new.iddetalle_ventas;
END$$


DELIMITER ;
