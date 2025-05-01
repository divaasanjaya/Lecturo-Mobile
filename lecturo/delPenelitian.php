<?php
include "config.php";

header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data["kodeDosen"]) && isset($data["kodePenelitian"])) {
    $kodeDosen = $data["kodeDosen"];
    $kodePenelitian = $data["kodePenelitian"];

    $query = $conn->prepare("DELETE FROM dosen_penelitian WHERE kodeDosen = ? AND kodePenelitian = ?");
    $query->bind_param("si", $kodeDosen, $kodePenelitian);
    $query->execute();
    $result = $query->get_result();

    $query = $conn->prepare("DELETE FROM penelitian WHERE kode = ?");
    $query->bind_param("i", $kodePenelitian);
    $query->execute();
    $result = $query->get_result();

    $query->close();
} else {
    echo json_encode(["success" => false, "message" => "Parameter tidak lengkap"]);
}

$conn->close();
?>
