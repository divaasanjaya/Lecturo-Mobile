<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use App\Models\Quiz;
use App\Models\MahasiswaQuiz;

class QuizController extends Controller
{
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nama' => 'required|string',
            'kodeMatkul' => 'required|string',
            'deskripsi' => 'required|string',
            'kodeKelas' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Parameter tidak lengkap.',
                'errors' => $validator->errors()
            ], 422);
        }

        // Simpan quiz
        try {
            DB::beginTransaction();

            DB::table('quiz')->insert([
                'nama' => $request->nama,
                'kodeMatkul' => $request->kodeMatkul,
                'deskripsi' => $request->deskripsi,
                'kodeKelas' => $request->kodeKelas,
            ]);

            // Ambil mahasiswa yang mengambil matkul dan kelas terkait
            $mahasiswa = DB::table('course_mahasiswa as cm')
                ->join('course as c', function ($join) {
                    $join->on('cm.kodeMatkul', '=', 'c.kodeMatkul');
                    // Tidak bisa join kodeKelas di cm karena tidak ada
                })
                ->join('mahasiswa', function ($join) {
                    $join->on('cm.nim', '=', 'mahasiswa.nim');
                })
                ->where('cm.kodeMatkul', $request->kodeMatkul)
                ->where('c.kodeKelas', $request->kodeKelas)
                ->whereColumn('c.kodeKelas', 'mahasiswa.kodeKelas')  // pastikan kodeKelas course dan mahasiswa sama
                ->select('cm.nim')
                ->get();
            // Masukkan data ke tabel mahasiswa_quiz
            foreach ($mahasiswa as $mhs) {
                DB::table('mahasiswa_quiz')->insert([
                    'nim' => $mhs->nim,
                    'nilai' => 0,
                    'namaQuiz' => $request->nama,
                    'kodeKelas' => $request->kodeKelas,
                ]);
            }

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Quiz berhasil ditambahkan.'
            ], 200);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Gagal menambahkan quiz.',
                'error' => $e->getMessage() // Optional untuk debug
            ], 500);
        }
    }

    public function del(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nama' => 'required|string',
            'kodeMatkul' => 'required|string',
            'kodeKelas' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Parameter tidak lengkap.',
                'errors' => $validator->errors(),
            ], 422);
        }

        $nama = $request->nama;
        $kodeMatkul = $request->kodeMatkul;
        $kodeKelas = $request->kodeKelas;

        try {
            DB::beginTransaction();

            // Hapus quiz dari tabel quiz
            $deleted = DB::table('quiz')
                ->where('nama', $nama)
                ->where('kodeMatkul', $kodeMatkul)
                ->where('kodeKelas', $kodeKelas)
                ->delete();

            // Hapus relasi dari mahasiswa_quiz
            DB::table('mahasiswa_quiz')
                ->where('namaQuiz', $nama)
                ->where('kodeKelas', $kodeKelas)
                ->delete();

            DB::commit();

            if ($deleted > 0) {
                return response()->json([
                    'success' => true,
                    'message' => 'Quiz berhasil dihapus.'
                ], 200);
            } else {
                return response()->json([
                    'success' => false,
                    'message' => 'Gagal menghapus quiz. Data tidak ditemukan.'
                ], 404);
            }
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat menghapus quiz.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getQuiz(Request $request)
    {
        $kodeMatkul = $request->kodeMatkul;
        $kodeKelas = $request->kodeKelas;

        // Validasi parameter
        if (!$kodeMatkul || !$kodeKelas) {
            return response()->json([
                'success' => false,
                'message' => 'Parameter tidak lengkap.'
            ], 400);
        }

        // Query ke database
        $quizzes = DB::table('quiz')
            ->where('kodeMatkul', $kodeMatkul)
            ->where('kodeKelas', $kodeKelas)
            ->get();

        return response()->json([
            'success' => true,
            'quiz' => $quizzes
        ], 200);
    }

    public function getNilai(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'kodeKelas' => 'required|string',
            'nama' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Parameter kodeKelas dan nama diperlukan.',
                'errors' => $validator->errors()
            ], 400);
        }

        $kodeKelas = $request->input('kodeKelas');
        $nama = $request->input('nama');

        // Query menggunakan query builder Laravel
        $mquiz = DB::table('mahasiswa_quiz as mq')
            ->join('mahasiswa as m', 'mq.nim', '=', 'm.nim')
            ->select('mq.*', 'm.nama as namaMahasiswa')
            ->where('mq.kodeKelas', $kodeKelas)
            ->where('mq.namaQuiz', $nama)
            ->get();

        return response()->json([
            'success' => true,
            'mquiz' => $mquiz
        ]);
    }

    public function updateNilai(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nim' => 'required|integer',
            'namaQuiz' => 'required|string',
            'kodeKelas' => 'required|string',
            'nilai' => 'required|integer',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Parameter tidak lengkap atau tidak valid.',
                'errors' => $validator->errors()
            ], 400);
        }

        $nim = $request->input('nim');
        $namaQuiz = $request->input('namaQuiz');
        $kodeKelas = $request->input('kodeKelas');
        $nilai = $request->input('nilai');

        // Update query menggunakan query builder
        $updated = DB::table('mahasiswa_quiz')
            ->where('nim', $nim)
            ->where('namaQuiz', $namaQuiz)
            ->where('kodeKelas', $kodeKelas)
            ->update(['nilai' => $nilai]);

        if ($updated) {
            return response()->json([
                'success' => true,
                'message' => 'Nilai berhasil diperbarui.'
            ]);
        } else {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak ditemukan atau tidak ada perubahan.'
            ], 404);
        }
    }
}
