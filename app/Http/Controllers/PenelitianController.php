<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Penelitian;

class PenelitianController extends Controller
{
    public function index()
    {
        return Penelitian::all();
    }

    public function upsert(Request $request)
    {
        $validated = $request->validate([
            'kode' => 'required|string',
            'nama' => 'required|string',
            'bidang' => 'required|string',
            'deskripsi' => 'nullable|string',
            'tanggal' => 'required|date',
            'tautan' => 'nullable|url',
        ]);

        $penelitian = Penelitian::updateOrCreate(
            ['kode' => $validated['kode']],
            $validated
        );

        return response()->json($penelitian);
    }

    public function destroy($kode)
    {
        Penelitian::where('kode', $kode)->delete();
        return response()->json(['message' => 'Penelitian berhasil dihapus']);
    }

    public function show($kode)
    {
        return Penelitian::where('kode', $kode)->firstOrFail();
    }
}
