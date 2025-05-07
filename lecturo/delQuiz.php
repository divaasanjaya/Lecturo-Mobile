<?php
include "config.php";
header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if (
    isset($data["nama"]) &&
    isset($data["kodeMatkul"]) &&
    isset($data["kodeKelas"])
) {
    $nama = $data["nama"];
    $kodeMatkul = $data["kodeMatkul"];
    $kodeKelas = $data["kodeKelas"];

    $query = $conn->prepare("DELETE FROM quiz WHERE nama = ? AND kodeMatkul = ? AND kodeKelas = ?");
    $query->bind_param("sss", $nama, $kodeMatkul, $kodeKelas);

    if ($query->execute()) {
        echo json_encode(["success" => true, "message" => "Quiz berhasil dihapus."]);
    } else {
        echo json_encode(["success" => false, "message" => "Gagal menghapus quiz."]);
    }

    $query->close();

    $relquery = $conn->prepare("DELETE FROM mahasiswa_quiz WHERE namaQuiz = ? AND kodeKelas = ?");
    $relquery->bind_param("ss", $nama, $kodeKelas);
    $relquery->execute();
    $relquery->close();
} else {
    echo json_encode(["success" => false, "message" => "Parameter tidak lengkap."]);
}

$conn->close();
?>
