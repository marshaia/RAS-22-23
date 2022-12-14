-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema rasbetDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema rasbetDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `rasbetDB` ;
USE `rasbetDB` ;

-- -----------------------------------------------------
-- Table `rasbetDB`.`desporto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rasbetDB`.`desporto` (
  `iddesporto` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(64) NOT NULL,
  `individual` TINYINT NULL,
  `empate` TINYINT NULL,
  PRIMARY KEY (`iddesporto`),
  UNIQUE INDEX `iddesporto_UNIQUE` (`iddesporto` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rasbetDB`.`competicao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rasbetDB`.`competicao` (
  `idcompeticao` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(64) NOT NULL,
  `desporto_iddesporto` INT NOT NULL,
  PRIMARY KEY (`idcompeticao`),
  UNIQUE INDEX `idcompeticao_UNIQUE` (`idcompeticao` ASC) VISIBLE,
  INDEX `fk_competicao_desporto1_idx` (`desporto_iddesporto` ASC) VISIBLE,
  CONSTRAINT `fk_competicao_desporto1`
    FOREIGN KEY (`desporto_iddesporto`)
    REFERENCES `rasbetDB`.`desporto` (`iddesporto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rasbetDB`.`jogo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rasbetDB`.`jogo` (
  `idjogo` INT NOT NULL AUTO_INCREMENT,
  `starttime` DATETIME NOT NULL,
  `completed` TINYINT NOT NULL,
  `hometeam` VARCHAR(64) NULL,
  `awayteam` VARCHAR(64) NULL,
  `score` VARCHAR(16) NULL,
  `playerlist` JSON NULL,
  `winner` VARCHAR(64) NULL,
  `competicao_idcompeticao` INT NULL,
  `desporto_iddesporto` INT NOT NULL,
  PRIMARY KEY (`idjogo`),
  UNIQUE INDEX `idjogo_UNIQUE` (`idjogo` ASC) VISIBLE,
  INDEX `fk_jogo_competicao1_idx` (`competicao_idcompeticao` ASC) VISIBLE,
  INDEX `fk_jogo_desporto1_idx` (`desporto_iddesporto` ASC) VISIBLE,
  CONSTRAINT `fk_jogo_competicao1`
    FOREIGN KEY (`competicao_idcompeticao`)
    REFERENCES `rasbetDB`.`competicao` (`idcompeticao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_jogo_desporto1`
    FOREIGN KEY (`desporto_iddesporto`)
    REFERENCES `rasbetDB`.`desporto` (`iddesporto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rasbetDB`.`resultado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rasbetDB`.`resultado` (
  `idresultado` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(64) NOT NULL,
  `jogo_idjogo` INT NOT NULL,
  PRIMARY KEY (`idresultado`),
  UNIQUE INDEX `idresultado_UNIQUE` (`idresultado` ASC) VISIBLE,
  INDEX `fk_resultado_jogo1_idx` (`jogo_idjogo` ASC) VISIBLE,
  CONSTRAINT `fk_resultado_jogo1`
    FOREIGN KEY (`jogo_idjogo`)
    REFERENCES `rasbetDB`.`jogo` (`idjogo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rasbetDB`.`utilizador`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rasbetDB`.`utilizador` (
  `idutilizador` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(64) NOT NULL,
  `password` CHAR(64) NOT NULL,
  `nome` VARCHAR(64) NOT NULL,
  `datanascimento` DATE NULL,
  `nif` VARCHAR(16) NULL,
  `cc` VARCHAR(16) NULL,
  `endereco` VARCHAR(64) NULL,
  `telefone` VARCHAR(16) NULL,
  PRIMARY KEY (`idutilizador`),
  UNIQUE INDEX `idutilizador_UNIQUE` (`idutilizador` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rasbetDB`.`especialista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rasbetDB`.`especialista` (
  `utilizador_idutilizador` INT NOT NULL,
  PRIMARY KEY (`utilizador_idutilizador`),
  INDEX `fk_especialista_utilizador1_idx` (`utilizador_idutilizador` ASC) VISIBLE,
  CONSTRAINT `fk_especialista_utilizador1`
    FOREIGN KEY (`utilizador_idutilizador`)
    REFERENCES `rasbetDB`.`utilizador` (`idutilizador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rasbetDB`.`administrador`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rasbetDB`.`administrador` (
  `utilizador_idutilizador` INT NOT NULL,
  PRIMARY KEY (`utilizador_idutilizador`),
  INDEX `fk_administrador_utilizador1_idx` (`utilizador_idutilizador` ASC) VISIBLE,
  CONSTRAINT `fk_administrador_utilizador1`
    FOREIGN KEY (`utilizador_idutilizador`)
    REFERENCES `rasbetDB`.`utilizador` (`idutilizador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rasbetDB`.`apostador`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rasbetDB`.`apostador` (
  `utilizador_idutilizador` INT NOT NULL,
  `valorcarteira` FLOAT NOT NULL,
  PRIMARY KEY (`utilizador_idutilizador`),
  INDEX `fk_apostador_utilizador1_idx` (`utilizador_idutilizador` ASC) VISIBLE,
  CONSTRAINT `fk_apostador_utilizador1`
    FOREIGN KEY (`utilizador_idutilizador`)
    REFERENCES `rasbetDB`.`utilizador` (`idutilizador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rasbetDB`.`transacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rasbetDB`.`transacao` (
  `idtransacao` INT NOT NULL AUTO_INCREMENT,
  `valor` FLOAT NOT NULL,
  `data` DATETIME NOT NULL,
  `descricao` VARCHAR(64) NOT NULL,
  `apostador_utilizador_idutilizador` INT NOT NULL,
  PRIMARY KEY (`idtransacao`),
  UNIQUE INDEX `idtransacao_UNIQUE` (`idtransacao` ASC) VISIBLE,
  INDEX `fk_transacao_apostador1_idx` (`apostador_utilizador_idutilizador` ASC) VISIBLE,
  CONSTRAINT `fk_transacao_apostador1`
    FOREIGN KEY (`apostador_utilizador_idutilizador`)
    REFERENCES `rasbetDB`.`apostador` (`utilizador_idutilizador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rasbetDB`.`aposta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rasbetDB`.`aposta` (
  `idaposta` INT NOT NULL AUTO_INCREMENT,
  `simples` TINYINT NOT NULL,
  `valor` FLOAT NOT NULL,
  `data` DATETIME NOT NULL,
  `apostador_utilizador_idutilizador` INT NOT NULL,
  `estado` VARCHAR(16) NOT NULL,
  `numApostas` INT NOT NULL,
  `cota` FLOAT NOT NULL,
  PRIMARY KEY (`idaposta`),
  UNIQUE INDEX `idaposta_UNIQUE` (`idaposta` ASC) VISIBLE,
  INDEX `fk_aposta_apostador1_idx` (`apostador_utilizador_idutilizador` ASC) VISIBLE,
  CONSTRAINT `fk_aposta_apostador1`
    FOREIGN KEY (`apostador_utilizador_idutilizador`)
    REFERENCES `rasbetDB`.`apostador` (`utilizador_idutilizador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rasbetDB`.`notificacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rasbetDB`.`notificacao` (
  `idnotificacao` INT NOT NULL AUTO_INCREMENT,
  `mensagem` VARCHAR(256) NOT NULL,
  `administrador_utilizador_idutilizador` INT NOT NULL,
  PRIMARY KEY (`idnotificacao`),
  UNIQUE INDEX `idnotificacao_UNIQUE` (`idnotificacao` ASC) VISIBLE,
  INDEX `fk_notificacao_administrador1_idx` (`administrador_utilizador_idutilizador` ASC) VISIBLE,
  CONSTRAINT `fk_notificacao_administrador1`
    FOREIGN KEY (`administrador_utilizador_idutilizador`)
    REFERENCES `rasbetDB`.`administrador` (`utilizador_idutilizador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rasbetDB`.`apostador_has_notificacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rasbetDB`.`apostador_has_notificacao` (
  `apostador_utilizador_idutilizador` INT NOT NULL,
  `notificacao_idnotificacao` INT NOT NULL,
  `visto` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`apostador_utilizador_idutilizador`, `notificacao_idnotificacao`),
  INDEX `fk_apostador_has_notificacao_notificacao1_idx` (`notificacao_idnotificacao` ASC) VISIBLE,
  INDEX `fk_apostador_has_notificacao_apostador1_idx` (`apostador_utilizador_idutilizador` ASC) VISIBLE,
  CONSTRAINT `fk_apostador_has_notificacao_apostador1`
    FOREIGN KEY (`apostador_utilizador_idutilizador`)
    REFERENCES `rasbetDB`.`apostador` (`utilizador_idutilizador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_apostador_has_notificacao_notificacao1`
    FOREIGN KEY (`notificacao_idnotificacao`)
    REFERENCES `rasbetDB`.`notificacao` (`idnotificacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rasbetDB`.`promocao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rasbetDB`.`promocao` (
  `idpromocao` INT NOT NULL AUTO_INCREMENT,
  `ativa` TINYINT NOT NULL DEFAULT 0,
  `descricao` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`idpromocao`),
  UNIQUE INDEX `idpromocoes_UNIQUE` (`idpromocao` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rasbetDB`.`especialista_has_desporto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rasbetDB`.`especialista_has_desporto` (
  `especialista_utilizador_idutilizador` INT NOT NULL,
  `desporto_iddesporto` INT NOT NULL,
  PRIMARY KEY (`especialista_utilizador_idutilizador`, `desporto_iddesporto`),
  INDEX `fk_especialista_has_desporto_desporto1_idx` (`desporto_iddesporto` ASC) VISIBLE,
  INDEX `fk_especialista_has_desporto_especialista1_idx` (`especialista_utilizador_idutilizador` ASC) VISIBLE,
  CONSTRAINT `fk_especialista_has_desporto_especialista1`
    FOREIGN KEY (`especialista_utilizador_idutilizador`)
    REFERENCES `rasbetDB`.`especialista` (`utilizador_idutilizador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_especialista_has_desporto_desporto1`
    FOREIGN KEY (`desporto_iddesporto`)
    REFERENCES `rasbetDB`.`desporto` (`iddesporto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rasbetDB`.`cota`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rasbetDB`.`cota` (
  `especialista_utilizador_idutilizador` INT NOT NULL,
  `resultado_idresultado` INT NOT NULL,
  `cota` FLOAT NULL,
  PRIMARY KEY (`especialista_utilizador_idutilizador`, `resultado_idresultado`),
  INDEX `fk_especialista_has_resultado_resultado1_idx` (`resultado_idresultado` ASC) VISIBLE,
  INDEX `fk_especialista_has_resultado_especialista1_idx` (`especialista_utilizador_idutilizador` ASC) VISIBLE,
  CONSTRAINT `fk_especialista_has_resultado_especialista1`
    FOREIGN KEY (`especialista_utilizador_idutilizador`)
    REFERENCES `rasbetDB`.`especialista` (`utilizador_idutilizador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_especialista_has_resultado_resultado1`
    FOREIGN KEY (`resultado_idresultado`)
    REFERENCES `rasbetDB`.`resultado` (`idresultado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rasbetDB`.`aposta_has_resultado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rasbetDB`.`aposta_has_resultado` (
  `aposta_idaposta` INT NOT NULL,
  `resultado_idresultado` INT NOT NULL,
  PRIMARY KEY (`aposta_idaposta`, `resultado_idresultado`),
  INDEX `fk_aposta_has_resultado_resultado1_idx` (`resultado_idresultado` ASC) VISIBLE,
  INDEX `fk_aposta_has_resultado_aposta1_idx` (`aposta_idaposta` ASC) VISIBLE,
  CONSTRAINT `fk_aposta_has_resultado_aposta1`
    FOREIGN KEY (`aposta_idaposta`)
    REFERENCES `rasbetDB`.`aposta` (`idaposta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_aposta_has_resultado_resultado1`
    FOREIGN KEY (`resultado_idresultado`)
    REFERENCES `rasbetDB`.`resultado` (`idresultado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;