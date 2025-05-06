<?php
include "config.php";

header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data["menu"]) && isset($data["nama"]) && isset($data["kodeKelas"]) && isset($data["NIM"])) {
    $menu = $data["menu"];
    $NIM = $data["NIM"];
    $nama = $data["nama"];
    $kodeKelas = $data["kodeKelas"];

    if ($menu == "upd") {
        $query = $conn->prepare("UPDATE mahasiswa SET nama = ?, kodeKelas = ? WHERE NIM = ?");
        $query->bind_param("ssi", $nama, $kodeKelas, $NIM);
        $success = $query->execute();

    } else if ($menu == "add") {
        $query = $conn->prepare("INSERT INTO mahasiswa (NIM, nama, kodeKelas) VALUES (?, ?, ?)");
        $query->bind_param("iss", $NIM, $nama, $kodeKelas);
        $success = $query->execute();
    }

    if ($success) {
        echo json_encode(["success" => true, "message" => "Data mahasiswa berhasil diproses"]);
    } else {
        echo json_encode(["success" => false, "message" => "Terjadi kesalahan saat memproses data"]);
    }

    $query->close();
} else {
    echo json_encode(["success" => false, "message" => "Parameter tidak lengkap"]);
}

$conn->close();
?>
