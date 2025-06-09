<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class MasterController extends Controller
{
    public function getDosen($kode)
    {
        $dosen = DB::table('dosen')->where('kode', $kode)->first();

        if ($dosen) {
            return response()->json([
                'success' => true,
                'dosen' => $dosen
            ]);
        } else {
            return response()->json([
                'success' => false,
                'message' => 'Kode dosen tidak tersedia'
            ]);
        }
    }

    public function getDosenKoor($kode)
    {
        $dosenKoor = DB::table('dosenkoor')
            ->where('matkulKoor', $kode)
            ->first();

        // Cek apakah data ditemukan
        if ($dosenKoor) {
            return response()->json([
                'success' => true,
                'dosenkoor' => $dosenKoor
            ]);
        } else {
            return response()->json([
                'success' => false,
                'message' => 'Kode dosen tidak tersedia'
            ]);
        }
    }

    public function getCourse(Request $request)
    {
        file_put_contents("testlog.txt", $request->file(""));

        $request->validate([
            'kode' => 'required|string',
            'tahun' => 'required|string',
        ]);

        $kode = $request->kode;
        $tahun = $request->tahun;

        // Mengambil data dari database
        $courses = DB::table('course')
            ->where('dosenPengampu', $kode)
            ->where('tahunAjaran', $tahun)
            ->get();

        // Cek apakah data ditemukan
        if ($courses->isNotEmpty()) {
            return response()->json([
                'success' => true,
                'course' => $courses,
            ]);
        } else {
            return response()->json([
                'success' => false,
                'course' => [],
            ]);
        }
    }

    public function getCourse2(Request $request)
    {
        $request->validate([
            'kodeMatkul' => 'required|string',
            'kodeKelas' => 'required|string',
        ]);

        $kodeMatkul = $request->input('kodeMatkul');
        $kodeKelas = $request->input('kodeKelas');

        // Ambil data dari tabel 'course'
        $course = DB::table('course')
            ->where('kodeMatkul', $kodeMatkul)
            ->where('kodeKelas', $kodeKelas)
            ->first();

        if ($course) {
            return response()->json([
                'success' => true,
                'course' => $course
            ]);
        } else {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak ditemukan'
            ]);
        }
    }
}
