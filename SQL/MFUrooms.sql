-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Oct 23, 2024 at 06:54 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `MFUrooms`
--

-- --------------------------------------------------------

--
-- Table structure for table `Building`
--

CREATE TABLE `Building` (
  `ID` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Building`
--

INSERT INTO `Building` (`ID`) VALUES
('C1'),
('C2'),
('D1');

-- --------------------------------------------------------

--
-- Table structure for table `History`
--

CREATE TABLE `History` (
  `id` int(11) NOT NULL,
  `roomID` int(11) DEFAULT NULL,
  `requestBy` int(11) DEFAULT NULL,
  `borrow_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  `approver` int(11) DEFAULT NULL,
  `lender` int(11) DEFAULT NULL,
  `approveStatus` tinyint(4) DEFAULT NULL COMMENT 'Null = pending, 0 = rejected, 1 = approved',
  `borrowStatus` tinyint(4) DEFAULT NULL COMMENT 'Null = rejected ,0 = not borrowed yet, 1 = not returned, 2 = returned'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `History`
--

INSERT INTO `History` (`id`, `roomID`, `requestBy`, `borrow_date`, `return_date`, `approver`, `lender`, `approveStatus`, `borrowStatus`) VALUES
(1, 1, 1, '2024-10-01', '2024-10-05', 2, 3, 1, 2),
(2, 2, 2, '2024-10-02', '2024-10-06', 1, 3, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `Request`
--

CREATE TABLE `Request` (
  `id` int(11) NOT NULL,
  `roomID` int(11) DEFAULT NULL,
  `requestBy` int(11) DEFAULT NULL,
  `borrow_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Request`
--

INSERT INTO `Request` (`id`, `roomID`, `requestBy`, `borrow_date`, `return_date`) VALUES
(1, 1, 1, '2024-10-01', '2024-10-05');

-- --------------------------------------------------------

--
-- Table structure for table `Room`
--

CREATE TABLE `Room` (
  `ID` int(11) NOT NULL,
  `building` varchar(10) DEFAULT NULL,
  `image` varchar(50) DEFAULT NULL,
  `status` tinyint(4) DEFAULT NULL CHECK (`status` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Room`
--

INSERT INTO `Room` (`ID`, `building`, `image`, `status`) VALUES
(1, 'C1', 'room1.jpg', 1),
(2, 'C1', 'room2.jpg', 0),
(3, 'C2', 'room3.jpg', 1),
(4, 'C1', 'room4.jpg', 1),
(5, 'C1', 'room5.jpg', 0),
(6, 'C2', 'room6.jpg', 1),
(7, 'D1', 'room7.jpg', 0),
(8, 'D1', 'room8.jpg', 1),
(9, 'D1', 'room9.jpg', 0),
(10, 'C2', 'room10.jpg', 1);

-- --------------------------------------------------------

--
-- Table structure for table `User`
--

CREATE TABLE `User` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0 = user, 1 = approver, 2 = staff',
  `borrowQuota` int(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `User`
--

INSERT INTO `User` (`id`, `email`, `password`, `role`, `borrowQuota`) VALUES
(1, 'user@example.com', '$2b$10$Mezb8Ek15oSk32T.JZu2cOmHV0J.mhK/x5PeIHlYlAS9zWj3nRL/i', 0, 1),
(2, 'approver@example.com', '$2b$10$Mezb8Ek15oSk32T.JZu2cOmHV0J.mhK/x5PeIHlYlAS9zWj3nRL/i', 1, 1),
(3, 'staff@example.com', '$2b$10$Mezb8Ek15oSk32T.JZu2cOmHV0J.mhK/x5PeIHlYlAS9zWj3nRL/i', 2, 1),
(4, 'Tese@Email.com', '$2b$10$okDFzW1mksE2TebzP3trHupcHmFgvcBrXJbR2FahyJ6k6rR42LKMy', 0, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Building`
--
ALTER TABLE `Building`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `History`
--
ALTER TABLE `History`
  ADD PRIMARY KEY (`id`),
  ADD KEY `roomID` (`roomID`),
  ADD KEY `requestBy` (`requestBy`),
  ADD KEY `approver` (`approver`),
  ADD KEY `lender` (`lender`);

--
-- Indexes for table `Request`
--
ALTER TABLE `Request`
  ADD PRIMARY KEY (`id`),
  ADD KEY `roomID` (`roomID`),
  ADD KEY `requestBy` (`requestBy`);

--
-- Indexes for table `Room`
--
ALTER TABLE `Room`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `building` (`building`);

--
-- Indexes for table `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `History`
--
ALTER TABLE `History`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `Request`
--
ALTER TABLE `Request`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `User`
--
ALTER TABLE `User`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `History`
--
ALTER TABLE `History`
  ADD CONSTRAINT `history_ibfk_1` FOREIGN KEY (`roomID`) REFERENCES `Room` (`ID`),
  ADD CONSTRAINT `history_ibfk_2` FOREIGN KEY (`requestBy`) REFERENCES `User` (`id`),
  ADD CONSTRAINT `history_ibfk_3` FOREIGN KEY (`approver`) REFERENCES `User` (`id`),
  ADD CONSTRAINT `history_ibfk_4` FOREIGN KEY (`lender`) REFERENCES `User` (`id`);

--
-- Constraints for table `Request`
--
ALTER TABLE `Request`
  ADD CONSTRAINT `request_ibfk_1` FOREIGN KEY (`roomID`) REFERENCES `Room` (`ID`),
  ADD CONSTRAINT `request_ibfk_2` FOREIGN KEY (`requestBy`) REFERENCES `User` (`id`);

--
-- Constraints for table `Room`
--
ALTER TABLE `Room`
  ADD CONSTRAINT `room_ibfk_1` FOREIGN KEY (`building`) REFERENCES `Building` (`ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
