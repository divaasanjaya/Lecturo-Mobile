<?php
include "config.php";
header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if (
    isset($data["NIM"]) &&
    isset($data["nama"]) &&
    isset($data["kodeKelas"])
) {
    $NIM = $data["NIM"];
    $nama = $data["nama"];
    $kodeKelas = $data["kodeKelas"];

    // Mulai transaksi
    $conn->begin_transaction();

    try {
        // 1. Cek apakah mahasiswa sudah ada
        $checkQuery = $conn->prepare("SELECT NIM FROM mahasiswa WHERE NIM = ?");
        $checkQuery->bind_param("i", $NIM);
        $checkQuery->execute();
        $checkQuery->store_result();
        
        if ($checkQuery->num_rows > 0) {
            echo json_encode([
                "success" => false, 
                "message" => "Mahasiswa dengan NIM tersebut sudah terdaftar"
            ]);
            exit();
        }
        $checkQuery->close();

        // 2. Dapatkan kodeMatkul dari tabel course berdasarkan kodeKelas
        $getMatkulQuery = $conn->prepare("SELECT kodeMatkul FROM course WHERE kodeKelas = ?");
        $getMatkulQuery->bind_param("s", $kodeKelas);
        $getMatkulQuery->execute();
        $result = $getMatkulQuery->get_result();
        
        if ($result->num_rows == 0) {
            throw new Exception("Tidak ditemukan mata kuliah untuk kelas ini");
        }
        
        $matkulData = $result->fetch_assoc();
        $kodeMatkul = $matkulData['kodeMatkul'];
        $getMatkulQuery->close();

        // 3. Insert ke tabel mahasiswa
        $insertMahasiswa = $conn->prepare("INSERT INTO mahasiswa (NIM, nama, kodeKelas) VALUES (?, ?, ?)");
        $insertMahasiswa->bind_param("iss", $NIM, $nama, $kodeKelas);
        
        if (!$insertMahasiswa->execute()) {
            throw new Exception("Gagal menambahkan ke tabel mahasiswa: " . $conn->error);
        }
        $insertMahasiswa->close();

        // 4. Insert ke tabel course_mahasiswa
        $insertCourseMhs = $conn->prepare("INSERT INTO course_mahasiswa (kodeMatkul, NIM) VALUES (?, ?)");
        $insertCourseMhs->bind_param("si", $kodeMatkul, $NIM);
        
        if (!$insertCourseMhs->execute()) {
            throw new Exception("Gagal menambahkan ke tabel course_mahasiswa: " . $conn->error);
        }
        $insertCourseMhs->close();

        // Commit transaksi jika semua berhasil
        $conn->commit();

        echo json_encode([
            "success" => true, 
            "message" => "Mahasiswa berhasil ditambahkan ke kedua tabel",
            "data" => [
                "NIM" => $NIM,
                "nama" => $nama,
                "kodeKelas" => $kodeKelas,
                "kodeMatkul" => $kodeMatkul
            ]
        ]);

    } catch (Exception $e) {
        // Rollback jika ada error
        $conn->rollback();
        echo json_encode([
            "success" => false, 
            "message" => $e->getMessage(),
            "error" => $conn->error
        ]);
    }

} else {
    echo json_encode([
        "success" => false, 
        "message" => "Parameter tidak lengkap",
        "required_parameters" => ["NIM", "nama", "kodeKelas"]
    ]);
}

$conn->close();
?>