-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 05, 2020 at 12:22 PM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `douglasu`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ClassList` (IN `FacultyNumber` INT(3), IN `Term` VARCHAR(4))  BEGIN

SELECT m.Description, d.DepartmentCode, c.CourseNum, f.FacultyNum, CONCAT(f.FirstName, " ", f.LastName) AS Instructor,
sec.SectionLetter AS Section, sec.SemesterCode AS Term, sec.Time, sec.Room, c.NumCredits AS Credits,s.StudentNum, 
CONCAT(s.FirstName, " ", s.LastName) AS StudentName, s.ClassStanding, sg.Grade
FROM student AS s inner join student_grade AS sg on s.StudentNum = sg.StudentNum
inner join course AS c using (CourseNum)
inner join department AS d ON d.DepartmentCode=c.DepartmentCode
inner join faculty AS f ON f.DepartmentCode = d.DepartmentCode
inner join section AS sec using (FacultyNum)
inner join major AS m ON m.DepartmentCode = d.DepartmentCode
WHERE FacultyNum = 153
AND sec.SemesterCode = 'SU18';


end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `StudentSchedule` (IN `StudentNumber` INT(10))  BEGIN

SELECT DISTINCT s.StudentNum AS StudentNumber, CONCAT(s.FirstName, " ", s.LastName) AS Name,
s.PermStreet AS PermanentAddress, s.PermCity AS City, s.PermState AS State, s.PermZip AS Zipcode,
s.LocalStreet AS LocalAddress, s.LocalCity AS City, s.LocalState AS State, s.LocalZip AS Zipcode,
sec.SemesterCode AS Term, sec.ScheduleCode, CONCAT(d.DepartmentCode," ",c.CourseNum) AS CourseNumber,
c.CourseTitle AS CourseDescription, sec.SectionLetter AS Section, c.NumCredits, sec.Time, sec.Room, 
c.NumCredits AS TotalCredits
FROM student AS s
inner join registration_request using (StudentNum)
inner join section AS sec using (ScheduleCode)
inner join course AS c using (CourseNum)
inner join department AS d ON d.DepartmentCode = c.DepartmentCode
WHERE StudentNum = StudentNumber;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `advises`
--

CREATE TABLE `advises` (
  `MajorNum` int(4) NOT NULL,
  `StudentNum` int(10) NOT NULL,
  `FacultyNum` int(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `advises`
--

INSERT INTO `advises` (`MajorNum`, `StudentNum`, `FacultyNum`) VALUES
(7045, 381124190, 171),
(4871, 381124196, 194),
(4871, 381124198, 194),
(3430, 381124192, 214),
(5368, 381124200, 264),
(4388, 381124202, 372),
(5368, 381124188, 518),
(7045, 381124194, 525),
(3430, 381124206, 724),
(5368, 381124204, 893);

-- --------------------------------------------------------

--
-- Stand-in structure for view `classlist`
-- (See below for the actual view)
--
CREATE TABLE `classlist` (
`Description` varchar(40)
,`DepartmentCode` varchar(3)
,`CourseNum` int(3)
,`FacultyNum` int(4)
,`Instructor` varchar(81)
,`Section` varchar(1)
,`Term` varchar(4)
,`Time` time
,`Room` varchar(7)
,`Credits` int(1)
,`StudentNum` int(10)
,`StudentName` varchar(81)
,`ClassStanding` int(3)
,`Grade` varchar(1)
);

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE `course` (
  `CourseNum` int(3) NOT NULL,
  `DepartmentCode` varchar(3) NOT NULL,
  `CourseTitle` varchar(20) NOT NULL,
  `NumCredits` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `course`
--

INSERT INTO `course` (`CourseNum`, `DepartmentCode`, `CourseTitle`, `NumCredits`) VALUES
(80, 'ENG', 'Composition Basics', 3),
(101, 'CS', 'Intro to Computer Sc', 2),
(101, 'MTH', 'Intro to College Alg', 2),
(101, 'PS', 'Science of Nature', 3),
(131, 'PS', 'Intro to Physics', 3),
(141, 'MUS', 'Music Appreciation', 2),
(151, 'ENG', 'Am Literature Since ', 3),
(151, 'MUS', 'Music of the 20th Ce', 3),
(162, 'CS', 'Programming II', 4),
(171, 'CS', 'Networking Essential', 3),
(201, 'MTH', 'Calculus I', 3),
(201, 'MUS', 'Symphonic Basics', 3),
(201, 'PS', 'Biology', 4),
(221, 'CS', 'Java and OOP', 4),
(221, 'MTH', 'Calculus II', 3),
(262, 'CS', 'Programming II', 4),
(280, 'ENG', 'Advanced Composition', 3);

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `DepartmentCode` varchar(3) NOT NULL,
  `DepartmentName` varchar(30) NOT NULL,
  `Location` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`DepartmentCode`, `DepartmentName`, `Location`) VALUES
('CS', 'Computer Science', 'Tech Building'),
('ENG', 'English', 'Main Building'),
('MTH', 'Mathematics', 'Main Building'),
('MUS', 'Music', 'Arts Building'),
('PS', 'Physical Science', 'Main Building');

-- --------------------------------------------------------

--
-- Table structure for table `faculty`
--

CREATE TABLE `faculty` (
  `FacultyNum` int(4) NOT NULL,
  `LastName` varchar(40) NOT NULL,
  `FirstName` varchar(40) NOT NULL,
  `Street` varchar(100) NOT NULL,
  `City` varchar(20) NOT NULL,
  `State` varchar(14) NOT NULL,
  `ZipCode` varchar(10) NOT NULL,
  `CurrentRank` varchar(20) NOT NULL,
  `StartDate` date NOT NULL,
  `OfficeNum` int(4) NOT NULL,
  `DepartmentCode` varchar(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `faculty`
--

INSERT INTO `faculty` (`FacultyNum`, `LastName`, `FirstName`, `Street`, `City`, `State`, `ZipCode`, `CurrentRank`, `StartDate`, `OfficeNum`, `DepartmentCode`) VALUES
(153, 'Barker', 'Terence', '21 Golden Star Ave.', 'Douglas', 'ID', '83260', 'Asst. Professor', '1994-11-03', 203, 'ENG'),
(171, 'Page', 'Matthew', '8 Water Ave.', 'Douglas', 'ID', '83260', 'Instructor', '2019-02-04', 211, 'PS'),
(181, 'Santiago', 'Rafael', '522 Bayberry Court', 'Douglas', 'ID', '83260', 'Asst. Professor', '1998-05-06', 214, 'CS'),
(194, 'Porter', 'Joanna', '7 Mammoth St.', 'Douglas', 'ID', '83260', 'Professor', '2011-12-01', 206, 'MTH'),
(214, 'Kelley', 'Lynda', '54 Pierce Lane', 'Douglas', 'ID', '83260', 'Instructor', '2019-01-13', 201, 'MUS'),
(264, 'Fleming', 'Jeremy', '864 Trusel St.', 'Douglas', 'ID', '83260', 'Assoc. Professor', '2010-07-20', 210, 'CS'),
(280, 'Flowers', 'Sonia', '39 Shadow Brook Street', 'Douglas', 'ID', '83260', 'Assoc. Professor', '2003-06-29', 213, 'PS'),
(372, 'Scott', 'Eloise', '100 Bald Hill Dr.', 'Douglas', 'ID', '83260', 'Assoc. Professor', '2005-12-21', 208, 'ENG'),
(518, 'Boyd', 'Lydia', '786 Grand Lane', 'Douglas', 'ID', '83260', 'Professor', '2017-11-16', 205, 'CS'),
(525, 'Cruz', 'Monica', '399 West Fawn Ave.', 'Douglas', 'ID', '83260', 'Assoc. Professor', '2008-02-03', 212, 'PS'),
(563, 'McBride', 'Lila', '9427 Van Dyke St.', 'Douglas', 'ID', '83260', 'Asst. Professor', '2012-01-17', 204, 'ENG'),
(661, 'Ray', 'Ray', '8917 Arlington Rd.', 'Douglas', 'ID', '83260', 'Professor', '2016-01-05', 207, 'ENG'),
(724, 'Hammond', 'Thelma', '519 Glenholme Road', 'Douglas', 'ID', '83260', 'Instructor', '1997-01-12', 202, 'MUS'),
(893, 'Edwards', 'Kristina', '983 Vine Ave.', 'Douglas', 'ID', '83260', 'Instructor', '2007-12-03', 215, 'CS'),
(944, 'Hunt', 'Victor', '8258 53rd Rd.', 'Douglas', 'ID', '83260', 'Professor', '2008-08-16', 209, 'MTH');

-- --------------------------------------------------------

--
-- Table structure for table `major`
--

CREATE TABLE `major` (
  `MajorNum` int(4) NOT NULL,
  `Description` varchar(40) DEFAULT NULL,
  `DepartmentCode` varchar(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `major`
--

INSERT INTO `major` (`MajorNum`, `Description`, `DepartmentCode`) VALUES
(3430, 'Music and the Arts', 'MUS'),
(4388, 'English Literature', 'ENG'),
(4871, 'Advanced Mathematics', 'MTH'),
(5368, 'Computer Science', 'CS'),
(7045, 'Physical Science', 'PS');

-- --------------------------------------------------------

--
-- Table structure for table `office`
--

CREATE TABLE `office` (
  `OfficeNum` int(4) NOT NULL,
  `Phone` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `office`
--

INSERT INTO `office` (`OfficeNum`, `Phone`) VALUES
(201, '867-5309'),
(202, '867-5310'),
(203, '867-5311'),
(204, '867-5312'),
(205, '867-5313'),
(206, '867-5314'),
(207, '867-5315'),
(208, '867-5316'),
(209, '867-5317'),
(210, '867-5318'),
(211, '867-5319'),
(212, '867-5320'),
(213, '867-5321'),
(214, '867-5322'),
(215, '867-5323');

-- --------------------------------------------------------

--
-- Table structure for table `prereq`
--

CREATE TABLE `prereq` (
  `CourseNum` int(3) NOT NULL,
  `DepartmentCode` varchar(3) NOT NULL,
  `PrereqCourseNum` int(3) DEFAULT NULL,
  `PrereqDepartmentCode` varchar(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `prereq`
--

INSERT INTO `prereq` (`CourseNum`, `DepartmentCode`, `PrereqCourseNum`, `PrereqDepartmentCode`) VALUES
(80, 'ENG', 80, 'ENG'),
(101, 'CS', 80, 'ENG'),
(101, 'MTH', 80, 'MTH'),
(101, 'PS', 80, 'PS'),
(141, 'MUS', 80, 'MUS'),
(151, 'ENG', 80, 'ENG'),
(131, 'PS', 101, 'PS'),
(162, 'CS', 101, 'CS'),
(201, 'MTH', 101, 'MTH'),
(201, 'PS', 131, 'PS'),
(151, 'MUS', 141, 'MUS'),
(201, 'MUS', 151, 'MUS'),
(280, 'ENG', 151, 'ENG'),
(171, 'CS', 162, 'CS'),
(221, 'CS', 171, 'CS'),
(221, 'MTH', 201, 'MTH'),
(262, 'CS', 221, 'CS');

-- --------------------------------------------------------

--
-- Stand-in structure for view `registration`
-- (See below for the actual view)
--
CREATE TABLE `registration` (
`StudentNum` int(10)
,`Name` varchar(81)
,`PermanentAddress` varchar(100)
,`PermCity` varchar(20)
,`PermState` varchar(13)
,`PermZip` varchar(10)
,`LocalAddress` varchar(100)
,`LocalCity` varchar(20)
,`LocalState` varchar(13)
,`LocalZip` varchar(10)
,`ScheduleCode` int(4)
,`Term` varchar(4)
,`AlternateScheduleCode` int(4)
,`AlternateTerm` varchar(4)
);

-- --------------------------------------------------------

--
-- Table structure for table `registration_request`
--

CREATE TABLE `registration_request` (
  `StudentNum` int(10) NOT NULL,
  `ScheduleCode` int(4) NOT NULL,
  `SemesterCode` varchar(4) NOT NULL,
  `AlternateScheduleCode` int(4) NOT NULL,
  `AlternateSemesterCode` varchar(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `registration_request`
--

INSERT INTO `registration_request` (`StudentNum`, `ScheduleCode`, `SemesterCode`, `AlternateScheduleCode`, `AlternateSemesterCode`) VALUES
(381124188, 1009, 'FA18', 1011, 'FA18'),
(381124188, 2222, 'FA18', 2223, 'FA18'),
(381124190, 1102, 'SU18', 1104, 'SU18'),
(381124190, 3333, 'SU18', 3335, 'FA18'),
(381124192, 2234, 'FA18', 7766, 'SP19'),
(381124192, 3232, 'FA18', 7788, 'SP19'),
(381124194, 1106, 'SU18', 6565, 'SP19'),
(381124194, 5543, 'FA18', 6688, 'SP19'),
(381124196, 2208, 'SU18', 2311, 'FA18'),
(381124196, 2234, 'FA18', 7766, 'SP19'),
(381124198, 2122, 'FA18', 6678, 'SP19'),
(381124198, 2222, 'FA18', 2223, 'FA18'),
(381124200, 2122, 'FA18', 6678, 'SP19'),
(381124200, 2123, 'FA18', 1009, 'FA18'),
(381124202, 2210, 'FA18', 6655, 'SP19'),
(381124202, 2311, 'FA18', 6776, 'SP19'),
(381124204, 1100, 'SU18', 5544, 'SP19'),
(381124204, 1106, 'SU18', 6565, 'SP19'),
(381124206, 2234, 'FA18', 7766, 'SP19'),
(381124206, 3333, 'SU18', 3335, 'SU18');

-- --------------------------------------------------------

--
-- Table structure for table `section`
--

CREATE TABLE `section` (
  `ScheduleCode` int(4) NOT NULL,
  `SemesterCode` varchar(4) NOT NULL,
  `SectionLetter` varchar(1) NOT NULL,
  `Time` time NOT NULL,
  `Room` varchar(7) NOT NULL,
  `CurrentEnrollment` int(2) NOT NULL,
  `MaximumEnrollment` int(2) NOT NULL DEFAULT 30,
  `FacultyNum` int(3) NOT NULL,
  `CourseNum` int(3) NOT NULL,
  `DepartmentCode` varchar(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `section`
--

INSERT INTO `section` (`ScheduleCode`, `SemesterCode`, `SectionLetter`, `Time`, `Room`, `CurrentEnrollment`, `MaximumEnrollment`, `FacultyNum`, `CourseNum`, `DepartmentCode`) VALUES
(1009, 'FA18', 'A', '14:15:00', '', 1, 30, 264, 101, 'CS'),
(1011, 'FA18', 'B', '11:15:00', '', 24, 30, 518, 101, 'CS'),
(1100, 'SU18', 'A', '10:45:00', '', 0, 30, 280, 201, 'PS'),
(1102, 'SU18', 'A', '11:00:00', '', 2, 30, 661, 151, 'ENG'),
(1104, 'SU18', 'B', '12:20:00', '', 13, 30, 153, 151, 'ENG'),
(1106, 'SU18', 'A', '10:45:00', '', 1, 30, 194, 221, 'MTH'),
(2122, 'FA18', 'A', '13:25:00', '', 29, 30, 944, 101, 'MTH'),
(2123, 'FA18', 'A', '13:00:00', '', 11, 30, 525, 101, 'PS'),
(2208, 'SU18', 'A', '12:25:00', '', 26, 30, 214, 201, 'MUS'),
(2210, 'FA18', 'A', '16:00:00', '', 0, 30, 518, 262, 'CS'),
(2211, 'FA18', 'A', '13:45:00', '', 28, 30, 893, 162, 'CS'),
(2222, 'FA18', 'A', '10:45:00', '', 5, 30, 372, 80, 'ENG'),
(2223, 'FA18', 'B', '15:15:00', '', 23, 30, 372, 80, 'ENG'),
(2232, 'FA18', 'B', '11:00:00', '', 3, 30, 194, 201, 'MTH'),
(2234, 'FA18', 'A', '14:00:00', '', 22, 30, 563, 280, 'ENG'),
(2239, 'SU18', 'A', '15:00:00', '', 0, 30, 264, 221, 'CS'),
(2311, 'FA18', 'A', '12:15:00', '', 5, 30, 724, 201, 'MUS'),
(2323, 'FA18', 'A', '14:15:00', '', 14, 30, 724, 141, 'MUS'),
(3232, 'FA18', 'A', '14:00:00', '', 20, 30, 214, 151, 'MUS'),
(3323, 'FA18', 'A', '14:00:00', '', 29, 30, 264, 171, 'CS'),
(3333, 'SU18', 'A', '08:30:00', '', 26, 30, 181, 171, 'CS'),
(3335, 'SU18', 'B', '08:30:00', '', 4, 30, 181, 171, 'CS'),
(4433, 'FA18', 'A', '08:45:00', '', 25, 30, 518, 221, 'CS'),
(5543, 'FA18', 'A', '11:00:00', '', 1, 30, 280, 131, 'PS'),
(5544, 'SP19', 'A', '15:20:00', '', 14, 30, 171, 201, 'PS'),
(5567, 'SP19', 'A', '13:30:00', '', 3, 30, 372, 151, 'ENG'),
(6565, 'SP19', 'A', '10:45:00', '', 7, 30, 194, 221, 'MTH'),
(6655, 'SP19', 'A', '10:45:00', '', 9, 30, 181, 262, 'CS'),
(6678, 'SP19', 'B', '09:00:00', '', 13, 30, 194, 101, 'MTH'),
(6688, 'SP19', 'A', '11:00:00', '', 0, 30, 525, 131, 'PS'),
(6776, 'SP19', 'A', '15:15:00', '', 2, 30, 214, 201, 'MUS'),
(7766, 'SP19', 'A', '11:45:00', '', 9, 30, 153, 280, 'ENG'),
(7788, 'SP19', 'A', '12:00:00', '', 3, 30, 724, 151, 'MUS'),
(8887, 'SP19', 'B', '09:50:00', '', 21, 30, 724, 141, 'MUS');

-- --------------------------------------------------------

--
-- Table structure for table `semester`
--

CREATE TABLE `semester` (
  `SemesterCode` varchar(4) NOT NULL,
  `StartDate` date NOT NULL,
  `EndDate` date NOT NULL,
  `ExamStartDate` date NOT NULL,
  `ExamEndDate` date NOT NULL,
  `WithdrawalDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `semester`
--

INSERT INTO `semester` (`SemesterCode`, `StartDate`, `EndDate`, `ExamStartDate`, `ExamEndDate`, `WithdrawalDate`) VALUES
('FA18', '2018-08-19', '2018-12-15', '2018-12-08', '2018-12-15', '2018-12-01'),
('SP19', '2019-01-12', '2019-05-15', '2019-05-08', '2019-05-15', '2018-05-01'),
('SU18', '2018-06-04', '2018-07-28', '2018-07-21', '2018-07-28', '2018-07-14');

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `StudentNum` int(10) NOT NULL,
  `LastName` varchar(40) NOT NULL,
  `FirstName` varchar(40) NOT NULL,
  `LocalStreet` varchar(100) DEFAULT NULL,
  `LocalCity` varchar(20) DEFAULT NULL,
  `LocalState` varchar(13) DEFAULT NULL,
  `LocalZip` varchar(10) DEFAULT NULL,
  `PermStreet` varchar(100) NOT NULL,
  `PermCity` varchar(20) NOT NULL,
  `PermState` varchar(13) NOT NULL,
  `PermZip` varchar(10) NOT NULL,
  `CreditsTaken` int(3) NOT NULL DEFAULT 0,
  `CreditsEarned` int(3) NOT NULL DEFAULT 0,
  `GPA` decimal(3,2) NOT NULL DEFAULT 0.00,
  `TotalPoints` decimal(4,1) NOT NULL DEFAULT 0.0,
  `ClassStanding` int(3) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`StudentNum`, `LastName`, `FirstName`, `LocalStreet`, `LocalCity`, `LocalState`, `LocalZip`, `PermStreet`, `PermCity`, `PermState`, `PermZip`, `CreditsTaken`, `CreditsEarned`, `GPA`, `TotalPoints`, `ClassStanding`) VALUES
(381124188, 'Starks', 'Frederick', '', '', '', '', '8006 Howard Ave.', 'Baring', 'ID', '83224', 0, 0, '0.00', '0.0', 0),
(381124190, 'Pelc', 'Joe', '', '', '', '', '123 E. Main', 'St. Joseph', 'MO', '64777', 0, 0, '0.00', '0.0', 0),
(381124192, 'Ng', 'Arron', '', '', '', '', '345 E. Oak', 'Kansas City', 'MO', '64888', 0, 0, '0.00', '0.0', 0),
(381124194, 'Apple', 'Abbie', '1234 Education Way', 'Douglas', 'ID', '83260', '', '', '', '', 0, 0, '0.00', '0.0', 0),
(381124196, 'Butler', 'Bobbie', '1235 Education Way', 'Douglas', 'ID', '83260', '', '', '', '', 0, 0, '0.00', '0.0', 0),
(381124198, 'Candy', 'Candace', '1236 Education Way', 'Douglas', 'ID', '83260', '', '', '', '', 0, 0, '0.00', '0.0', 0),
(381124200, 'Doolittle', 'Dan', '', '', '', '', '8888 W. 88th', 'Nowhere', 'NM', '83260', 0, 0, '0.00', '0.0', 0),
(381124202, 'Evergreen', 'Eddy', '1237 Education Way', 'Douglas', 'ID', '83260', '', '', '', '', 0, 0, '0.00', '0.0', 0),
(381124204, 'Gump', 'Forrest', '1238 Education Way', 'Douglas', 'ID', '83260', '', '', '', '', 0, 0, '0.00', '0.0', 0),
(381124206, 'Jones', 'Indiana', '1239 Education Way', 'Douglas', 'ID', '83260', '', '', '', '', 0, 0, '0.00', '0.0', 0);

-- --------------------------------------------------------

--
-- Table structure for table `student_class`
--

CREATE TABLE `student_class` (
  `StudentNum` int(10) NOT NULL,
  `ScheduleCode` int(4) NOT NULL,
  `SemesterCode` varchar(4) NOT NULL,
  `Grade` varchar(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `student_class`
--

INSERT INTO `student_class` (`StudentNum`, `ScheduleCode`, `SemesterCode`, `Grade`) VALUES
(381124188, 1009, 'FA18', 'A'),
(381124188, 2122, 'FA18', 'B'),
(381124188, 2123, 'FA18', 'A'),
(381124190, 1100, 'SU18', 'B'),
(381124190, 1102, 'SU18', 'B'),
(381124190, 1106, 'SU18', 'A'),
(381124192, 5544, 'SP19', 'B'),
(381124192, 5567, 'SP19', 'C'),
(381124192, 6565, 'SP19', 'A'),
(381124194, 3232, 'FA18', 'C'),
(381124194, 4433, 'FA18', 'C'),
(381124194, 5543, 'FA18', 'B'),
(381124196, 2122, 'FA18', 'B'),
(381124196, 2123, 'FA18', 'A'),
(381124196, 2222, 'FA18', 'B'),
(381124198, 6688, 'SP19', 'D'),
(381124198, 7766, 'SP19', 'C'),
(381124198, 8887, 'SP19', 'B'),
(381124200, 1104, 'SU18', 'B'),
(381124200, 2208, 'SU18', 'A'),
(381124200, 3335, 'SU18', 'D'),
(381124202, 1104, 'SU18', 'A'),
(381124202, 2208, 'SU18', 'A'),
(381124202, 3335, 'SU18', 'C'),
(381124204, 2122, 'FA18', 'A'),
(381124204, 2123, 'FA18', 'B'),
(381124204, 2210, 'FA18', 'A'),
(381124206, 3232, 'FA18', 'C'),
(381124206, 4433, 'FA18', 'B'),
(381124206, 5543, 'FA18', 'A');

-- --------------------------------------------------------

--
-- Table structure for table `student_grade`
--

CREATE TABLE `student_grade` (
  `StudentNum` int(10) NOT NULL,
  `CourseNum` int(3) NOT NULL,
  `DepartmentCode` varchar(3) NOT NULL,
  `SemesterCode` varchar(4) NOT NULL,
  `Grade` varchar(1) NOT NULL,
  `CreditsEarned` int(3) NOT NULL,
  `GradePoints` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `student_grade`
--

INSERT INTO `student_grade` (`StudentNum`, `CourseNum`, `DepartmentCode`, `SemesterCode`, `Grade`, `CreditsEarned`, `GradePoints`) VALUES
(381124192, 151, 'ENG', 'SP19', 'C', 3, '2.00'),
(381124192, 201, 'PS', 'SP19', 'B', 3, '3.00'),
(381124192, 221, 'MTH', 'SP19', 'A', 3, '4.00'),
(381124194, 131, 'PS', 'FA18', 'B', 3, '3.00'),
(381124194, 151, 'MUS', 'FA18', 'C', 3, '2.00'),
(381124194, 221, 'CS', 'FA18', 'C', 4, '2.00'),
(381124196, 80, 'ENG', 'FA18', 'B', 3, '3.00'),
(381124196, 101, 'MTH', 'FA18', 'B', 2, '3.00'),
(381124196, 101, 'PS', 'FA18', 'A', 3, '4.00'),
(381124198, 131, 'PS', 'SP19', 'D', 3, '1.00'),
(381124198, 141, 'MUS', 'SP19', 'B', 2, '3.00'),
(381124198, 280, 'ENG', 'SP19', 'C', 3, '2.00'),
(381124200, 151, 'ENG', 'SU18', 'B', 3, '3.00'),
(381124200, 171, 'CS', 'SU18', 'D', 3, '1.00'),
(381124200, 201, 'MUS', 'SU18', 'A', 3, '4.00'),
(381124202, 151, 'ENG', 'SU18', 'A', 3, '4.00'),
(381124202, 171, 'CS', 'SU18', 'C', 3, '2.00'),
(381124202, 201, 'MUS', 'SU18', 'A', 3, '4.00'),
(381124204, 101, 'MTH', 'FA18', 'A', 2, '4.00'),
(381124204, 101, 'PS', 'FA18', 'B', 3, '3.00'),
(381124204, 262, 'CS', 'FA18', 'A', 4, '4.00'),
(381124206, 131, 'PS', 'FA18', 'A', 3, '4.00'),
(381124206, 151, 'MUS', 'FA18', 'C', 3, '2.00'),
(381124206, 221, 'CS', 'FA18', 'B', 4, '3.00');

-- --------------------------------------------------------

--
-- Structure for view `classlist`
--
DROP TABLE IF EXISTS `classlist`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `classlist`  AS  select `m`.`Description` AS `Description`,`d`.`DepartmentCode` AS `DepartmentCode`,`c`.`CourseNum` AS `CourseNum`,`f`.`FacultyNum` AS `FacultyNum`,concat(`f`.`FirstName`,' ',`f`.`LastName`) AS `Instructor`,`sec`.`SectionLetter` AS `Section`,`sec`.`SemesterCode` AS `Term`,`sec`.`Time` AS `Time`,`sec`.`Room` AS `Room`,`c`.`NumCredits` AS `Credits`,`s`.`StudentNum` AS `StudentNum`,concat(`s`.`FirstName`,' ',`s`.`LastName`) AS `StudentName`,`s`.`ClassStanding` AS `ClassStanding`,`sg`.`Grade` AS `Grade` from ((((((`student` `s` join `student_grade` `sg` on(`s`.`StudentNum` = `sg`.`StudentNum`)) join `course` `c` on(`sg`.`CourseNum` = `c`.`CourseNum`)) join `department` `d` on(`d`.`DepartmentCode` = `c`.`DepartmentCode`)) join `faculty` `f` on(`f`.`DepartmentCode` = `d`.`DepartmentCode`)) join `section` `sec` on(`f`.`FacultyNum` = `sec`.`FacultyNum`)) join `major` `m` on(`m`.`DepartmentCode` = `d`.`DepartmentCode`)) ;

-- --------------------------------------------------------

--
-- Structure for view `registration`
--
DROP TABLE IF EXISTS `registration`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `registration`  AS  select `s`.`StudentNum` AS `StudentNum`,concat(`s`.`FirstName`,' ',`s`.`LastName`) AS `Name`,`s`.`PermStreet` AS `PermanentAddress`,`s`.`PermCity` AS `PermCity`,`s`.`PermState` AS `PermState`,`s`.`PermZip` AS `PermZip`,`s`.`LocalStreet` AS `LocalAddress`,`s`.`LocalCity` AS `LocalCity`,`s`.`LocalState` AS `LocalState`,`s`.`LocalZip` AS `LocalZip`,`req`.`ScheduleCode` AS `ScheduleCode`,`req`.`SemesterCode` AS `Term`,`req`.`AlternateScheduleCode` AS `AlternateScheduleCode`,`req`.`AlternateSemesterCode` AS `AlternateTerm` from (`student` `s` join `registration_request` `req` on(`s`.`StudentNum` = `req`.`StudentNum`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `advises`
--
ALTER TABLE `advises`
  ADD PRIMARY KEY (`MajorNum`,`StudentNum`),
  ADD KEY `StudentNum` (`StudentNum`),
  ADD KEY `FacultyNum` (`FacultyNum`);

--
-- Indexes for table `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`CourseNum`,`DepartmentCode`),
  ADD KEY `course_DeptCodeFK_1` (`DepartmentCode`);

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`DepartmentCode`);

--
-- Indexes for table `faculty`
--
ALTER TABLE `faculty`
  ADD PRIMARY KEY (`FacultyNum`),
  ADD KEY `OfficeNum` (`OfficeNum`),
  ADD KEY `faculty_DeptCodeFK_1` (`DepartmentCode`);

--
-- Indexes for table `major`
--
ALTER TABLE `major`
  ADD PRIMARY KEY (`MajorNum`),
  ADD KEY `DepartmentCode` (`DepartmentCode`);

--
-- Indexes for table `office`
--
ALTER TABLE `office`
  ADD PRIMARY KEY (`OfficeNum`);

--
-- Indexes for table `prereq`
--
ALTER TABLE `prereq`
  ADD PRIMARY KEY (`CourseNum`,`DepartmentCode`,`PrereqDepartmentCode`),
  ADD KEY `DepartmentCode` (`DepartmentCode`),
  ADD KEY `PrereqDepartmentCode` (`PrereqDepartmentCode`),
  ADD KEY `PrereqCourseNum` (`PrereqCourseNum`);

--
-- Indexes for table `registration_request`
--
ALTER TABLE `registration_request`
  ADD PRIMARY KEY (`StudentNum`,`ScheduleCode`,`SemesterCode`),
  ADD KEY `ScheduleCode` (`ScheduleCode`),
  ADD KEY `SemesterCode` (`SemesterCode`),
  ADD KEY `AlternateScheduleCode` (`AlternateScheduleCode`),
  ADD KEY `AlternateSemesterCode` (`AlternateSemesterCode`);

--
-- Indexes for table `section`
--
ALTER TABLE `section`
  ADD PRIMARY KEY (`ScheduleCode`,`SemesterCode`),
  ADD KEY `section_SemesterCodeFK_1` (`SemesterCode`),
  ADD KEY `section_FacultyNumFK_2` (`FacultyNum`),
  ADD KEY `DepartmentCode` (`DepartmentCode`),
  ADD KEY `CourseNum` (`CourseNum`);

--
-- Indexes for table `semester`
--
ALTER TABLE `semester`
  ADD PRIMARY KEY (`SemesterCode`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`StudentNum`);

--
-- Indexes for table `student_class`
--
ALTER TABLE `student_class`
  ADD PRIMARY KEY (`StudentNum`,`ScheduleCode`,`SemesterCode`),
  ADD KEY `ScheduleCode` (`ScheduleCode`),
  ADD KEY `SemesterCode` (`SemesterCode`);

--
-- Indexes for table `student_grade`
--
ALTER TABLE `student_grade`
  ADD PRIMARY KEY (`StudentNum`,`CourseNum`,`SemesterCode`,`DepartmentCode`),
  ADD KEY `DepartmentCode` (`DepartmentCode`),
  ADD KEY `SemesterCode` (`SemesterCode`),
  ADD KEY `CourseNum` (`CourseNum`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `advises`
--
ALTER TABLE `advises`
  ADD CONSTRAINT `advises_ibfk_1` FOREIGN KEY (`MajorNum`) REFERENCES `major` (`MajorNum`),
  ADD CONSTRAINT `advises_ibfk_2` FOREIGN KEY (`StudentNum`) REFERENCES `student` (`StudentNum`),
  ADD CONSTRAINT `advises_ibfk_3` FOREIGN KEY (`FacultyNum`) REFERENCES `faculty` (`FacultyNum`);

--
-- Constraints for table `course`
--
ALTER TABLE `course`
  ADD CONSTRAINT `course_DeptCodeFK_1` FOREIGN KEY (`DepartmentCode`) REFERENCES `department` (`DepartmentCode`);

--
-- Constraints for table `faculty`
--
ALTER TABLE `faculty`
  ADD CONSTRAINT `faculty_DeptCodeFK_1` FOREIGN KEY (`DepartmentCode`) REFERENCES `department` (`DepartmentCode`),
  ADD CONSTRAINT `faculty_OfficeNumFK_1` FOREIGN KEY (`OfficeNum`) REFERENCES `office` (`OfficeNum`);

--
-- Constraints for table `major`
--
ALTER TABLE `major`
  ADD CONSTRAINT `major_ibfk_1` FOREIGN KEY (`DepartmentCode`) REFERENCES `department` (`DepartmentCode`);

--
-- Constraints for table `prereq`
--
ALTER TABLE `prereq`
  ADD CONSTRAINT `prereq_ibfk_2` FOREIGN KEY (`DepartmentCode`) REFERENCES `department` (`DepartmentCode`),
  ADD CONSTRAINT `prereq_ibfk_3` FOREIGN KEY (`PrereqDepartmentCode`) REFERENCES `department` (`DepartmentCode`),
  ADD CONSTRAINT `prereq_ibfk_4` FOREIGN KEY (`CourseNum`) REFERENCES `course` (`CourseNum`),
  ADD CONSTRAINT `prereq_ibfk_5` FOREIGN KEY (`PrereqCourseNum`) REFERENCES `course` (`CourseNum`);

--
-- Constraints for table `registration_request`
--
ALTER TABLE `registration_request`
  ADD CONSTRAINT `registration_request_ibfk_1` FOREIGN KEY (`StudentNum`) REFERENCES `student` (`StudentNum`),
  ADD CONSTRAINT `registration_request_ibfk_2` FOREIGN KEY (`ScheduleCode`) REFERENCES `section` (`ScheduleCode`),
  ADD CONSTRAINT `registration_request_ibfk_3` FOREIGN KEY (`SemesterCode`) REFERENCES `semester` (`SemesterCode`),
  ADD CONSTRAINT `registration_request_ibfk_4` FOREIGN KEY (`AlternateScheduleCode`) REFERENCES `section` (`ScheduleCode`),
  ADD CONSTRAINT `registration_request_ibfk_5` FOREIGN KEY (`AlternateSemesterCode`) REFERENCES `semester` (`SemesterCode`);

--
-- Constraints for table `section`
--
ALTER TABLE `section`
  ADD CONSTRAINT `section_FacultyNumFK_2` FOREIGN KEY (`FacultyNum`) REFERENCES `faculty` (`FacultyNum`),
  ADD CONSTRAINT `section_SemesterCodeFK_1` FOREIGN KEY (`SemesterCode`) REFERENCES `semester` (`SemesterCode`),
  ADD CONSTRAINT `section_ibfk_1` FOREIGN KEY (`DepartmentCode`) REFERENCES `department` (`DepartmentCode`),
  ADD CONSTRAINT `section_ibfk_2` FOREIGN KEY (`CourseNum`) REFERENCES `course` (`CourseNum`);

--
-- Constraints for table `student_class`
--
ALTER TABLE `student_class`
  ADD CONSTRAINT `student_class_ibfk_1` FOREIGN KEY (`StudentNum`) REFERENCES `student` (`StudentNum`),
  ADD CONSTRAINT `student_class_ibfk_2` FOREIGN KEY (`ScheduleCode`) REFERENCES `section` (`ScheduleCode`),
  ADD CONSTRAINT `student_class_ibfk_3` FOREIGN KEY (`SemesterCode`) REFERENCES `semester` (`SemesterCode`);

--
-- Constraints for table `student_grade`
--
ALTER TABLE `student_grade`
  ADD CONSTRAINT `student_grade_ibfk_2` FOREIGN KEY (`DepartmentCode`) REFERENCES `department` (`DepartmentCode`),
  ADD CONSTRAINT `student_grade_ibfk_3` FOREIGN KEY (`StudentNum`) REFERENCES `student` (`StudentNum`),
  ADD CONSTRAINT `student_grade_ibfk_4` FOREIGN KEY (`SemesterCode`) REFERENCES `section` (`SemesterCode`),
  ADD CONSTRAINT `student_grade_ibfk_5` FOREIGN KEY (`CourseNum`) REFERENCES `course` (`CourseNum`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
