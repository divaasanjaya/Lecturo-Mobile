<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $user = DB::table('dosen')
            ->where('kode', $request->username)
            ->where('password', $request->password)
            ->first();

        if ($user) {
            return response()->json(['message' => 'Login berhasil']);
        }

        return response()->json(['message' => 'Login gagal'], 401);
    }

    public function logout()
    {
        return response()->json(['message' => 'Logout berhasil']);
    }
}
