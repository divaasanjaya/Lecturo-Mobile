<?php
include "config.php";

// Clear any previous output
if (ob_get_length()) ob_clean();
header("Content-Type: application/json");

try {
    // Get and validate input
    $input = file_get_contents("php://input");
    if (empty($input)) {
        throw new Exception("No input data received");
    }

    $data = json_decode($input, true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception("Invalid JSON input: " . json_last_error_msg());
    }

    // Check required parameters
    $required = ["NIM", "nama", "kodeKelas"];
    foreach ($required as $param) {
        if (!isset($data[$param])) {
            throw new Exception("Missing required parameter: " . $param);
        }
    }

    $NIM = $data["NIM"];
    $nama = $data["nama"];
    $kodeKelas = $data["kodeKelas"];

    // Start transaction
    $conn->begin_transaction();

    // 1. Check if student already exists
    $checkQuery = $conn->prepare("SELECT NIM FROM mahasiswa WHERE NIM = ?");
    $checkQuery->bind_param("i", $NIM);
    $checkQuery->execute();
    $checkQuery->store_result();
    
    if ($checkQuery->num_rows > 0) {
        throw new Exception("Mahasiswa dengan NIM tersebut sudah terdaftar");
    }
    $checkQuery->close();

    // 2. Get course code for the class
    $getMatkulQuery = $conn->prepare("SELECT kodeMatkul FROM course WHERE kodeKelas = ?");
    $getMatkulQuery->bind_param("s", $kodeKelas);
    $getMatkulQuery->execute();
    $result = $getMatkulQuery->get_result();
    
    if ($result->num_rows == 0) {
        throw new Exception("Tidak ditemukan mata kuliah untuk kelas ini");
    }
    
    $matkulData = $result->fetch_assoc();
    $kodeMatkul = $matkulData['kodeMatkul'];
    $getMatkulQuery->close();

    // 3. Insert into mahasiswa table
    $insertMahasiswa = $conn->prepare("INSERT INTO mahasiswa (NIM, nama, kodeKelas) VALUES (?, ?, ?)");
    $insertMahasiswa->bind_param("iss", $NIM, $nama, $kodeKelas);
    
    if (!$insertMahasiswa->execute()) {
        throw new Exception("Gagal menambahkan ke tabel mahasiswa: " . $conn->error);
    }
    $insertMahasiswa->close();

    // 4. Insert into course_mahasiswa table
    $insertCourseMhs = $conn->prepare("INSERT INTO course_mahasiswa (kodeMatkul, NIM) VALUES (?, ?)");
    $insertCourseMhs->bind_param("si", $kodeMatkul, $NIM);
    
    if (!$insertCourseMhs->execute()) {
        throw new Exception("Gagal menambahkan ke tabel course_mahasiswa: " . $conn->error);
    }
    $insertCourseMhs->close();

    // 5. Find all quizzes for this course and class
    $getQuizzesQuery = $conn->prepare("SELECT nama FROM quiz WHERE kodeMatkul = ? AND kodeKelas = ?");
    $getQuizzesQuery->bind_param("ss", $kodeMatkul, $kodeKelas);
    $getQuizzesQuery->execute();
    $quizzesResult = $getQuizzesQuery->get_result();
    
    $quizzesAssigned = 0;
    // 6. For each quiz found, insert record into mahasiswa_quiz with value 0
    while ($quiz = $quizzesResult->fetch_assoc()) {
        $insertQuizQuery = $conn->prepare("INSERT INTO mahasiswa_quiz (nim, nilai, namaQuiz, kodeKelas) VALUES (?, ?, ?, ?)");
        $nilai = 0;
        $insertQuizQuery->bind_param("iiss", $NIM, $nilai, $quiz['nama'], $kodeKelas);
        
        if (!$insertQuizQuery->execute()) {
            throw new Exception("Gagal menambahkan quiz untuk mahasiswa: " . $conn->error);
        }
        $insertQuizQuery->close();
        $quizzesAssigned++;
    }
    $getQuizzesQuery->close();

    // Commit transaction if all successful
    $conn->commit();

    $response = [
        "success" => true, 
        "message" => "Mahasiswa berhasil ditambahkan ke semua tabel termasuk quiz",
        "data" => [
            "NIM" => $NIM,
            "nama" => $nama,
            "kodeKelas" => $kodeKelas,
            "kodeMatkul" => $kodeMatkul,
            "quizzes_assigned" => $quizzesAssigned
        ]
    ];

} catch (Exception $e) {
    // Rollback on error
    if (isset($conn) && $conn instanceof mysqli) {
        $conn->rollback();
    }
    
    $response = [
        "success" => false, 
        "message" => $e->getMessage(),
        "error" => isset($conn) ? $conn->error : null
    ];
}

// Ensure no output before this
if (ob_get_length()) ob_clean();
echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);

if (isset($conn) && $conn instanceof mysqli) {
    $conn->close();
}
exit();
?>