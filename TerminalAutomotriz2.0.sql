-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema TerminalAutomotriz
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema TerminalAutomotriz
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS TerminalAutomotriz;
CREATE SCHEMA IF NOT EXISTS `TerminalAutomotriz` DEFAULT CHARACTER SET utf8;
USE `TerminalAutomotriz` ;

-- -----------------------------------------------------
-- Table `TerminalAutomotriz`.`Concesionaria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TerminalAutomotriz`.`Concesionaria` (
  `cuit` VARCHAR(45) NOT NULL,
  `razonSocial` VARCHAR(45) NOT NULL,
  `eliminado` TINYINT(1) NOT NULL DEFAULT '0',
  `fechaEliminado` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`cuit`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `TerminalAutomotriz`.`Modelo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TerminalAutomotriz`.`Modelo` (
  `idModelo` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
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
  `eliminado` TINYINT(1) NOT NULL DEFAULT '0',
  `fechaEliminado` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`idPedido`),
  INDEX `fk_Pedido_Concesionaria1_idx` (`Concesionaria_cuit` ASC) VISIBLE,
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
  `idPedido` INT(11) NOT NULL,
  `idModelo` INT(11) NOT NULL,
  `cantidad` INT(11) NOT NULL,
  `eliminado` TINYINT(1) NOT NULL DEFAULT '0',
  `fechaEliminado` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`idDetallePedido`, `idPedido`, `idModelo`),
  INDEX `fk_DetallePedido_Pedido1_idx` (`idPedido` ASC) VISIBLE,
  INDEX `fk_DetallePedido_Modelo1_idx` (`idModelo` ASC) VISIBLE,
  CONSTRAINT `fk_DetallePedido_Modelo1`
    FOREIGN KEY (`idModelo`)
    REFERENCES `TerminalAutomotriz`.`Modelo` (`idModelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DetallePedido_Pedido1`
    FOREIGN KEY (`idPedido`)
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
  `idModelo` INT(11) NOT NULL,
  PRIMARY KEY (`idLineaDeMontaje`),
  INDEX `fk_LineaDeMontaje_Modelo1_idx` (`idModelo` ASC) VISIBLE,
  CONSTRAINT `fk_LineaDeMontaje_Modelo1`
    FOREIGN KEY (`idModelo`)
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
  `nombre` VARCHAR(45) NOT NULL,
  `stock` INT(11) NOT NULL,
  `idLineaDeMontaje` INT(11) NOT NULL,
  PRIMARY KEY (`idEstacion`, `idLineaDeMontaje`),
  INDEX `fk_Estacion_LineaDeMontaje1_idx` (`idLineaDeMontaje` ASC) VISIBLE,
  CONSTRAINT `fk_Estacion_LineaDeMontaje1`
    FOREIGN KEY (`idLineaDeMontaje`)
    REFERENCES `TerminalAutomotriz`.`LineaDeMontaje` (`idLineaDeMontaje`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `TerminalAutomotriz`.`Partes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TerminalAutomotriz`.`Partes` (
  `idPartes` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `eliminado` TINYINT(1) NOT NULL DEFAULT '0',
  `fechaEliminado` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`idPartes`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `TerminalAutomotriz`.`Estacion_has_Partes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TerminalAutomotriz`.`Estacion_has_Partes` (
  `idEstacion` INT(11) NOT NULL,
  `idPartes` INT(11) NOT NULL,
  `cantidad` INT(11) NOT NULL,
  PRIMARY KEY (`idEstacion`, `idPartes`),
  INDEX `fk_Estacion_has_Partes_Partes1_idx` (`idPartes` ASC) VISIBLE,
  INDEX `fk_Estacion_has_Partes_Estacion1_idx` (`idEstacion` ASC) VISIBLE,
  CONSTRAINT `fk_Estacion_has_Partes_Estacion1`
    FOREIGN KEY (`idEstacion`)
    REFERENCES `TerminalAutomotriz`.`Estacion` (`idEstacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Estacion_has_Partes_Partes1`
    FOREIGN KEY (`idPartes`)
    REFERENCES `TerminalAutomotriz`.`Partes` (`idPartes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `TerminalAutomotriz`.`Proveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TerminalAutomotriz`.`Proveedor` (
  `cuit` VARCHAR(45) NOT NULL,
  `razonSocial` VARCHAR(45) NOT NULL,
  `eliminado` TINYINT(1) NOT NULL DEFAULT '0',
  `fechaEliminado` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`cuit`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `TerminalAutomotriz`.`Partes_has_Proveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TerminalAutomotriz`.`Partes_has_Proveedor` (
  `idPartes` INT(11) NOT NULL,
  `Proveedor_cuit` VARCHAR(45) NOT NULL,
  `precio` VARCHAR(45) NOT NULL,
  `eliminado` TINYINT(1) NOT NULL DEFAULT '0',
  `fechaEliminado` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`idPartes`, `Proveedor_cuit`),
  INDEX `fk_Partes_has_Proveedor_Proveedor1_idx` (`Proveedor_cuit` ASC) VISIBLE,
  INDEX `fk_Partes_has_Proveedor_Partes1_idx` (`idPartes` ASC) VISIBLE,
  CONSTRAINT `fk_Partes_has_Proveedor_Partes1`
    FOREIGN KEY (`idPartes`)
    REFERENCES `TerminalAutomotriz`.`Partes` (`idPartes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Partes_has_Proveedor_Proveedor1`
    FOREIGN KEY (`Proveedor_cuit`)
    REFERENCES `TerminalAutomotriz`.`Proveedor` (`cuit`)
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
  `fechaFinalizacion` DATE NULL DEFAULT NULL,
  `terminado` TINYINT(1) NOT NULL DEFAULT '0',
  `idDetallePedido` INT(11) NOT NULL,
  `idPedido` INT(11) NOT NULL,
  `idModelo` INT(11) NOT NULL,
  PRIMARY KEY (`numChasis`),
  INDEX `fk_Vehiculo_DetallePedido1_idx` (`idDetallePedido` ASC, `idPedido` ASC, `idModelo` ASC) VISIBLE,
  CONSTRAINT `fk_Vehiculo_DetallePedido1`
    FOREIGN KEY (`idDetallePedido` , `idPedido` , `idModelo`)
    REFERENCES `TerminalAutomotriz`.`DetallePedido` (`idDetallePedido` , `idPedido` , `idModelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `TerminalAutomotriz`.`RegistroLinea`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TerminalAutomotriz`.`RegistroLinea` (
  `numChasis` INT(11) NOT NULL,
  `idLineaDeMontaje` INT(11) NOT NULL,
  PRIMARY KEY (`numChasis`, `idLineaDeMontaje`),
  INDEX `fk_Vehiculo_has_LineaDeMontaje_LineaDeMontaje2_idx` (`idLineaDeMontaje` ASC) VISIBLE,
  INDEX `fk_Vehiculo_has_LineaDeMontaje_Vehiculo2_idx` (`numChasis` ASC) VISIBLE,
  CONSTRAINT `fk_Vehiculo_has_LineaDeMontaje_Vehiculo2`
    FOREIGN KEY (`numChasis`)
    REFERENCES `TerminalAutomotriz`.`Vehiculo` (`numChasis`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Vehiculo_has_LineaDeMontaje_LineaDeMontaje2`
    FOREIGN KEY (`idLineaDeMontaje`)
    REFERENCES `TerminalAutomotriz`.`LineaDeMontaje` (`idLineaDeMontaje`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `TerminalAutomotriz`.`RegistroEstacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TerminalAutomotriz`.`RegistroEstacion` (
  `idRegistroEstacion` INT NOT NULL,
  `fechayHoraIngreso` DATETIME NOT NULL,
  `fechayHoraEgreso` DATETIME NULL,
  `numChasis` INT(11) NOT NULL,
  `idEstacion` INT(11) NOT NULL,
  `idLineaDeMontaje` INT(11) NOT NULL,
  PRIMARY KEY (`idRegistroEstacion`, `numChasis`, `idEstacion`, `idLineaDeMontaje`),
  INDEX `fk_Vehiculo_has_Estacion_Estacion1_idx` (`idEstacion` ASC, `idLineaDeMontaje` ASC) VISIBLE,
  INDEX `fk_Vehiculo_has_Estacion_Vehiculo1_idx` (`numChasis` ASC) VISIBLE,
  CONSTRAINT `fk_Vehiculo_has_Estacion_Vehiculo1`
    FOREIGN KEY (`numChasis`)
    REFERENCES `TerminalAutomotriz`.`Vehiculo` (`numChasis`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Vehiculo_has_Estacion_Estacion1`
    FOREIGN KEY (`idEstacion` , `idLineaDeMontaje`)
    REFERENCES `TerminalAutomotriz`.`Estacion` (`idEstacion` , `idLineaDeMontaje`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
