<?php
include "config.php";
header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data["NIM"])) {
    $NIM = $data["NIM"];

    $checkQuery = $conn->prepare("SELECT NIM FROM mahasiswa WHERE NIM = ?");
    $checkQuery->bind_param("i", $NIM);
    $checkQuery->execute();
    $checkQuery->store_result();
    
    if ($checkQuery->num_rows == 0) {
        echo json_encode(["success" => false, "message" => "Mahasiswa dengan NIM tersebut tidak ditemukan"]);
        $checkQuery->close();
        $conn->close();
        exit();
    }
    $checkQuery->close();
    $deleteQuery = $conn->prepare("DELETE FROM mahasiswa WHERE NIM = ?");
    $deleteQuery->bind_param("i", $NIM);

    if ($deleteQuery->execute()) {
        echo json_encode([
            "success" => true, 
            "message" => "Mahasiswa berhasil dihapus",
            "deleted_NIM" => $NIM
        ]);
    } else {
        echo json_encode([
            "success" => false, 
            "message" => "Gagal menghapus mahasiswa",
            "error" => $conn->error
        ]);
    }

    $deleteQuery->close();
} else {
    echo json_encode(["success" => false, "message" => "Parameter NIM harus disertakan"]);
}

$conn->close();
?>