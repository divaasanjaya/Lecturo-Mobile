<?php
include "config.php";

header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);
error_reporting(E_ALL);
ini_set('display_errors', 1);


if (isset($data["kode"])) {
    $kode = $data["kode"];

    $query = $conn->prepare("SELECT * FROM dosen WHERE kode = ?");
    $query->bind_param("s", $kode);
    $query->execute();
    $result = $query->get_result();

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();
        echo json_encode(["success" => true, "dosen" => $user]);
    } else {
        echo json_encode(["success" => false, "message" => "Kode dosen tidak tersedia"]);
    }
    
    $query->close();
} else {
    echo json_encode(["success" => false, "message" => "Parameter tidak lengkap"]);
}

$conn->close();
?>
