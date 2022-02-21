-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 05 Haz 2021, 10:29:03
-- Sunucu sürümü: 10.4.18-MariaDB
-- PHP Sürümü: 7.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `alomity`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `oyuncular`
--

CREATE TABLE `oyuncular` (
  `sqlid` int(11) NOT NULL,
  `adminlevel` int(2) DEFAULT 0,
  `isim` varchar(24) DEFAULT '0',
  `sifre` varchar(70) DEFAULT '0',
  `songiris` varchar(24) DEFAULT '0',
  `IP` varchar(16) CHARACTER SET latin5 DEFAULT '0',
  `skor` int(11) DEFAULT 0,
  `kiyafet` int(11) DEFAULT 0,
  `para` int(11) DEFAULT 0,
  `oldurme` int(11) DEFAULT 0,
  `olme` int(11) DEFAULT 0,
  `cX` float DEFAULT 0,
  `cY` float DEFAULT 0,
  `cZ` float DEFAULT 0,
  `cA` float DEFAULT 0,
  `ban` float DEFAULT 0,
  `Ilkbakis` int(2) NOT NULL DEFAULT 0,
  `susturdakika` int(11) DEFAULT NULL,
  `hapisdakika` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `yasaklar`
--

CREATE TABLE `yasaklar` (
  `yasakID` int(11) NOT NULL,
  `yasaklanan` varchar(24) NOT NULL,
  `yasaklayan` varchar(24) NOT NULL,
  `sebep` varchar(50) NOT NULL,
  `yasakip` varchar(16) NOT NULL,
  `bitis` int(15) NOT NULL,
  `islemtarih` int(15) NOT NULL,
  `bitistarih` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin5;

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `oyuncular`
--
ALTER TABLE `oyuncular`
  ADD PRIMARY KEY (`sqlid`);

--
-- Tablo için indeksler `yasaklar`
--
ALTER TABLE `yasaklar`
  ADD PRIMARY KEY (`yasakID`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `oyuncular`
--
ALTER TABLE `oyuncular`
  MODIFY `sqlid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
