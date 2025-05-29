<?php
include "config.php";

header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);
error_reporting(E_ALL);
ini_set('display_errors', 1);


if (isset($data["kode"]) && isset($data["tahun"])) {
    $kode = $data["kode"];
    $tahun = $data["tahun"];

    $query = $conn->prepare("SELECT * FROM course WHERE dosenPengampu = ? AND tahunAjaran = ?");
    $query->bind_param("ss", $kode, $tahun);
    $query->execute();
    $result = $query->get_result();

    $courses = [];
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $courses[] = $row;
        }
        echo json_encode(["success" => true, "course" => $courses]);
    }
     else {
        echo json_encode(["success" => false, "course" => $courses]);
    }

    $query->close();
} else {
    echo json_encode(["success" => false, "message" => "Parameter tidak lengkap"]);
}

$conn->close();
?>
