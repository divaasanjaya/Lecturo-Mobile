<?php
include "config.php";
header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data["kodeKelas"])) {
    $kodeKelas = $data["kodeKelas"];

    $query = $conn->prepare("SELECT * FROM mahasiswa WHERE kodeKelas = ?");
    $query->bind_param("s", $kodeKelas);
    $query->execute();
    $result = $query->get_result();

    $mahasiswa = [];
    while ($row = $result->fetch_assoc()) {
        $mahasiswa[] = $row;
    }

    echo json_encode(["success" => true, "mahasiswa" => $mahasiswa]);

    $query->close();
} else {
    echo json_encode(["success" => false, "message" => "Parameter kodeKelas diperlukan."]);
}

$conn->close();
?>