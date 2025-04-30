<?php
include "config.php";

header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);
error_reporting(E_ALL);
ini_set('display_errors', 1);


if (isset($data["kode"])) {
    $kode = $data["kode"];

    $query = $conn->prepare("SELECT kodePenelitian FROM dosen_penelitian WHERE kodeDosen = ?");
    $query->bind_param("s", $kode);
    $query->execute();
    $result = $query->get_result();

    if ($result->num_rows > 0) {
        $kodePenelitianList = [];
        while ($row = $result->fetch_assoc()) {
            $kodePenelitianList[] = $row['kodePenelitian'];
        }

        $placeholders = implode(',', array_fill(0, count($kodePenelitianList), '?'));
        $types = str_repeat('s', count($kodePenelitianList));
        $query = $conn->prepare("SELECT * FROM penelitian WHERE kode IN ($placeholders)");
        
        $query->bind_param($types, ...$kodePenelitianList);
        $query->execute();
        $penelitianResult = $query->get_result();

        if ($penelitianResult->num_rows > 0) {
            $penelitianList = [];
            while ($row = $penelitianResult->fetch_assoc()) {
                $penelitianList[] = $row;
            }
        }

        echo json_encode(["success" => true, "penelitian" => $penelitianList]);

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
