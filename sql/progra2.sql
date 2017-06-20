SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `bodega` ;
CREATE SCHEMA IF NOT EXISTS `bodega` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
DROP SCHEMA IF EXISTS `produccion` ;
CREATE SCHEMA IF NOT EXISTS `produccion` ;
DROP SCHEMA IF EXISTS `iot` ;
CREATE SCHEMA IF NOT EXISTS `iot` ;
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
  CONSTRAINT `fk_empleado_1`
    FOREIGN KEY (`iddepartamento`)
    REFERENCES `bodega`.`departamento` (`iddepartamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_empleado_1_idx` ON `bodega`.`empleado` (`iddepartamento` ASC);


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

CREATE INDEX `fk_ordenes_de_compra_1_idx` ON `bodega`.`ordenes_de_compra` (`idproveedores` ASC);

CREATE INDEX `fk_ordenes_de_compra_2_idx` ON `bodega`.`ordenes_de_compra` (`encargado` ASC);


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

CREATE INDEX `fk_detalle_orden_1_idx` ON `bodega`.`detalle_orden` (`idordenes` ASC);

CREATE INDEX `fk_detalle_orden_2_idx` ON `bodega`.`detalle_orden` (`idmateriales` ASC);


-- -----------------------------------------------------
-- Table `bodega`.`salida_de_bodega`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bodega`.`salida_de_bodega` ;

CREATE TABLE IF NOT EXISTS `bodega`.`salida_de_bodega` (
  `idsalida` INT UNSIGNED NOT NULL,
  `fecha` TIMESTAMP NOT NULL,
  `encargado` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idsalida`),
  CONSTRAINT `fk_salida_de_bodega_1`
    FOREIGN KEY (`encargado`)
    REFERENCES `bodega`.`empleado` (`idempleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_salida_de_bodega_1_idx` ON `bodega`.`salida_de_bodega` (`encargado` ASC);


-- -----------------------------------------------------
-- Table `bodega`.`detalle_salida`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bodega`.`detalle_salida` ;

CREATE TABLE IF NOT EXISTS `bodega`.`detalle_salida` (
  `iddetalle_salida` INT UNSIGNED NOT NULL,
  `idsalida` INT UNSIGNED NOT NULL,
  `cantidad` INT UNSIGNED NOT NULL,
  `idmateriales` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`iddetalle_salida`, `idsalida`),
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

CREATE INDEX `fk_detalle_salida_1_idx` ON `bodega`.`detalle_salida` (`idmateriales` ASC);

CREATE INDEX `fk_detalle_salida_2_idx` ON `bodega`.`detalle_salida` (`idsalida` ASC);


-- -----------------------------------------------------
-- Table `bodega`.`devoluciones`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bodega`.`devoluciones` ;

CREATE TABLE IF NOT EXISTS `bodega`.`devoluciones` (
  `iddevoluciones` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idordenes` INT UNSIGNED NOT NULL,
  `motivo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`iddevoluciones`),
  CONSTRAINT `fk_devoluciones_1`
    FOREIGN KEY (`idordenes`)
    REFERENCES `bodega`.`ordenes_de_compra` (`idordenes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_devoluciones_1_idx` ON `bodega`.`devoluciones` (`idordenes` ASC);

USE `produccion` ;

-- -----------------------------------------------------
-- Table `produccion`.`productos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `produccion`.`productos` ;

CREATE TABLE IF NOT EXISTS `produccion`.`productos` (
  `idproductos` INT UNSIGNED NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `numero_parte` INT UNSIGNED NOT NULL,
  `descripcion` TEXT NOT NULL,
  `manual` VARCHAR(45) NOT NULL,
  `archivos_digitales` VARCHAR(80) NOT NULL,
  `info_adicional` TEXT NULL,
  `cantidad` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idproductos`))
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
  CONSTRAINT `fk_precios_1`
    FOREIGN KEY (`idproductos`)
    REFERENCES `produccion`.`productos` (`idproductos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_precios_1_idx` ON `produccion`.`precios` (`idproductos` ASC);

USE `iot` ;

-- -----------------------------------------------------
-- Table `iot`.`cliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iot`.`cliente` ;

CREATE TABLE IF NOT EXISTS `iot`.`cliente` (
  `idcliente` INT UNSIGNED NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `cedula` VARCHAR(45) NOT NULL,
  `localizacion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idcliente`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iot`.`casa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iot`.`casa` ;

CREATE TABLE IF NOT EXISTS `iot`.`casa` (
  `idcasa` INT UNSIGNED NOT NULL,
  `idcliente` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idcasa`),
  CONSTRAINT `fk_casa_1`
    FOREIGN KEY (`idcliente`)
    REFERENCES `iot`.`cliente` (`idcliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_casa_1_idx` ON `iot`.`casa` (`idcliente` ASC);


-- -----------------------------------------------------
-- Table `iot`.`dispositivos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iot`.`dispositivos` ;

CREATE TABLE IF NOT EXISTS `iot`.`dispositivos` (
  `iddispositivos` INT UNSIGNED NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion` TEXT NOT NULL,
  PRIMARY KEY (`iddispositivos`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iot`.`datos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iot`.`datos` ;

CREATE TABLE IF NOT EXISTS `iot`.`datos` (
  `iddatos` INT UNSIGNED NOT NULL,
  `iddispositivos` INT UNSIGNED NOT NULL,
  `idcasa` INT UNSIGNED NOT NULL,
  `inicio` TIMESTAMP NOT NULL,
  `fin` TIMESTAMP NULL,
  `lectura` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`iddatos`),
  CONSTRAINT `fk_datos_1`
    FOREIGN KEY (`iddispositivos`)
    REFERENCES `iot`.`dispositivos` (`iddispositivos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_datos_2`
    FOREIGN KEY (`idcasa`)
    REFERENCES `iot`.`casa` (`idcasa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_datos_1_idx` ON `iot`.`datos` (`iddispositivos` ASC);

CREATE INDEX `fk_datos_2_idx` ON `iot`.`datos` (`idcasa` ASC);


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
	SET materiales.cantidad = materiales.cantidad + (SELECT cantidad FROM detalle_orden ORDER BY idordenes DESC, iddetalle DESC LIMIT 1)
	WHERE materiales.idmateriales = (SELECT idmateriales FROM detalle_orden ORDER BY idordenes DESC, iddetalle DESC LIMIT 1);
END
$$


USE `bodega`$$
DROP TRIGGER IF EXISTS `bodega`.`check` $$
USE `bodega`$$
CREATE TRIGGER `check` BEFORE INSERT ON `detalle_salida` 
FOR EACH ROW
BEGIN 
	SET @ACTUAL = (SELECT cantidad FROM materiales WHERE NEW.idmateriales = materiales.idmateriales);
	IF @ACTUAL < NEW.cantidad 
	THEN
		SET NEW.cantidad = @ACTUAL;
	END IF;
END

	$$


USE `bodega`$$
DROP TRIGGER IF EXISTS `bodega`.`salida_bodega` $$
USE `bodega`$$
CREATE TRIGGER `salida_bodega` AFTER INSERT ON `detalle_salida` FOR EACH ROW
BEGIN
	UPDATE materiales
	SET materiales.cantidad = materiales.cantidad - (SELECT cantidad FROM detalle_salida ORDER BY idsalida DESC, iddetalle_salida DESC LIMIT 1)
	WHERE materiales.idmateriales = (SELECT idmateriales FROM detalle_salida ORDER BY idsalida DESC, iddetalle_salida DESC LIMIT 1);
END
$$


DELIMITER ;
