-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 07, 2025 at 06:23 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lecturo`
--

-- --------------------------------------------------------

--
-- Table structure for table `abdimas`
--

CREATE TABLE `abdimas` (
  `kode` int(10) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `deskripsi` text NOT NULL,
  `tanggal` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `abdimas`
--

INSERT INTO `abdimas` (`kode`, `nama`, `deskripsi`, `tanggal`) VALUES
(1, 'Bimbingan Belajar untuk Siswa SD', 'Program bimbingan belajar gratis bagi siswa SD di wilayah perbatasan', '2024-12-20'),
(2, 'Community Service Learning 2024', 'Kegiatan ini dilakukan di desa Arjasari, Bandung, Jawa Barat', '2024-10-15'),
(3, 'Penanaman Mangrove di Pantai Anyer', 'Kegiatan penanaman 500 bibit mangrove untuk mencegah abrasi', '2024-12-18');

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE `course` (
  `kodeMatkul` varchar(10) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `kodeKelas` varchar(10) NOT NULL,
  `sks` int(1) NOT NULL,
  `dosenPengampu` varchar(3) NOT NULL,
  `tahunAjaran` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `course`
--

INSERT INTO `course` (`kodeMatkul`, `nama`, `kodeKelas`, `sks`, `dosenPengampu`, `tahunAjaran`) VALUES
('CAK3BAB3', 'PEMROGRAMAN BERORIENTASI OBJEK', 'IF-46-06', 4, 'DSW', 'Genap 2024/2025'),
('CDK2AAB4', 'STRUKTUR DATA', 'DS-47-02', 4, 'AFA', 'Ganjil 2024/2025'),
('CII1D3', 'KALKULUS', 'IF-48-04', 3, 'DSW', 'Ganjil 2024/2025'),
('CII2K2', 'STRATEGI ALGORITMA', 'IF-47-06', 3, 'DSW', 'Genap 2024/2025'),
('CAK3BAB3', 'PEMROGRAMAN BERORIENTASI OBJEK', 'IF-46-07', 4, 'AFA', 'Genap 2024/2025'),
('CAK3BAB5', 'STATISTIKA', 'IF-47-08', 2, 'DSW', 'Ganjil 2024/2025');

-- --------------------------------------------------------

--
-- Table structure for table `course_mahasiswa`
--

CREATE TABLE `course_mahasiswa` (
  `kodeMatkul` varchar(10) NOT NULL,
  `NIM` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `course_mahasiswa`
--

INSERT INTO `course_mahasiswa` (`kodeMatkul`, `NIM`) VALUES
('CAK3BAB3', 1301223248),
('CAK3BAB3', 1301223357),
('CAK3BAB3', 1301223401),
('CAK3BAB3', 1301220317),
('CAK3BAB3', 1301223068);

-- --------------------------------------------------------

--
-- Table structure for table `dosen`
--

CREATE TABLE `dosen` (
  `kode` varchar(3) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `fakultas` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dosen`
--

INSERT INTO `dosen` (`kode`, `nama`, `fakultas`, `password`) VALUES
('AFA', 'Azra Feby', 'FIF', 'azraa'),
('DSW', 'Diva Sanjaya', 'FIF', 'divaa');

-- --------------------------------------------------------

--
-- Table structure for table `dosenkoor`
--

CREATE TABLE `dosenkoor` (
  `kodeDosen` varchar(3) NOT NULL,
  `matkulKoor` varchar(100) NOT NULL,
  `kontakKoor` varchar(12) NOT NULL,
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dosenkoor`
--

INSERT INTO `dosenkoor` (`kodeDosen`, `matkulKoor`, `kontakKoor`, `email`) VALUES
('AFA', 'CAK3BAB3', '082225555866', 'azrafeby@telkomuniversity.ac.id'),
('AFA', 'CAK3BAB5', '082225555866', 'azrafeby@telkomuniversity.ac.id'),
('AFA', 'CDK2AAB4', '082225555866', 'azrafeby@telkomuniversity.ac.id'),
('DSW', 'CII1D3', '082128925896', 'divawardani@telkomuniversity.ac.id'),
('DSW', 'CII2K2', '082128925896', 'divawardani@telkomuniversity.ac.id');

-- --------------------------------------------------------

--
-- Table structure for table `dosen_abdimas`
--

CREATE TABLE `dosen_abdimas` (
  `kodeDosen` varchar(3) NOT NULL,
  `kodeAbdimas` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dosen_abdimas`
--

INSERT INTO `dosen_abdimas` (`kodeDosen`, `kodeAbdimas`) VALUES
('AFA', 1),
('AFA', 2),
('DSW', 3);

-- --------------------------------------------------------

--
-- Table structure for table `dosen_penelitian`
--

CREATE TABLE `dosen_penelitian` (
  `kodeDosen` varchar(3) NOT NULL,
  `kodePenelitian` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dosen_penelitian`
--

INSERT INTO `dosen_penelitian` (`kodeDosen`, `kodePenelitian`) VALUES
('AFA', 2),
('DSW', 1),
('DSW', 3),
('DSW', 9);

-- --------------------------------------------------------

--
-- Table structure for table `mahasiswa`
--

CREATE TABLE `mahasiswa` (
  `NIM` int(10) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `kodeKelas` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mahasiswa`
--

INSERT INTO `mahasiswa` (`NIM`, `nama`, `kodeKelas`) VALUES
(1301220317, 'Alviko Pradipta Harianto', 'IF-46-06'),
(1301221345, 'Lyodra Ginting', 'IF-48-04'),
(1301223056, 'Mahalini Raharja', 'IF-47-06'),
(1301223068, 'Salma Atika Poerwadi', 'IF-46-07'),
(1301223167, 'Diva Sanjaya Wardani', 'IF-46-06'),
(1301223248, 'Muthia Rihadatul Aisyi', 'IF-46-06'),
(1301223357, 'Nasywa Alif Widyasari', 'IF-46-06'),
(1301223401, 'Farah Saraswati', 'IF-46-06');

-- --------------------------------------------------------

--
-- Table structure for table `mahasiswa_quiz`
--

CREATE TABLE `mahasiswa_quiz` (
  `nim` int(10) NOT NULL,
  `nilai` int(3) DEFAULT NULL,
  `namaQuiz` text NOT NULL,
  `kodeKelas` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mahasiswa_quiz`
--

INSERT INTO `mahasiswa_quiz` (`nim`, `nilai`, `namaQuiz`, `kodeKelas`) VALUES
(1301223248, 90, 'Quiz 1: Class Diagram', 'IF-46-06'),
(1301223248, 85, 'Quiz 2: MVC', 'IF-46-06'),
(1301223357, 80, 'Quiz 1: Class Diagram', 'IF-46-06'),
(1301223357, 90, 'Quiz 2: MVC', 'IF-46-06'),
(1301223401, 90, 'Quiz 1: Class Diagram', 'IF-46-06'),
(1301223401, 88, 'Quiz 2: MVC', 'IF-46-06'),
(1301220317, 80, 'Quiz 1: Class Diagram', 'IF-46-06'),
(1301220317, 78, 'Quiz 2: MVC', 'IF-46-06'),
(1301223248, 0, 'Quiz 3: GUI', 'IF-46-06'),
(1301223357, 0, 'Quiz 3: GUI', 'IF-46-06'),
(1301223401, 0, 'Quiz 3: GUI', 'IF-46-06'),
(1301220317, 0, 'Quiz 3: GUI', 'IF-46-06'),
(1301221345, 0, 'Quiz 1: Class Diagram', 'IF-46-06'),
(1301221345, 0, 'Quiz 2: MVC', 'IF-46-06'),
(1301221345, 0, 'Quiz 3: GUI', 'IF-46-06');

-- --------------------------------------------------------

--
-- Table structure for table `penelitian`
--

CREATE TABLE `penelitian` (
  `kode` int(10) NOT NULL,
  `nama` text NOT NULL,
  `bidang` varchar(100) NOT NULL,
  `deskripsi` text NOT NULL,
  `tanggal` date DEFAULT NULL,
  `tautan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `penelitian`
--

INSERT INTO `penelitian` (`kode`, `nama`, `bidang`, `deskripsi`, `tanggal`, `tautan`) VALUES
(1, 'Pengklasifikasian Lokalisasi Protein pada Bakteri E. Coli Menggunakan Metode K-Nearest Neighbor', 'AI', 'RingkasanâPenelitian ini membahas penerapan model K-Nearest Neighbor (KNN) untuk memprediksi kelas lokalisasi protein bakteri E. coli berdasarkan dataset yang terdiri dari 336 data. Dataset ini menghadapi tantangan data yang tidak seimbang, sehingga menggunakan perbandingan antara metrik evaluasi F1-score dan akurasi. Metrik evaluasi F1-score sering digunakan untuk pengklasifikasian data yang tidak seimbang. Data yang sudah melalui proses pre-processing dibagi menggunakan teknik K-Fold Cross-Validation dengan pembagian 5 fold. Selanjutnya, data diproses dengan model KNN dan dilakukan tuning hyperparameter dengan range k 1 sampai 15 untuk mendapatkan k neighbor yang paling baik saat memprediksi kelas dari bakteri E.coli. Hasil tuning hyperparameter menunjukkan bahwa performa terbaik untuk F1 score tercapai pada k=13 dengan rata-rata sebesar 74,72%, sedangkan untuk akurasi maksimal pada k=7 dengan rata-rata sebesar 86,87%. Namun, model menunjukkan adanya underfitting akibat jumlah data yang tidak terlalu banyak dan ketidakseimbangan kelas', '2024-11-26', 'https:/pebeo/penelitian/ai/ecoli'),
(2, 'Analisis Kinerja Metode K-Nearest Neighbor pada Dataset Heart Disease Prediction untuk Deteksi Penyakit Jantung', 'Artificial Intelligence', 'Ringkasan—Penyakit jantung adalah salah satu penyebab utama kematian di seluruh dunia, sehingga sangat penting untuk mendeteksi lebih awal secara efektif agar dapat menurunkan risiko dan jumlah kematian akibat kondisi ini. Penelitian ini bertujuan untuk menggunakan algoritma K-Nearest Neighbor (KNN) untuk memprediksi risiko penyakit jantung dengan menggunakan dataset yang mencakup data medis seperti usia, jenis kelamin, tekanan darah, tingkat kolesterol, dan detak jantung. Dataset ini digunakan untuk mengkategorikan orang-orang berdasarkan status risiko mereka terhadap penyakit jantung. Metode KNN dipilih karena kemampuannya dalam mengkategorikan informasi berdasarkan kedekatan dengan titik data lain. Penilaian model dilakukan dengan cara memeriksa akurasi, presisi, recall, dan F1-Score. Hasil dari penelitian ini menunjukkan bahwa model KNN dapat menghasilkan prediksi yang akurat dengan tingkat akurasi yang cukup baik, yang dapat dimanfaatkan untuk membantu dalam pengambilan keputusan medis terkait deteksi penyakit jantung.', '2023-12-05', 'https:/pebeo/penelitian/ai/jantung'),
(3, 'Klasifikasi Wine Menggunakan Metode K-Nearest Neighbors', 'Artificial Intelligence', 'Ringkasan—Klasifikasi wine bertujuan untuk mengidentifikasi jenis dan kualitas wine secara otomatis untuk mendukung pengambilan keputusan dalam industri wine. Penelitian ini bertujuan untuk mengevaluasi kinerja metode K-Nearest Neighbors (K-NN) dalam mengklasifikasikan dataset wine, yang memiliki fitur numerik dan beberapa kelas. Metode ini dipilih karena kesederhanaannya dan efektivitasnya dalam menangani data berbasis jarak. Untuk menghindari bias, digunakan teknik validasi k-fold cross-validation dengan parameter utama berupa jumlah tetangga terdekat (k). Hasil eksperimen menunjukkan bahwa konfigurasi k = 5 menghasilkan akurasi terbaik sebesar 96,00%, sedangkan k = 8 memberikan F1-Score tertinggi sebesar 96,11%. Temuan ini menunjukkan bahwa K-NN memiliki potensi yang signifikan dalam klasifikasi wine, dengan hasil yang kompetitif meskipun pada dataset dengan fitur terbatas.\r\n', '2017-03-27', 'https:/pebeo/penelitian/ai/wine'),
(9, 'Perbandingan Algoritma Klasifikasi K-Nearest Neighbors (KNN) vs Naive Bayes untuk Deteksi Penyakit Diabetes', 'Artificial Intelligence', 'RingkasanâPenelitian ini bertujuan untuk membandingkan performa dua algoritma klasifikasi, yaitu K-Nearest Neighbors (KNN) dan NaÃ¯ve Bayes, dalam mendeteksi penyakit diabetes. KNN merupakan algoritma berbasis jarak yang bekerja dengan mengelompokkan data berdasarkan kedekatannya dengan tetangga terdekat, sedangkan NaÃ¯ve Bayes memanfaatkan pendekatan probabilistik berdasarkan prinsip teorema Bayes. Dataset yang digunakan dalam penelitian ini terdiri dari berbagai fitur seperti kadar glukosa, tekanan darah, indeks massa tubuh (BMI), dan faktor-faktor lain yang relevan untuk deteksi diabetes.  Evaluasi dilakukan dengan membagi dataset menjadi data latih dan data uji menggunakan skema pembagian 80:20. Kedua algoritma diukur performanya menggunakan metrik seperti akurasi, precision, recall, dan F1-score. Hasil menunjukkan bahwa KNN mencapai akurasi sebesar 77,16\\% dengan nilai recall yang lebih tinggi, yang mencerminkan kemampuan algoritma ini dalam mendeteksi sebagian besar kasus positif. Di sisi lain, NaÃ¯ve Baye', '2025-01-01', 'https:/pebeo/penelitian/ai/diabetes');

-- --------------------------------------------------------

--
-- Table structure for table `quiz`
--

CREATE TABLE `quiz` (
  `nama` text NOT NULL,
  `kodeMatkul` varchar(10) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `kodeKelas` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quiz`
--

INSERT INTO `quiz` (`nama`, `kodeMatkul`, `deskripsi`, `kodeKelas`) VALUES
('Quiz 1: Class Diagram', 'CAK3BAB3', 'Tuesday, 31 December 2024, 12:40 PM', 'IF-46-06'),
('Quiz 2: MVC', 'CAK3BAB3', 'Friday, 3 January 2025, 12:59 PM', 'IF-46-06'),
('Quiz 3: GUI', 'CAK3BAB3', 'Saturday, 4 January 2025, 12:59 PPM', 'IF-46-06');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `abdimas`
--
ALTER TABLE `abdimas`
  ADD PRIMARY KEY (`kode`);

--
-- Indexes for table `course`
--
ALTER TABLE `course`
  ADD KEY `fk_dosenPengampu` (`dosenPengampu`);

--
-- Indexes for table `course_mahasiswa`
--
ALTER TABLE `course_mahasiswa`
  ADD KEY `course_mahasiswa_ibfk_1` (`NIM`);

--
-- Indexes for table `dosen`
--
ALTER TABLE `dosen`
  ADD PRIMARY KEY (`kode`);

--
-- Indexes for table `dosenkoor`
--
ALTER TABLE `dosenkoor`
  ADD PRIMARY KEY (`matkulKoor`);

--
-- Indexes for table `dosen_abdimas`
--
ALTER TABLE `dosen_abdimas`
  ADD PRIMARY KEY (`kodeDosen`,`kodeAbdimas`),
  ADD KEY `kodeAbdimas` (`kodeAbdimas`);

--
-- Indexes for table `dosen_penelitian`
--
ALTER TABLE `dosen_penelitian`
  ADD PRIMARY KEY (`kodeDosen`,`kodePenelitian`),
  ADD KEY `kodePenelitian` (`kodePenelitian`);

--
-- Indexes for table `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD PRIMARY KEY (`NIM`);

--
-- Indexes for table `mahasiswa_quiz`
--
ALTER TABLE `mahasiswa_quiz`
  ADD KEY `nim` (`nim`);

--
-- Indexes for table `penelitian`
--
ALTER TABLE `penelitian`
  ADD PRIMARY KEY (`kode`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `abdimas`
--
ALTER TABLE `abdimas`
  MODIFY `kode` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `penelitian`
--
ALTER TABLE `penelitian`
  MODIFY `kode` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `course`
--
ALTER TABLE `course`
  ADD CONSTRAINT `fk_dosenPengampu` FOREIGN KEY (`dosenPengampu`) REFERENCES `dosen` (`kode`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `course_mahasiswa`
--
ALTER TABLE `course_mahasiswa`
  ADD CONSTRAINT `course_mahasiswa_ibfk_1` FOREIGN KEY (`NIM`) REFERENCES `mahasiswa` (`NIM`) ON DELETE CASCADE;

--
-- Constraints for table `dosen_abdimas`
--
ALTER TABLE `dosen_abdimas`
  ADD CONSTRAINT `dosen_abdimas_ibfk_1` FOREIGN KEY (`kodeDosen`) REFERENCES `dosen` (`kode`) ON DELETE CASCADE,
  ADD CONSTRAINT `dosen_abdimas_ibfk_2` FOREIGN KEY (`kodeAbdimas`) REFERENCES `abdimas` (`kode`) ON DELETE CASCADE;

--
-- Constraints for table `dosen_penelitian`
--
ALTER TABLE `dosen_penelitian`
  ADD CONSTRAINT `dosen_penelitian_ibfk_1` FOREIGN KEY (`kodeDosen`) REFERENCES `dosen` (`kode`) ON DELETE CASCADE,
  ADD CONSTRAINT `dosen_penelitian_ibfk_2` FOREIGN KEY (`kodePenelitian`) REFERENCES `penelitian` (`kode`) ON DELETE CASCADE;

--
-- Constraints for table `mahasiswa_quiz`
--
ALTER TABLE `mahasiswa_quiz`
  ADD CONSTRAINT `mahasiswa_quiz_ibfk_1` FOREIGN KEY (`nim`) REFERENCES `mahasiswa` (`NIM`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
