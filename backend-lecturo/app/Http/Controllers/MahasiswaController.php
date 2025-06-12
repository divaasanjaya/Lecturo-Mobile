<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Mahasiswa;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class MahasiswaController extends Controller
{
    public function upsert(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'NIM' => 'required|integer',
            'nama' => 'required|string',
            'kodeKelas' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $NIM = $request->input('NIM');
        $nama = $request->input('nama');
        $kodeKelas = $request->input('kodeKelas');

        try {
            DB::beginTransaction();

            // 1. Cek NIM sudah terdaftar?
            $existing = DB::table('mahasiswa')->where('NIM', $NIM)->first();
            if ($existing) {
                throw new \Exception("Mahasiswa dengan NIM tersebut sudah terdaftar");
            }

            // 2. Validasi bahwa kodeKelas benar-benar ada di tabel course
            $matkul = DB::table('course')->where('kodeKelas', $kodeKelas)->first();
            if (!$matkul) {
                throw new \Exception("Kode kelas '$kodeKelas' tidak ditemukan di tabel course");
            }

            $kodeMatkul = $matkul->kodeMatkul;

            // 3. Cek juga kodeMatkul benar-benar ada di tabel course
            $cekKodeMatkul = DB::table('course')->where('kodeMatkul', $kodeMatkul)->exists();
            if (!$cekKodeMatkul) {
                throw new \Exception("Kode matkul '$kodeMatkul' tidak ditemukan, tidak bisa insert ke course_mahasiswa");
            }

            // 4. Insert ke mahasiswa
            DB::table('mahasiswa')->insert([
                'NIM' => $NIM,
                'nama' => $nama,
                'kodeKelas' => $kodeKelas,
            ]);

            // 5. Insert ke course_mahasiswa
            DB::table('course_mahasiswa')->insert([
                'kodeMatkul' => $kodeMatkul,
                'NIM' => $NIM,
            ]);

            // 6. Insert quiz jika ada
            $quizzes = DB::table('quiz')
                ->where('kodeMatkul', $kodeMatkul)
                ->where('kodeKelas', $kodeKelas)
                ->get();

            $quizzesAssigned = 0;

            foreach ($quizzes as $quiz) {
                DB::table('mahasiswa_quiz')->insert([
                    'nim' => $NIM,
                    'nilai' => 0,
                    'namaQuiz' => $quiz->nama,
                    'kodeKelas' => $kodeKelas,
                ]);
                $quizzesAssigned++;
            }

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Mahasiswa berhasil ditambahkan ke semua tabel termasuk quiz',
                'data' => [
                    'NIM' => $NIM,
                    'nama' => $nama,
                    'kodeKelas' => $kodeKelas,
                    'kodeMatkul' => $kodeMatkul,
                    'quizzes_assigned' => $quizzesAssigned
                ]
            ], 200);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    public function del(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'NIM' => 'required|string',
            'kodeMatkul' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $NIM = $request->input('NIM');
        $kodeMatkul = $request->input('kodeMatkul');

        try {
            DB::beginTransaction();

            // Cek apakah mahasiswa ada
            $mahasiswa = DB::table('mahasiswa')->where('NIM', $NIM)->first();
            if (!$mahasiswa) {
                throw new \Exception("Mahasiswa dengan NIM tersebut tidak ditemukan");
            }

            // Ambil kodeKelas dari course
            $course = DB::table('course')->where('kodeMatkul', $kodeMatkul)->first();
            if (!$course) {
                throw new \Exception("Mata kuliah dengan kode tersebut tidak ditemukan");
            }
            $kodeKelas = $course->kodeKelas;

            // Hapus data quiz mahasiswa berdasarkan join ke quiz
            $quizDeleted = DB::table('mahasiswa_quiz as mq')
                ->join('quiz as q', function($join) {
                    $join->on('mq.namaQuiz', '=', 'q.nama')
                        ->on('mq.kodeKelas', '=', 'q.kodeKelas');
                })
                ->where('mq.nim', $NIM)
                ->where('q.kodeMatkul', $kodeMatkul)
                ->where('mq.kodeKelas', $kodeKelas)
                ->delete();

            // Hapus data dari course_mahasiswa
            $courseDeleted = DB::table('course_mahasiswa')
                ->where('NIM', $NIM)
                ->where('kodeMatkul', $kodeMatkul)
                ->delete();

            if ($courseDeleted === 0) {
                throw new \Exception("Tidak ada data yang dihapus (NIM dan kodeMatkul tidak cocok)");
            }

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Data mahasiswa berhasil dihapus dari course dan quiz terkait',
                'data' => [
                    'deleted_NIM' => $NIM,
                    'deleted_kodeMatkul' => $kodeMatkul,
                    'deleted_kodeKelas' => $kodeKelas,
                    'quiz_records_deleted' => $quizDeleted,
                    'course_records_deleted' => $courseDeleted,
                ]
            ], 200);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    public function getMahasiswa(Request $request)
    {
        $kodeMatkul = $request->kodeMatkul;
        $kodeKelas = $request->kodeKelas;

        if (!$kodeMatkul || !$kodeKelas) {
            return response()->json([
                'success' => false,
                'message' => 'Parameter kodeMatkul dan kodeKelas diperlukan.'
            ]);
        }

        $mahasiswa = DB::table('mahasiswa as m')
            ->join('course_mahasiswa as cm', 'm.NIM', '=', 'cm.NIM')
            ->select('m.NIM', 'm.nama', 'm.kodeKelas')
            ->where('cm.kodeMatkul', $kodeMatkul)
            ->where('m.kodeKelas', $kodeKelas)
            ->get();

        return response()->json([
            'success' => true,
            'mahasiswa' => $mahasiswa,
            'count' => $mahasiswa->count(),
        ], 200);
    }
}
