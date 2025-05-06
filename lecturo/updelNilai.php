<?php
include "config.php";

header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data["nim"]) && isset($data["namaQuiz"]) && isset($data["kodeKelas"]) && isset($data["nilai"])) {
    
    $nim = $data["nim"];
    $namaQuiz = $data["namaQuiz"];
    $kodeKelas = $data["kodeKelas"];
    $nilai = $data["nilai"];

    $query = $conn->prepare("UPDATE mahasiswa_quiz SET nilai = ? WHERE nim = ? AND namaQuiz = ? AND kodeKelas = ?");
    $query->bind_param("iiss", $nilai, $nim, $namaQuiz, $kodeKelas);
    $query->execute();
    $result = $query->get_result();

    $query->close();
} else {
    echo json_encode(["success" => false, "message" => "Parameter tidak lengkap"]);
}

$conn->close();
?>
