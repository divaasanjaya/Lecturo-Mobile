<?php
include "config.php";

header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data["kodeMatkul"]) && isset($data["kodeMatkul"])) {
    $kodeMatkul = $data["kodeMatkul"];
    $kodeKelas = $data["kodeKelas"];

    $query = $conn->prepare("SELECT * FROM course WHERE kodeMatkul = ? AND kodeKelas = ?");
    $query->bind_param("ss", $kodeMatkul, $kodeKelas);
    $query->execute();
    $result = $query->get_result();

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();
        echo json_encode(["success" => true, "course" => $user]);
    } else {
        echo json_encode(["success" => false, "message" => "Username atau password salah"]);
    }

    $query->close();
} else {
    echo json_encode(["success" => false, "message" => "Parameter tidak lengkap"]);
}

$conn->close();
?>
