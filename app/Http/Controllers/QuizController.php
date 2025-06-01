<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\Quiz;

class QuizController extends Controller
{
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nama' => 'required|string',
            'kodeMatkul' => 'required|string',
            'deskripsi' => 'nullable|string',
            'tanggal' => 'required|date',
            'kodeKelas' => 'required|string',
        ]);

        $quiz = Quiz::updateOrCreate(
            ['nama' => $validated['nama'], 'kodeMatkul' => $validated['kodeMatkul']],
            $validated
        );

        return response()->json($quiz);
    }

    public function destroy(Request $request)
    {
        Quiz::where('nama', $request->nama)
            ->where('kodeMatkul', $request->kodeMatkul)
            ->delete();

        return response()->json(['message' => 'Quiz berhasil dihapus']);
    }

    public function show(Request $request)
    {
        return Quiz::where('nama', $request->nama)
            ->where('kodeMatkul', $request->kodeMatkul)
            ->firstOrFail();
    }

    public function getNilai(Request $request)
    {
        return DB::table('mahasiswa_quiz')
            ->where('namaQuiz', $request->namaQuiz)
            ->where('kodeKelas', $request->kodeKelas)
            ->get();
    }

    public function updateNilai(Request $request)
    {
        $validated = $request->validate([
            'nim' => 'required|string',
            'namaQuiz' => 'required|string',
            'nilai' => 'required|numeric',
            'kodeKelas' => 'required|string',
        ]);

        DB::table('mahasiswa_quiz')->updateOrInsert(
            ['nim' => $validated['nim'], 'namaQuiz' => $validated['namaQuiz']],
            $validated
        );

        return response()->json(['message' => 'Nilai berhasil diupdate']);
    }
}
