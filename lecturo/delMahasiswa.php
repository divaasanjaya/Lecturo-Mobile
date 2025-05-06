<?php
include "config.php";

header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data["NIM"])) {
    $NIM = $data["NIM"];

    $query = $conn->prepare("DELETE FROM mahasiswa WHERE NIM = ?");
    $query->bind_param("i", $NIM);

    if ($query->execute()) {
        echo json_encode(["success" => true, "message" => "Data mahasiswa berhasil dihapus"]);
    } else {
        echo json_encode(["success" => false, "message" => "Gagal menghapus data"]);
    }

    $query->close();
} else {
    echo json_encode(["success" => false, "message" => "Parameter NIM tidak ditemukan"]);
}

$conn->close();
?>
