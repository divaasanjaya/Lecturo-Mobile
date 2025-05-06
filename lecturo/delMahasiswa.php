<?php
include "config.php";
header("Content-Type: application/json");

ob_start();

try {
    $data = json_decode(file_get_contents("php://input"), true);
    
    if (!$data || !isset($data["NIM"]) || !isset($data["kodeMatkul"])) {
        throw new Exception("Parameter NIM dan kodeMatkul harus disertakan");
    }

    $NIM = $data["NIM"];
    $kodeMatkul = $data["kodeMatkul"];

    $checkQuery = $conn->prepare("SELECT NIM FROM mahasiswa WHERE NIM = ?");
    $checkQuery->bind_param("s", $NIM);
    $checkQuery->execute();
    $checkQuery->store_result();
    
    if ($checkQuery->num_rows == 0) {
        throw new Exception("Mahasiswa dengan NIM tersebut tidak ditemukan");
    }
    $checkQuery->close();

    $deleteQuery = $conn->prepare("DELETE FROM course_mahasiswa WHERE NIM = ? AND kodeMatkul = ?");
    $deleteQuery->bind_param("ss", $NIM, $kodeMatkul);

    if (!$deleteQuery->execute()) {
        throw new Exception("Gagal menghapus data mahasiswa dari course: " . $conn->error);
    }

    $affectedRows = $deleteQuery->affected_rows;
    $deleteQuery->close();

    if ($affectedRows === 0) {
        throw new Exception("Tidak ada data yang dihapus (NIM dan kodeMatkul tidak cocok)");
    }

    $response = [
        "success" => true, 
        "message" => "Data mahasiswa berhasil dihapus dari course",
        "deleted_NIM" => $NIM,
        "deleted_kodeMatkul" => $kodeMatkul,
        "affected_rows" => $affectedRows
    ];

} catch (Exception $e) {
    $response = [
        "success" => false, 
        "message" => $e->getMessage()
    ];
}

// Clean any output buffer
ob_end_clean();
echo json_encode($response);
$conn->close();
?>