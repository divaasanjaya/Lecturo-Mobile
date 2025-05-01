<?php
include "config.php";

header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data["menu"]) && isset($data["nama"]) && isset($data["bidang"]) && isset($data["deskripsi"]) && isset($data["tanggal"]) && isset($data["tautan"])) {
    $menu = $data["menu"];
    $kode = $data["kode"];
    $nama = $data["nama"];
    $bidang = $data["bidang"];
    $deskripsi = $data["deskripsi"];
    $tanggal = $data["tanggal"];
    $tautan = $data["tautan"];
    $kodeDosen = $data["kodeDosen"];

    if ($menu=="upd") {
        $query = $conn->prepare("UPDATE penelitian SET nama = ? , bidang = ? , deskripsi = ? , tanggal = ? , tautan = ? WHERE kode = ?");
        $query->bind_param("sssssi", $nama, $bidang, $deskripsi, $tanggal, $tautan, $kode);
        $query->execute();
        $result = $query->get_result();
        
    // file_put_contents("debug.txt", print_r($result, true));
        
    } else if ($menu=="add") {
        $query = $conn->prepare("INSERT INTO penelitian (nama, bidang, deskripsi, tanggal, tautan) VALUES (? , ? , ? , ? , ?)");
        $query->bind_param("sssss", $nama, $bidang, $deskripsi, $tanggal, $tautan);
        $query->execute();
        $result = $query->get_result();
        
        $kodeBaru = $conn->insert_id;
        $query = $conn->prepare("INSERT INTO dosen_penelitian (kodeDosen, kodePenelitian) VALUES (? , ?)");
        $query->bind_param("ss", $kodeDosen, $kodeBaru);
        $query->execute();
        $result = $query->get_result();

    }
    $query->close();
} else {
    echo json_encode(["success" => false, "message" => "Parameter tidak lengkap"]);
}

$conn->close();
?>
