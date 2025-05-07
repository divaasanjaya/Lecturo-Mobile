<?php
include "config.php";

// Clear any previous output and set JSON header
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
    $required = ["NIM", "kodeMatkul"];
    foreach ($required as $param) {
        if (!isset($data[$param])) {
            throw new Exception("Parameter $param harus disertakan");
        }
    }

    $NIM = $data["NIM"];
    $kodeMatkul = $data["kodeMatkul"];

    // Start transaction
    $conn->begin_transaction();

    // 1. Check if student exists
    $checkQuery = $conn->prepare("SELECT NIM FROM mahasiswa WHERE NIM = ?");
    $checkQuery->bind_param("s", $NIM);
    $checkQuery->execute();
    $checkQuery->store_result();
    
    if ($checkQuery->num_rows == 0) {
        throw new Exception("Mahasiswa dengan NIM tersebut tidak ditemukan");
    }
    $checkQuery->close();

    // 2. Get class code from course
    $getKelasQuery = $conn->prepare("SELECT kodeKelas FROM course WHERE kodeMatkul = ?");
    $getKelasQuery->bind_param("s", $kodeMatkul);
    $getKelasQuery->execute();
    $kelasResult = $getKelasQuery->get_result();
    
    if ($kelasResult->num_rows == 0) {
        throw new Exception("Mata kuliah dengan kode tersebut tidak ditemukan");
    }
    
    $kelasData = $kelasResult->fetch_assoc();
    $kodeKelas = $kelasData['kodeKelas'];
    $getKelasQuery->close();

    // 3. Delete student's quiz records for this course
    $deleteQuizQuery = $conn->prepare("
        DELETE mq FROM mahasiswa_quiz mq
        JOIN quiz q ON mq.namaQuiz = q.nama AND mq.kodeKelas = q.kodeKelas
        WHERE mq.nim = ? 
        AND q.kodeMatkul = ?
        AND mq.kodeKelas = ?
    ");
    $deleteQuizQuery->bind_param("sss", $NIM, $kodeMatkul, $kodeKelas);
    
    if (!$deleteQuizQuery->execute()) {
        throw new Exception("Gagal menghapus data quiz mahasiswa: " . $conn->error);
    }
    $quizDeleted = $deleteQuizQuery->affected_rows;
    $deleteQuizQuery->close();

    // 4. Delete from course_mahasiswa
    $deleteCourseQuery = $conn->prepare("DELETE FROM course_mahasiswa WHERE NIM = ? AND kodeMatkul = ?");
    $deleteCourseQuery->bind_param("ss", $NIM, $kodeMatkul);

    if (!$deleteCourseQuery->execute()) {
        throw new Exception("Gagal menghapus data mahasiswa dari course: " . $conn->error);
    }

    $courseDeleted = $deleteCourseQuery->affected_rows;
    $deleteCourseQuery->close();

    if ($courseDeleted === 0) {
        throw new Exception("Tidak ada data yang dihapus (NIM dan kodeMatkul tidak cocok)");
    }

    // Commit transaction if all successful
    $conn->commit();

    $response = [
        "success" => true, 
        "message" => "Data mahasiswa berhasil dihapus dari course dan quiz terkait",
        "data" => [
            "deleted_NIM" => $NIM,
            "deleted_kodeMatkul" => $kodeMatkul,
            "deleted_kodeKelas" => $kodeKelas,
            "quiz_records_deleted" => $quizDeleted,
            "course_records_deleted" => $courseDeleted
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

// Ensure clean output
if (ob_get_length()) ob_clean();
echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);

if (isset($conn) && $conn instanceof mysqli) {
    $conn->close();
}
exit();
?>