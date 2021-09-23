-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 23, 2021 at 04:18 PM
-- Server version: 10.4.20-MariaDB
-- PHP Version: 7.3.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `letgo`
--

-- --------------------------------------------------------

--
-- Table structure for table `localtion`
--

CREATE TABLE `localtion` (
  `id` int(11) NOT NULL,
  `listid` text COLLATE utf8_unicode_ci NOT NULL,
  `avatar` text COLLATE utf8_unicode_ci NOT NULL,
  `name` text COLLATE utf8_unicode_ci NOT NULL,
  `phone` text COLLATE utf8_unicode_ci NOT NULL,
  `des` text COLLATE utf8_unicode_ci NOT NULL,
  `lat` text COLLATE utf8_unicode_ci NOT NULL,
  `lng` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `localtion`
--

INSERT INTO `localtion` (`id`, `listid`, `avatar`, `name`, `phone`, `des`, `lat`, `lng`) VALUES
(14, '1', '/letgo/location/avatar32845.jpg', 'Supachai', '0800888899', 'สุดซอย 13', '13.6865362', '100.6180355'),
(19, '', '$avatar', '$name', '', '$des', '$lat', '$lng'),
(20, '1', '/letgo/location/avatar39714.jpg', 'Earth', '0956368899', 'หน้าร้านทอง', '01.153131', '12.54445313'),
(21, '1', '/letgo/location/avatar39714.jpg', 'Earth', '0956368899', 'หน้าร้านทอง', '01.153131', '12.54445313'),
(26, '1', '/letgo/location/avatar11440.jpg', 'yy', '777', 'yy', '13.5814371', '100.6489036'),
(27, '1', '/letgo/location/avatar3145.jpg', 'hdhhehsh', '0800512131', 'hhcgdjejdudjdjhr', '13.5908767', '100.6308108'),
(28, '1', '/letgo/location/avatar1734.jpg', 'hdhhehsh', '0800512131', 'hhcgdjejdudjdjhr', '13.5908767', '100.6308108'),
(29, '1', '/letgo/location/avatar13238.jpg', 'ooooo', '089046748', 'ท้ายซอย13', '13.686542', '100.6180652'),
(30, '1', '/letgo/location/avatar26936.jpg', 'ruaj', '048390', 'dhsjj', '13.6865306', '100.6180488'),
(32, '1', '/letgo/location/avatar32845.jpg', 'Supachai', '0800888899', 'สุดซอย 13', '13.6865362', '100.6180355'),
(33, '0', '', 'aaaa', '0800456613', 'Seven-eleven', '37.421998333333335', '-122.084'),
(34, '0', '', 'qwe', '0231123456', 'Ufo', '37.421998333333335', '-122.084'),
(35, '0', '', 'aaaaaaaa', 'asdasd', 'asdas', '37.421998333333335', '-122.084'),
(36, '0', '', 'asdda', 'asd', 'asd', '37.421998333333335', '-122.084'),
(37, '0', '', 'สมสี', '0987675545', 'หน้าซอย', '37.421998333333335', '-122.084');

-- --------------------------------------------------------

--
-- Table structure for table `qwin`
--

CREATE TABLE `qwin` (
  `id` int(11) NOT NULL,
  `winnum` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `qwin`
--

INSERT INTO `qwin` (`id`, `winnum`) VALUES
(32, '64'),
(34, '67'),
(37, '77'),
(38, '99'),
(39, '97');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `name` text COLLATE utf8_unicode_ci NOT NULL,
  `phone` text COLLATE utf8_unicode_ci NOT NULL,
  `email` text COLLATE utf8_unicode_ci NOT NULL,
  `password` text COLLATE utf8_unicode_ci NOT NULL,
  `avatar` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `name`, `phone`, `email`, `password`, `avatar`) VALUES
(1, 'qqq', 'qqq', 'qqq', 'qqq', ''),
(2, 'aaa', 'aaa', 'aaa', 'aaa', ''),
(4, 'ppp', 'ppp', 'ppp', 'ppp', '/letgo/avatar/avatar75037.jpg'),
(5, 'aaa', 'aaa', 'eee', 'eee', '/letgo/avatar/avatar70535.jpg'),
(6, 'supachai', '0800738788', 'mintio1233@gmail.com', '16032543', '/letgo/avatar/avatar31578.jpg'),
(7, 'akkaraphon', '0947974850', 'tam@gmail.com', '11111111', '/letgo/avatar/avatar20667.jpg'),
(8, 'iii', '000', 'iii', 'iii', '/letgo/avatar/avatar92685.jpg'),
(9, 'tam', '08966369974', 'tam', '111', '/letgo/avatar/avatar73948.jpg'),
(15, 'tam', '0853369745', 'mintio12@hotmail', '111111', '/letgo/avatar/avatar77504.jpg'),
(27, 'asdasdasd', 'asdsdsd', 'sdas', 'asd', ''),
(28, 'asd', 'asd', 'sdasd', 'asdasd', ''),
(29, 'asddd', 'asddd', '', 'asddd', ''),
(30, 'asd', 'asd', 'asd', 'asd', '');

-- --------------------------------------------------------

--
-- Table structure for table `windata`
--

CREATE TABLE `windata` (
  `id` int(11) NOT NULL,
  `name` text COLLATE utf8_unicode_ci NOT NULL,
  `phone` text COLLATE utf8_unicode_ci NOT NULL,
  `motornum` text COLLATE utf8_unicode_ci NOT NULL,
  `avatar` text COLLATE utf8_unicode_ci NOT NULL,
  `winnum` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `windata`
--

INSERT INTO `windata` (`id`, `name`, `phone`, `motornum`, `avatar`, `winnum`) VALUES
(2, 'ศรันย์ ซีโมน', '0987789878', '2กข7689 กรุงเทพ', '/letgo/avatarWin/avatar77635.jpg', '64'),
(3, 'อัครพล สร้อยทอง', '0987765768', '7กท 346 กทม.', '/letgo/avatarWin/avatar84344.jpg', '99'),
(4, 'ทะนะวัด ของใหญ่', '0987896678', '4ขย 678 กทม.', '/letgo/avatarWin/avatar81034.jpg', '67'),
(9, 'tgdf', '009768445', 'fh bkk', '/letgo/avatarWin/avatar75441.jpg', '77'),
(10, 'simson', '0987695678', 'jh bkk', '/letgo/avatarWin/avatar70340.jpg', '97');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `localtion`
--
ALTER TABLE `localtion`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `qwin`
--
ALTER TABLE `qwin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `windata`
--
ALTER TABLE `windata`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `localtion`
--
ALTER TABLE `localtion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `qwin`
--
ALTER TABLE `qwin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `windata`
--
ALTER TABLE `windata`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
