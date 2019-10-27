-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema TerminalAutomotriz
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `TerminalAutomotriz` ;
CREATE SCHEMA IF NOT EXISTS `TerminalAutomotriz` DEFAULT CHARACTER SET utf8 ;
USE `TerminalAutomotriz` ;

-- -----------------------------------------------------
-- Table `TerminalAutomotriz`.`Concesionaria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TerminalAutomotriz`.`Concesionaria` (
  -- `idConcesionaria` INT(11) NOT NULL AUTO_INCREMENT,
  `cuit` VARCHAR(45) NOT NULL,
  `razonSocial` VARCHAR(45) NOT NULL,
  `eliminado` TINYINT(1) NOT NULL DEFAULT 0,
  `fechaEliminado` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`cuit`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `TerminalAutomotriz`.`Modelo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TerminalAutomotriz`.`Modelo` (
  `idModelo` INT(11) NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idModelo`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `TerminalAutomotriz`.`Pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TerminalAutomotriz`.`Pedido` (
  `idPedido` INT(11) NOT NULL AUTO_INCREMENT,
  `fecha` DATE NOT NULL,
  `Concesionaria_cuit` VARCHAR(45) NOT NULL,
  `eliminado` TINYINT(1) NOT NULL DEFAULT 0,
  `fechaEliminado` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`idPedido`, `Concesionaria_cuit`),
  INDEX `fk_Pedido_Concesionaria1_idx` (`Concesionaria_cuit` ASC),
  CONSTRAINT `fk_Pedido_Concesionaria1`
    FOREIGN KEY (`Concesionaria_cuit`)
    REFERENCES `TerminalAutomotriz`.`Concesionaria` (`cuit`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- -----------------------------------------------------
-- Table `TerminalAutomotriz`.`DetallePedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TerminalAutomotriz`.`DetallePedido` (
  `idDetallePedido` INT(11) NOT NULL AUTO_INCREMENT,
  `Pedido_idPedido` INT(11) NOT NULL,
  `Modelo_idModelo` INT(11) NOT NULL,
  `cantidad` INT(11) NOT NULL,
  `eliminado` TINYINT(1) NOT NULL DEFAULT 0,
  `fechaEliminado` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`idDetallePedido`, `Pedido_idPedido`, `Modelo_idModelo`),
  INDEX `fk_DetallePedido_Pedido1_idx` (`Pedido_idPedido` ASC),
  INDEX `fk_DetallePedido_Modelo1_idx` (`Modelo_idModelo` ASC),
  CONSTRAINT `fk_DetallePedido_Modelo1`
    FOREIGN KEY (`Modelo_idModelo`)
    REFERENCES `TerminalAutomotriz`.`Modelo` (`idModelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DetallePedido_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `TerminalAutomotriz`.`Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `TerminalAutomotriz`.`LineaDeMontaje`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TerminalAutomotriz`.`LineaDeMontaje` (
  `idLineaDeMontaje` INT(11) NOT NULL AUTO_INCREMENT,
  `Modelo_idModelo` INT(11) NOT NULL,
  PRIMARY KEY (`idLineaDeMontaje`, `Modelo_idModelo`),
  INDEX `fk_LineaDeMontaje_Modelo1_idx` (`Modelo_idModelo` ASC),
  CONSTRAINT `fk_LineaDeMontaje_Modelo1`
    FOREIGN KEY (`Modelo_idModelo`)
    REFERENCES `TerminalAutomotriz`.`Modelo` (`idModelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `TerminalAutomotriz`.`Estacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TerminalAutomotriz`.`Estacion` (
  `idEstacion` INT(11) NOT NULL AUTO_INCREMENT,
  `orden` INT(11) NOT NULL,
  `descripcion` VARCHAR(45) NOT NULL,
  `stock` INT(11) NOT NULL,
  `LineaDeMontaje_idLineaDeMontaje` INT(11) NOT NULL,
  `LineaDeMontaje_Modelo_idModelo` INT(11) NOT NULL,
  PRIMARY KEY (`idEstacion`, `LineaDeMontaje_idLineaDeMontaje`, `LineaDeMontaje_Modelo_idModelo`),
  INDEX `fk_Estacion_LineaDeMontaje1_idx` (`LineaDeMontaje_idLineaDeMontaje` ASC, `LineaDeMontaje_Modelo_idModelo` ASC),
  CONSTRAINT `fk_Estacion_LineaDeMontaje1`
    FOREIGN KEY (`LineaDeMontaje_idLineaDeMontaje` , `LineaDeMontaje_Modelo_idModelo`)
    REFERENCES `TerminalAutomotriz`.`LineaDeMontaje` (`idLineaDeMontaje` , `Modelo_idModelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `TerminalAutomotriz`.`Partes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TerminalAutomotriz`.`Partes` (
  `idPartes` INT(11) NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(45) NOT NULL,
  `eliminado` TINYINT(1) NOT NULL DEFAULT 0,
  `fechaEliminado` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`idPartes`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `TerminalAutomotriz`.`Estacion_has_Partes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TerminalAutomotriz`.`Estacion_has_Partes` (
  `Estacion_idEstacion` INT(11) NOT NULL,
  `Partes_idPartes` INT(11) NOT NULL,
  `cantidad` INT(11) NOT NULL,
  PRIMARY KEY (`Estacion_idEstacion`, `Partes_idPartes`),
  INDEX `fk_Estacion_has_Partes_Partes1_idx` (`Partes_idPartes` ASC),
  INDEX `fk_Estacion_has_Partes_Estacion1_idx` (`Estacion_idEstacion` ASC),
  CONSTRAINT `fk_Estacion_has_Partes_Estacion1`
    FOREIGN KEY (`Estacion_idEstacion`)
    REFERENCES `TerminalAutomotriz`.`Estacion` (`idEstacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Estacion_has_Partes_Partes1`
    FOREIGN KEY (`Partes_idPartes`)
    REFERENCES `TerminalAutomotriz`.`Partes` (`idPartes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `TerminalAutomotriz`.`Proveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TerminalAutomotriz`.`Proveedor` (
  `idProveedor` INT(11) NOT NULL AUTO_INCREMENT,
  `cuit` VARCHAR(45) NOT NULL,
  `razonSocial` VARCHAR(45) NOT NULL,
  `eliminado` TINYINT(1) NOT NULL DEFAULT 0,
  `fechaEliminado` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`idProveedor`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `TerminalAutomotriz`.`Partes_has_Proveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TerminalAutomotriz`.`Partes_has_Proveedor` (
  `Partes_idPartes` INT(11) NOT NULL,
  `Proveedor_idProveedor` INT(11) NOT NULL,
  `precio` VARCHAR(45) NOT NULL,
  `eliminado` TINYINT(1) NOT NULL DEFAULT 0,
  `fechaEliminado` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`Partes_idPartes`, `Proveedor_idProveedor`),
  INDEX `fk_Partes_has_Proveedor_Proveedor1_idx` (`Proveedor_idProveedor` ASC),
  INDEX `fk_Partes_has_Proveedor_Partes1_idx` (`Partes_idPartes` ASC),
  CONSTRAINT `fk_Partes_has_Proveedor_Partes1`
    FOREIGN KEY (`Partes_idPartes`)
    REFERENCES `TerminalAutomotriz`.`Partes` (`idPartes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Partes_has_Proveedor_Proveedor1`
    FOREIGN KEY (`Proveedor_idProveedor`)
    REFERENCES `TerminalAutomotriz`.`Proveedor` (`idProveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `TerminalAutomotriz`.`Vehiculo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TerminalAutomotriz`.`Vehiculo` (
  `numChasis` INT(11) NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(45) NOT NULL,
  `fechaFinalizacion` DATE default null,
  `terminado` TINYINT(1) NOT NULL DEFAULT 0,
  `DetallePedido_idDetallePedido` INT(11) NOT NULL,
  `DetallePedido_Pedido_idPedido` INT(11) NOT NULL,
  `DetallePedido_Modelo_idModelo` INT(11) NOT NULL,
  PRIMARY KEY (`numChasis`, `DetallePedido_idDetallePedido`, `DetallePedido_Pedido_idPedido`, `DetallePedido_Modelo_idModelo`),
  INDEX `fk_Vehiculo_DetallePedido1_idx` (`DetallePedido_idDetallePedido` ASC, `DetallePedido_Pedido_idPedido` ASC, `DetallePedido_Modelo_idModelo` ASC),
  CONSTRAINT `fk_Vehiculo_DetallePedido1`
    FOREIGN KEY (`DetallePedido_idDetallePedido` , `DetallePedido_Pedido_idPedido` , `DetallePedido_Modelo_idModelo`)
    REFERENCES `TerminalAutomotriz`.`DetallePedido` (`idDetallePedido` , `Pedido_idPedido` , `Modelo_idModelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `TerminalAutomotriz`.`RegistroEstacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TerminalAutomotriz`.`RegistroEstacion` (
  `idRegistroEstacion` INT(11) NOT NULL AUTO_INCREMENT,
  `fechayHoraIngreso` DATETIME NOT NULL,
  `fechayHoraEgreso` DATETIME NULL DEFAULT NULL,
  `Vehiculo_numChasis` INT(11) NOT NULL,
  `Vehiculo_DetallePedido_idDetallePedido` INT(11) NOT NULL,
  `Vehiculo_DetallePedido_Pedido_idPedido` INT(11) NOT NULL,
  `Vehiculo_DetallePedido_Modelo_idModelo` INT(11) NOT NULL,
  `Estacion_idEstacion` INT(11) NOT NULL,
  `Estacion_LineaDeMontaje_idLineaDeMontaje` INT(11) NOT NULL,
  `Estacion_LineaDeMontaje_Modelo_idModelo` INT(11) NOT NULL,
  PRIMARY KEY (`idRegistroEstacion`, `Vehiculo_numChasis`, `Vehiculo_DetallePedido_idDetallePedido`, `Vehiculo_DetallePedido_Pedido_idPedido`, `Vehiculo_DetallePedido_Modelo_idModelo`, `Estacion_idEstacion`, `Estacion_LineaDeMontaje_idLineaDeMontaje`, `Estacion_LineaDeMontaje_Modelo_idModelo`),
  INDEX `fk_RegistroEstacion_Vehiculo1_idx` (`Vehiculo_numChasis` ASC, `Vehiculo_DetallePedido_idDetallePedido` ASC, `Vehiculo_DetallePedido_Pedido_idPedido` ASC, `Vehiculo_DetallePedido_Modelo_idModelo` ASC),
  INDEX `fk_RegistroEstacion_Estacion1_idx` (`Estacion_idEstacion` ASC, `Estacion_LineaDeMontaje_idLineaDeMontaje` ASC, `Estacion_LineaDeMontaje_Modelo_idModelo` ASC),
  CONSTRAINT `fk_RegistroEstacion_Estacion1`
    FOREIGN KEY (`Estacion_idEstacion` , `Estacion_LineaDeMontaje_idLineaDeMontaje` , `Estacion_LineaDeMontaje_Modelo_idModelo`)
    REFERENCES `TerminalAutomotriz`.`Estacion` (`idEstacion` , `LineaDeMontaje_idLineaDeMontaje` , `LineaDeMontaje_Modelo_idModelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RegistroEstacion_Vehiculo1`
    FOREIGN KEY (`Vehiculo_numChasis` , `Vehiculo_DetallePedido_idDetallePedido` , `Vehiculo_DetallePedido_Pedido_idPedido` , `Vehiculo_DetallePedido_Modelo_idModelo`)
    REFERENCES `TerminalAutomotriz`.`Vehiculo` (`numChasis` , `DetallePedido_idDetallePedido` , `DetallePedido_Pedido_idPedido` , `DetallePedido_Modelo_idModelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
