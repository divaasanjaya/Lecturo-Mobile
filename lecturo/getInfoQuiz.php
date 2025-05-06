<?php
include "config.php";
header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data["kodeMatkul"]) && isset($data["kodeKelas"])) {
    $kodeMatkul = $data["kodeMatkul"];
    $kodeKelas = $data["kodeKelas"];

    $query = $conn->prepare("SELECT * FROM quiz WHERE kodeMatkul = ? AND kodeKelas = ?");
    $query->bind_param("ss", $kodeMatkul, $kodeKelas);
    $query->execute();
    $result = $query->get_result();

    $quizzes = [];
    while ($row = $result->fetch_assoc()) {
        $quizzes[] = $row;
    }

    echo json_encode(["success" => true, "quiz" => $quizzes]);

    $query->close();
} else {
    echo json_encode(["success" => false, "message" => "Parameter tidak lengkap."]);
}

$conn->close();
?>
