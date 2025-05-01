<?php
include "config.php";

header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data["menu"]) && isset($data["nama"]) && isset($data["deskripsi"]) && isset($data["tanggal"])) {
    $menu = $data["menu"];
    $kode = $data["kode"];
    $nama = $data["nama"];
    $deskripsi = $data["deskripsi"];
    $tanggal = $data["tanggal"];
    $kodeDosen = $data["kodeDosen"];

    if ($menu=="upd") {
        $query = $conn->prepare("UPDATE abdimas SET nama = ? , deskripsi = ? , tanggal = ? WHERE kode = ?");
        $query->bind_param("sssi", $nama, $deskripsi, $tanggal, $kode);
        $query->execute();
        $result = $query->get_result();
        
    // file_put_contents("debug.txt", print_r($result, true));
        
    } else if ($menu=="add") {
        $query = $conn->prepare("INSERT INTO abdimas (nama, deskripsi, tanggal) VALUES (? , ? , ?)");
        $query->bind_param("sss", $nama, $deskripsi, $tanggal);
        $query->execute();
        $result = $query->get_result();
        
        $kodeBaru = $conn->insert_id;
        $query = $conn->prepare("INSERT INTO dosen_abdimas (kodeDosen, kodeAbdimas) VALUES (? , ?)");
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
