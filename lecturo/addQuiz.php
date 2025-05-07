<?php
include "config.php";
header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);


if (
    isset($data["nama"]) &&
    isset($data["kodeMatkul"]) &&
    isset($data["deskripsi"]) &&
    isset($data["kodeKelas"])
) {
    $nama = $data["nama"];
    $kodeMatkul = $data["kodeMatkul"];
    $deskripsi = $data["deskripsi"];
    $kodeKelas = $data["kodeKelas"];

    $query = $conn->prepare("INSERT INTO quiz (nama, kodeMatkul, deskripsi, kodeKelas) VALUES (?, ?, ?, ?)");
    $query->bind_param("ssss", $nama, $kodeMatkul, $deskripsi, $kodeKelas);

    if ($query->execute()) {
        $checkquery = $conn->prepare("SELECT cm.nim from course_mahasiswa cm
                                    JOIN course c ON cm.kodeMatkul = c.kodeMatkul
                                    WHERE cm.kodeMatkul = ? AND c.kodeKelas = ?");
        $checkquery->bind_param("ss", $kodeMatkul, $kodeKelas);
        $checkquery->execute();
        $result = $checkquery->get_result();

        if($result->num_rows > 0) {
            $insertMhsQuiz = $conn->prepare("INSERT INTO mahasiswa_quiz (nim, nilai, namaQuiz, kodeKelas) VALUES (?, 0, ?, ?)");
            while($row = $result->fetch_assoc()) {
                $nim = $row['nim'];
                $insertMhsQuiz->bind_param("iss", $nim, $nama, $kodeKelas);
                $insertMhsQuiz->execute();
            }
            $insertMhsQuiz->close();
        }
        $checkquery->close();

        echo json_encode(["success" => true, "message" => "Quiz berhasil ditambahkan."]);
    } else {
        echo json_encode(["success" => false, "message" => "Gagal menambahkan quiz."]);
    }

    $query->close();
} else {
    echo json_encode(["success" => false, "message" => "Parameter tidak lengkap."]);
}

$conn->close();
?>
