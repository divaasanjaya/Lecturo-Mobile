<?php
include "config.php";
header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data["kodeMatkul"]) && isset($data["kodeKelas"])) {
    $kodeMatkul = $data["kodeMatkul"];
    $kodeKelas = $data["kodeKelas"];

    $query = $conn->prepare("
        SELECT m.NIM, m.nama, m.kodeKelas 
        FROM mahasiswa m
        JOIN course_mahasiswa cm ON m.NIM = cm.NIM
        WHERE cm.kodeMatkul = ? AND m.kodeKelas = ?
    ");
    $query->bind_param("ss", $kodeMatkul, $kodeKelas);
    $query->execute();
    $result = $query->get_result();

    $mahasiswa = [];
    while ($row = $result->fetch_assoc()) {
        $mahasiswa[] = $row;
    }

    echo json_encode([
        "success" => true, 
        "mahasiswa" => $mahasiswa,
        "count" => count($mahasiswa)
    ]);

    $query->close();
} else {
    echo json_encode([
        "success" => false, 
        "message" => "Parameter kodeMatkul diperlukan."
    ]);
}

$conn->close();
?>