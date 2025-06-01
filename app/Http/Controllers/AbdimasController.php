<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Abdimas;

class AbdimasController extends Controller
{
    public function index()
    {
        return Abdimas::all();
    }

    public function upsert(Request $request)
    {
        $validated = $request->validate([
            'kode' => 'required|string',
            'nama' => 'required|string',
            'deskripsi' => 'nullable|string',
            'tanggal' => 'required|date',
        ]);

        $abdimas = Abdimas::updateOrCreate(
            ['kode' => $validated['kode']],
            $validated
        );

        return response()->json($abdimas);
    }

    public function destroy($kode)
    {
        Abdimas::where('kode', $kode)->delete();
        return response()->json(['message' => 'Abdimas berhasil dihapus']);
    }

    public function show($kode)
    {
        return Abdimas::where('kode', $kode)->firstOrFail();
    }
}
