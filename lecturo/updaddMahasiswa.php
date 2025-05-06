<?php
include "config.php";
header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if (
    isset($data["NIM"]) &&
    isset($data["nama"]) &&
    isset($data["kodeKelas"])
) {
    $NIM = $data["NIM"];
    $nama = $data["nama"];
    $kodeKelas = $data["kodeKelas"];

    // Check if student already exists
    $checkQuery = $conn->prepare("SELECT NIM FROM mahasiswa WHERE NIM = ?");
    $checkQuery->bind_param("i", $NIM);
    $checkQuery->execute();
    $checkQuery->store_result();
    
    if ($checkQuery->num_rows > 0) {
        echo json_encode([
            "success" => false, 
            "message" => "Mahasiswa dengan NIM tersebut sudah terdaftar"
        ]);
        $checkQuery->close();
        $conn->close();
        exit();
    }
    $checkQuery->close();

    // Insert new student
    $insertQuery = $conn->prepare("INSERT INTO mahasiswa (NIM, nama, kodeKelas) VALUES (?, ?, ?)");
    $insertQuery->bind_param("iss", $NIM, $nama, $kodeKelas);

    if ($insertQuery->execute()) {
        echo json_encode([
            "success" => true, 
            "message" => "Mahasiswa berhasil ditambahkan",
            "data" => [
                "NIM" => $NIM,
                "nama" => $nama,
                "kodeKelas" => $kodeKelas
            ]
        ]);
    } else {
        echo json_encode([
            "success" => false, 
            "message" => "Gagal menambahkan mahasiswa",
            "error" => $conn->error
        ]);
    }

    $insertQuery->close();
} else {
    echo json_encode([
        "success" => false, 
        "message" => "Parameter tidak lengkap",
        "required_parameters" => ["NIM", "nama", "kodeKelas"]
    ]);
}

$conn->close();
?>