<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Abdimas;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class AbdimasController extends Controller
{
    public function getAbdimasByDosen(Request $request)
    {
        $request->validate([
            'kode' => 'required|string'
        ]);

        $kodeDosen = $request->input('kode');

        try {
            // Ambil list kodeAbdimas dari dosen_abdimas
            $kodeAbdimasList = DB::table('dosen_abdimas')
                ->where('kodeDosen', $kodeDosen)
                ->pluck('kodeAbdimas');

            if ($kodeAbdimasList->isEmpty()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Kode dosen tidak tersedia'
                ]);
            }

            // Ambil data abdimas berdasarkan kode-kode tersebut
            $abdimasList = DB::table('abdimas')
                ->whereIn('kode', $kodeAbdimasList)
                ->get();

            return response()->json([
                'success' => true,
                'abdimas' => $abdimasList
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    public function upsert(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'menu' => 'required|in:add,upd',
            'nama' => 'required|string',
            'deskripsi' => 'required|string',
            'tanggal' => 'required|date',
            'kodeDosen' => 'required|string',
            'kode' => 'nullable|integer' // hanya untuk update
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Parameter tidak lengkap atau salah format',
                'errors' => $validator->errors()
            ], 422);
        }

        $data = $validator->validated();

        try {
            if ($data['menu'] === 'upd') {
                // Proses UPDATE
                $affected = DB::table('abdimas')
                    ->where('kode', $data['kode'])
                    ->update([
                        'nama' => $data['nama'],
                        'deskripsi' => $data['deskripsi'],
                        'tanggal' => $data['tanggal'],
                    ]);

                return response()->json([
                    'success' => true,
                    'message' => $affected ? 'Data abdimas berhasil diupdate' : 'Tidak ada perubahan data'
                ]);
            } else if ($data['menu'] === 'add') {
                // Proses INSERT abdimas
                $kodeBaru = DB::table('abdimas')->insertGetId([
                    'nama' => $data['nama'],
                    'deskripsi' => $data['deskripsi'],
                    'tanggal' => $data['tanggal'],
                ]);

                // INSERT ke tabel relasi dosen_abdimas
                DB::table('dosen_abdimas')->insert([
                    'kodeDosen' => $data['kodeDosen'],
                    'kodeAbdimas' => $kodeBaru,
                ]);

                return response()->json([
                    'success' => true,
                    'message' => 'Data abdimas berhasil ditambahkan',
                    'kodeBaru' => $kodeBaru,
                ]);
            }
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    public function del(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'kodeDosen' => 'required|string',
            'kodeAbdimas' => 'required|integer',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Parameter tidak lengkap atau salah format',
                'errors' => $validator->errors()
            ], 422);
        }

        $data = $validator->validated();

        try {
            // Hapus relasi dari dosen_abdimas terlebih dahulu
            DB::table('dosen_abdimas')
                ->where('kodeDosen', $data['kodeDosen'])
                ->where('kodeAbdimas', $data['kodeAbdimas'])
                ->delete();

            // Hapus data utama dari abdimas
            DB::table('abdimas')
                ->where('kode', $data['kodeAbdimas'])
                ->delete();

            return response()->json([
                'success' => true,
                'message' => 'Data abdimas berhasil dihapus'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    public function show($kode)
    {
        try {
            $abdimas = DB::table('abdimas')->where('kode', $kode)->first();

            if ($abdimas) {
                return response()->json([
                    'success' => true,
                    'abdimas' => $abdimas
                ]);
            } else {
                return response()->json([
                    'success' => false,
                    'message' => 'Kode abdimas tidak tersedia'
                ]);
            }
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }
}
