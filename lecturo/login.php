<?php
include "config.php";

header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data["kode"]) && isset($data["password"])) {
    $kode = $data["kode"];
    $password = $data["password"];

    $query = $conn->prepare("SELECT * FROM dosen WHERE kode = ? AND password = ?");
    $query->bind_param("ss", $kode, $password);
    $query->execute();
    $result = $query->get_result();

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();
        echo json_encode(["success" => true, "dosen" => $user]);
    } else {
        echo json_encode(["success" => false, "message" => "Username atau password salah"]);
    }

    $query->close();
} else {
    echo json_encode(["success" => false, "message" => "Parameter tidak lengkap"]);
}

$conn->close();
?>
