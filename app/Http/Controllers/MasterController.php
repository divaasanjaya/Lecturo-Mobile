<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class MasterController extends Controller
{
    public function getAllDosen()
    {
        return DB::table('dosen')->get();
    }

    public function getDosenKoor()
    {
        return DB::table('dosenkoor')->get();
    }

    public function getCourse()
    {
        return DB::table('course')->get();
    }

    public function getCourse2(Request $request)
    {
        $validated = $request->validate([
            'kodeKelas' => 'required|string',
        ]);

        return DB::table('course')
            ->where('kodeKelas', $validated['kodeKelas'])
            ->get();
    }
}
