-- phpMyAdmin SQL Dump
-- version 4.9.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8003
-- Generation Time: Apr 19, 2020 at 10:52 PM
-- Server version: 5.7.26
-- PHP Version: 7.4.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";
SET
    SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET
    AUTOCOMMIT = 0;
START TRANSACTION
    ;
SET
    time_zone = "+00:00";
    /*!40101
SET
    @OLD_CHARACTER_SET_CLIENT = @@CHARACTER_SET_CLIENT */;
    /*!40101
SET
    @OLD_CHARACTER_SET_RESULTS = @@CHARACTER_SET_RESULTS */;
    /*!40101
SET
    @OLD_COLLATION_CONNECTION = @@COLLATION_CONNECTION */;
    /*!40101
SET NAMES
    utf8mb4 */;
 -- 
-- Database: `courseRecommender`
-- 
CREATE DATABASE IF NOT EXISTS `courseRecommender` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
 USE  `courseRecommender`;
 -- --------------------------------------------------------
-- - CREATE TABLE TERM, GRADE, DEGREE, LEVEL , PLAN of STUDY
-- 
-- Table structure for table `term`
-- 
DROP TABLE IF EXISTS
    `term`;
CREATE TABLE IF NOT EXISTS `term`(
    `term_id` INT(4) NOT NULL,
    `semester` VARCHAR(100) DEFAULT NULL,
    `year` INT(10) DEFAULT NULL,
    PRIMARY KEY(`term_id`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8;
-- -------------------------------------------
-- 
-- Table structure for table `degree`
-- 
DROP TABLE IF EXISTS
    `degree`;
CREATE TABLE IF NOT EXISTS `degree`(
    `degree_id` INT(10) NOT NULL,
    `degree_name` VARCHAR(100) DEFAULT NULL,
    PRIMARY KEY(`degree_id`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8;
-- -------------------------------------------
-- 
-- Table structure for table `level`
-- 
DROP TABLE IF EXISTS
    `level`;
CREATE TABLE IF NOT EXISTS `level`(
    `level_id` VARCHAR(10) NOT NULL,
    `level_name` VARCHAR(100) DEFAULT NULL,
    PRIMARY KEY(`level_id`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8;
-- --------------------------------------------------------
-- 
-- Table structure for table `grade`
-- 
DROP TABLE IF EXISTS
    `grade`;
CREATE TABLE IF NOT EXISTS `grade`(
    `grade_code` VARCHAR(100) NOT NULL,
    `quality_points` DECIMAL(3, 2) DEFAULT NULL,
    `descrtiption` VARCHAR(100) DEFAULT NULL,
    PRIMARY KEY(`grade_code`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8;
-- ------------------------------------------------------
-- 
-- Table structure for table `plan_of_study`
-- 
DROP TABLE IF EXISTS
    `plan_of_study`;
CREATE TABLE IF NOT EXISTS `plan_of_study`(
    `plan_id` INT(10) NOT NULL,
    `plan_of_study` VARCHAR(100) DEFAULT NULL,
    PRIMARY KEY(`plan_id`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8;
-- ---------------------------------------------------------
-- 
-- Table structure for table `course`
-- 
DROP TABLE IF EXISTS
    `course`;
CREATE TABLE IF NOT EXISTS `course`(
    `course_id` INT(10) NOT NULL,
    `name` VARCHAR(100) DEFAULT NULL,
    `description` VARCHAR(2000) DEFAULT NULL,
    `level_id` VARCHAR(2) DEFAULT NULL,
    `plan_id` INT(1) DEFAULT NULL,
    PRIMARY KEY(`course_id`),
    FOREIGN KEY(`plan_id`) REFERENCES `plan_of_study`(`plan_id`),
    FOREIGN KEY(`level_id`) REFERENCES `level`(`level_id`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8;
-- ----------------------------------------------------------
-- 
-- Table structure for table `student`
-- 
DROP TABLE IF EXISTS
    `student`;
CREATE TABLE IF NOT EXISTS `student`(
    `student_id` INT(10) NOT NULL AUTO_INCREMENT,
    `level_id` VARCHAR(10) NOT NULL,
    `start_term` INT(10) DEFAULT NULL,
    `plan_id` INT(10) DEFAULT NULL,
    `degree_id` INT(10) DEFAULT NULL,
    `email` VARCHAR(1000) DEFAULT NULL,
    `name` VARCHAR(1000) DEFAULT NULL,
    `username` VARCHAR(1000) DEFAULT NULL,
    `password` VARCHAR(1000) DEFAULT NULL,
    `age` VARCHAR(10) DEFAULT NULL,
    `gender` VARCHAR(10) DEFAULT NULL,
    `active` VARCHAR(10) DEFAULT NULL,
    PRIMARY KEY(`student_id`, `level_id`),
    FOREIGN KEY(`start_term`) REFERENCES `term`(`term_id`),
    FOREIGN KEY(`degree_id`) REFERENCES `degree`(`degree_id`),
    FOREIGN KEY(`plan_id`) REFERENCES `plan_of_study`(`plan_id`),
    FOREIGN KEY(`level_id`) REFERENCES `level`(`level_id`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8;
-- -------------------------------------------------------------------
-- 
-- Table structure for table `temp_taken_course`
-- 
DROP TABLE IF EXISTS
    `temp_taken_course`;
CREATE TABLE IF NOT EXISTS `temp_taken_course`(
    `student_id` INT(10)  DEFAULT NULL,
    `level_id` VARCHAR(100) DEFAULT NULL,
    `term_id` INT(10) DEFAULT NULL,
    `course_id` INT(10) DEFAULT NULL,
    `grade_code` VARCHAR(10) DEFAULT NULL,
    FOREIGN KEY(`student_id`) REFERENCES `student`(`student_id`),
    FOREIGN KEY(`course_id`) REFERENCES `course`(`course_id`),
    FOREIGN KEY(`term_id`) REFERENCES `term`(`term_id`),
    FOREIGN KEY(`level_id`) REFERENCES `level`(`level_id`),
    FOREIGN KEY(`grade_code`) REFERENCES `grade`(`grade_code`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8; 

-- -------------------------------------------------------------------
-- 
-- Table structure for table `taken_course`
-- 
DROP TABLE IF EXISTS
    `taken_course`;
CREATE TABLE IF NOT EXISTS `taken_course`(
    `student_id` INT(10)  NOT NULL,
    `level_id` VARCHAR(10)  NOT NULL,
    `term_id` INT(10) NOT NULL,
    `course_id` INT(10)  NOT NULL,
    `grade_code` VARCHAR(10) NOT NULL,
    PRIMARY KEY(`student_id`,`level_id`,`term_id`,`course_id`,`grade_code`),
    FOREIGN KEY(`student_id`) REFERENCES `student`(`student_id`),
    FOREIGN KEY(`course_id`) REFERENCES `course`(`course_id`),
    FOREIGN KEY(`term_id`) REFERENCES `term`(`term_id`),
    FOREIGN KEY(`level_id`) REFERENCES `level`(`level_id`),
    FOREIGN KEY(`grade_code`) REFERENCES `grade`(`grade_code`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8; 

COMMIT;

