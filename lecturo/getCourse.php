<?php
include "config.php";

header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);
error_reporting(E_ALL);
ini_set('display_errors', 1);


if (isset($data["kode"])) {
    $kode = $data["kode"];

    $query = $conn->prepare("SELECT * FROM course WHERE dosenPengampu = ?");
    $query->bind_param("s", $kode);
    $query->execute();
    $result = $query->get_result();

    if ($result->num_rows > 0) {
        $courses = [];
        while ($row = $result->fetch_assoc()) {
            $courses[] = $row;
        }
        echo json_encode(["success" => true, "course" => $courses]);
    }
     else {
        echo json_encode(["success" => false, "message" => "Kode dosen tidak tersedia"]);
    }

    $query->close();
} else {
    echo json_encode(["success" => false, "message" => "Parameter tidak lengkap"]);
}

$conn->close();
?>
