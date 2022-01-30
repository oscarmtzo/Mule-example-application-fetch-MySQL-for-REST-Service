-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema employee_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema employee_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `employee_db` DEFAULT CHARACTER SET utf8 ;
USE `employee_db` ;

-- -----------------------------------------------------
-- Table `employee_db`.`employeeDetails`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `employee_db`.`employee_details` (
  `id_employee` INT NOT NULL AUTO_INCREMENT,
  `name_employee` VARCHAR(45) NULL,
  `email_employee` VARCHAR(45) NULL,
  `status_employee` VARCHAR(45) NULL,
  PRIMARY KEY (`id_employee`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
