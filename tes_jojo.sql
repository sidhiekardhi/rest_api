-- phpMyAdmin SQL Dump
-- version 4.8.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 23, 2020 at 08:42 AM
-- Server version: 10.1.32-MariaDB
-- PHP Version: 7.2.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tes_jojo`
--

-- --------------------------------------------------------

--
-- Table structure for table `company`
--

CREATE TABLE `company` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `company`
--

INSERT INTO `company` (`id`, `name`, `address`) VALUES
(1, 'pt dika', 'jalan benhil'),
(2, 'jojonomic', 'ciputat');

-- --------------------------------------------------------

--
-- Table structure for table `company_budget`
--

CREATE TABLE `company_budget` (
  `id` bigint(20) NOT NULL,
  `company_id` bigint(20) NOT NULL,
  `amount` decimal(19,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `company_budget`
--

INSERT INTO `company_budget` (`id`, `company_id`, `amount`) VALUES
(1, 1, '0.00'),
(2, 2, '410000.00');

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `id` bigint(20) NOT NULL,
  `type` varchar(100) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `company_id` int(11) NOT NULL,
  `amount` decimal(19,2) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`id`, `type`, `user_id`, `company_id`, `amount`, `date`) VALUES
(1, 'R', 1, 0, '10000.00', '2020-10-23 00:57:53'),
(2, 'R', 2, 0, '50000.00', '2020-10-23 00:57:53'),
(4, 'R', 1, 0, '10000.00', '2020-10-23 01:32:58'),
(8, 'R', 1, 0, '40000.00', '2020-10-23 02:18:36'),
(13, 'R', 1, 0, '50000.00', '2020-10-23 03:16:06'),
(14, 'R', 1, 1, '40000.00', '2020-10-23 04:28:55'),
(15, 'S', 1, 1, '30000.00', '2020-10-23 06:12:31'),
(16, 'R', 1, 1, '60000.00', '2020-10-23 06:13:14'),
(17, 'S', 1, 2, '10000.00', '2020-10-23 06:15:38'),
(18, 'C', 1, 1, '100000.00', '2020-10-23 06:21:30'),
(19, 'C', 1, 1, '2300000.00', '2020-10-23 06:22:35'),
(20, 'C', 1, 1, '100000.00', '2020-10-23 06:26:11'),
(21, 'R', 1, 1, '100000.00', '2020-10-23 06:27:59'),
(22, 'S', 1, 1, '500000.00', '2020-10-23 06:29:01'),
(23, 'R', 1, 1, '230000000.00', '2020-10-23 06:40:44');

--
-- Triggers `transaction`
--
DELIMITER $$
CREATE TRIGGER `log_amount_disburse` AFTER INSERT ON `transaction` FOR EACH ROW BEGIN
    UPDATE company_budget
        SET amount= company_budget.amount+New.amount where company_budget.company_id=NEW.company_id AND NEW.type="S";
 END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_amount_reimburst` BEFORE INSERT ON `transaction` FOR EACH ROW BEGIN
    UPDATE company_budget
        SET amount= company_budget.amount-New.amount >= 0 where company_budget.company_id=NEW.company_id AND NEW.type="R";
 END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` bigint(20) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `account` varchar(100) NOT NULL,
  `company_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `first_name`, `last_name`, `email`, `account`, `company_id`) VALUES
(1, 'sidhiek', 'aja', 'sidika@gmail.com', 'instagram', 2),
(2, 'maulana', 'fiananta', 'maul05@gmail.com', 'facebook', 1),
(3, 'johny', 'deep', 'johny_deep@gmail.com', 'instagram', 2);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `company`
--
ALTER TABLE `company`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `company_budget`
--
ALTER TABLE `company_budget`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `company`
--
ALTER TABLE `company`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `company_budget`
--
ALTER TABLE `company_budget`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
