<?php
include "config.php";

header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data["kodeDosen"]) && isset($data["kodeAbdimas"])) {
    $kodeDosen = $data["kodeDosen"];
    $kodeAbdimas = $data["kodeAbdimas"];

    $query = $conn->prepare("DELETE FROM dosen_abdimas WHERE kodeDosen = ? AND kodeAbdimas = ?");
    $query->bind_param("si", $kodeDosen, $kodeAbdimas);
    $query->execute();
    $result = $query->get_result();

    $query = $conn->prepare("DELETE FROM abdimas WHERE kode = ?");
    $query->bind_param("i", $kodeAbdimas);
    $query->execute();
    $result = $query->get_result();

    $query->close();
} else {
    echo json_encode(["success" => false, "message" => "Parameter tidak lengkap"]);
}

$conn->close();
?>
