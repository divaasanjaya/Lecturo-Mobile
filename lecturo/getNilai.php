<?php
include "config.php";
header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data["kodeKelas"]) && isset($data["nama"])) {
    $kodeKelas = $data["kodeKelas"];
    $nama = $data["nama"];
    

    $query = $conn->prepare("
        SELECT mq.*, m.nama AS namaMahasiswa
        FROM mahasiswa_quiz mq
        INNER JOIN mahasiswa m ON mq.nim = m.nim
        WHERE mq.kodeKelas = ? AND mq.namaQuiz = ?
    ");

    $query->bind_param("ss", $kodeKelas, $nama);
    $query->execute();
    $result = $query->get_result();

    $mahasiswa = [];
    while ($row = $result->fetch_assoc()) {
        $mquiz[] = $row;
    }

    echo json_encode(["success" => true, "mquiz" => $mquiz]);

    $query->close();
} else {
    echo json_encode(["success" => false, "message" => "Parameter kodeKelas diperlukan."]);
}

$conn->close();
?>