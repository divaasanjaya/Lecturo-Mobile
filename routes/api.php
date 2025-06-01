<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\QuizController;
use App\Http\Controllers\MahasiswaController;
use App\Http\Controllers\AbdimasController;
use App\Http\Controllers\PenelitianController;
use App\Http\Controllers\MasterController;

// AUTH
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout']);

// QUIZ
Route::prefix('quiz')->group(function () {
    Route::post('/add', [QuizController::class, 'store']);
    Route::delete('/{id}', [QuizController::class, 'destroy']);
    Route::get('/{id}', [QuizController::class, 'show']);
    Route::get('/{id}/nilai', [QuizController::class, 'getNilai']);
    Route::post('/{id}/nilai', [QuizController::class, 'updateNilai']);
});

// MAHASISWA
Route::prefix('mahasiswa')->group(function () {
    Route::post('/save', [MahasiswaController::class, 'upsert']);
    Route::delete('/{id}', [MahasiswaController::class, 'destroy']);
    Route::get('/{id}', [MahasiswaController::class, 'show']);
});

// ABDIMAS
Route::prefix('abdimas')->group(function () {
    Route::get('/', [AbdimasController::class, 'index']);
    Route::post('/save', [AbdimasController::class, 'upsert']);
    Route::delete('/{id}', [AbdimasController::class, 'destroy']);
    Route::get('/{id}', [AbdimasController::class, 'show']);
});

// PENELITIAN
Route::prefix('penelitian')->group(function () {
    Route::get('/', [PenelitianController::class, 'index']);
    Route::post('/save', [PenelitianController::class, 'upsert']);
    Route::delete('/{id}', [PenelitianController::class, 'destroy']);
    Route::get('/{id}', [PenelitianController::class, 'show']);
});

// MASTER DATA
Route::get('/dosen', [MasterController::class, 'getAllDosen']);
Route::get('/dosen-koor', [MasterController::class, 'getDosenKoor']);
Route::get('/course', [MasterController::class, 'getCourse']);
Route::get('/course2', [MasterController::class, 'getCourse2']);
