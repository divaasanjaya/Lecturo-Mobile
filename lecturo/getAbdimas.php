<?php
include "config.php";

header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);
error_reporting(E_ALL);
ini_set('display_errors', 1);


if (isset($data["kode"])) {
    $kode = $data["kode"];

    $query = $conn->prepare("SELECT kodeAbdimas FROM dosen_abdimas WHERE kodeDosen = ?");
    $query->bind_param("s", $kode);
    $query->execute();
    $result = $query->get_result();

    if ($result->num_rows > 0) {
        $kodeAbdimasList = [];
        while ($row = $result->fetch_assoc()) {
            $kodeAbdimasList[] = $row['kodeAbdimas'];
        }

        $placeholders = implode(',', array_fill(0, count($kodeAbdimasList), '?'));
        $types = str_repeat('s', count($kodeAbdimasList));
        $query = $conn->prepare("SELECT * FROM abdimas WHERE kode IN ($placeholders)");
        
        $query->bind_param($types, ...$kodeAbdimasList);
        $query->execute();
        $abdimasResult = $query->get_result();

        if ($abdimasResult->num_rows > 0) {
            $abdimasList = [];
            while ($row = $abdimasResult->fetch_assoc()) {
                $abdimasList[] = $row;
            }
        }

        echo json_encode(["success" => true, "abdimas" => $abdimasList]);

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
