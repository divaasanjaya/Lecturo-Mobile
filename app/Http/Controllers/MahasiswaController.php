<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Mahasiswa;

class MahasiswaController extends Controller
{
    public function upsert(Request $request)
    {
        $validated = $request->validate([
            'NIM' => 'required|string',
            'nama' => 'required|string',
            'kodeKelas' => 'required|string',
        ]);

        $mahasiswa = Mahasiswa::updateOrCreate(
            ['NIM' => $validated['NIM']],
            $validated
        );

        return response()->json($mahasiswa);
    }

    public function destroy($nim)
    {
        Mahasiswa::where('NIM', $nim)->delete();
        return response()->json(['message' => 'Mahasiswa dihapus']);
    }

    public function show($nim)
    {
        return Mahasiswa::where('NIM', $nim)->firstOrFail();
    }
}
