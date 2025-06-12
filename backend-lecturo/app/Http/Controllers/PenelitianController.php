<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Penelitian;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class PenelitianController extends Controller
{
    public function getPenelitianByDosen(Request $request)
    {
        $request->validate([
            'kode' => 'required'
        ]);

        $kode = $request->kode;

        // Ambil semua kodePenelitian dari dosen_penelitian
        $kodePenelitianList = DB::table('dosen_penelitian')
            ->where('kodeDosen', $kode)
            ->pluck('kodePenelitian'); // hasilnya Collection

        $penelitianList = [];

        if ($kodePenelitianList->isEmpty()) {
            return response()->json([
                'success' => false,
                'message' => 'Kode dosen tidak tersedia',
                'penelitian' => $penelitianList
            ]);
        }


        // Ambil semua penelitian berdasarkan kode-kode yang didapat
        $penelitianList = DB::table('penelitian')
            ->whereIn('kode', $kodePenelitianList)
            ->get();

        return response()->json([
            'success' => true,
            'penelitian' => $penelitianList
        ]);
    }

    public function upsert(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'menu' => 'required|in:add,upd',
            'nama' => 'required|string',
            'bidang' => 'required|string',
            'deskripsi' => 'required|string',
            'tanggal' => 'required|date',
            'tautan' => 'required|string',
            'kodeDosen' => 'required|string',
            'kode' => 'nullable|integer' // Hanya diperlukan untuk mode 'upd'
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
                // Update penelitian berdasarkan kode
                $affected = DB::table('penelitian')
                    ->where('kode', $data['kode'])
                    ->update([
                        'nama' => $data['nama'],
                        'bidang' => $data['bidang'],
                        'deskripsi' => $data['deskripsi'],
                        'tanggal' => $data['tanggal'],
                        'tautan' => $data['tautan']
                    ]);

                return response()->json([
                    'success' => true,
                    'message' => $affected ? 'Penelitian berhasil diupdate' : 'Tidak ada perubahan'
                ]);
            } else if ($data['menu'] === 'add') {
                // Insert penelitian baru
                $kodeBaru = DB::table('penelitian')->insertGetId([
                    'nama' => $data['nama'],
                    'bidang' => $data['bidang'],
                    'deskripsi' => $data['deskripsi'],
                    'tanggal' => $data['tanggal'],
                    'tautan' => $data['tautan']
                ]);

                // Insert relasi ke dosen_penelitian
                DB::table('dosen_penelitian')->insert([
                    'kodeDosen' => $data['kodeDosen'],
                    'kodePenelitian' => $kodeBaru
                ]);

                return response()->json([
                    'success' => true,
                    'message' => 'Penelitian berhasil ditambahkan',
                    'kodeBaru' => $kodeBaru
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
        $kodeDosen = $request->kodeDosen;
        $kode = $request->kodePenelitian;
        if (!$kodeDosen || !$kode) {
            return response()->json([
                'success' => false,
                'message' => 'Parameter tidak lengkap'
            ], 400);
        }

        try {
            DB::beginTransaction();

            // Hapus relasi dari dosen_penelitian
            DB::table('dosen_penelitian')
                ->where('kodeDosen', $kodeDosen)
                ->where('kodePenelitian', $kode)
                ->delete();

            // Hapus data dari tabel penelitian
            DB::table('penelitian')
                ->where('kode', $kode)
                ->delete();

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Data penelitian berhasil dihapus'
            ]);
        } catch (\Exception $e) {
            DB::rollBack();

            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus data: ' . $e->getMessage()
            ], 500);
        }
    }

    public function show($kode)
    {
        $penelitian = Penelitian::where('kode', $kode)->first();

        if ($penelitian) {
            return response()->json([
                'success' => true,
                'penelitian' => $penelitian
            ]);
        } else {
            return response()->json([
                'success' => false,
                'message' => 'Kode penelitian tidak tersedia'
            ]);
        }
    }
}
