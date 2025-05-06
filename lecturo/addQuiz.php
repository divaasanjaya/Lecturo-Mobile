<?php
include "config.php";
header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if (
    isset($data["nama"]) &&
    isset($data["kodeMatkul"]) &&
    isset($data["deskripsi"]) &&
    isset($data["kodeKelas"])
) {
    $nama = $data["nama"];
    $kodeMatkul = $data["kodeMatkul"];
    $deskripsi = $data["deskripsi"];
    $kodeKelas = $data["kodeKelas"];

    $query = $conn->prepare("INSERT INTO quiz (nama, kodeMatkul, deskripsi, kodeKelas) VALUES (?, ?, ?, ?)");
    $query->bind_param("ssss", $nama, $kodeMatkul, $deskripsi, $kodeKelas);

    if ($query->execute()) {
        echo json_encode(["success" => true, "message" => "Quiz berhasil ditambahkan."]);
    } else {
        echo json_encode(["success" => false, "message" => "Gagal menambahkan quiz."]);
    }

    $query->close();
} else {
    echo json_encode(["success" => false, "message" => "Parameter tidak lengkap."]);
}

$conn->close();
?>
