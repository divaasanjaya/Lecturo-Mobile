<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\QuizController;
use App\Http\Controllers\MahasiswaController;
use App\Http\Controllers\AbdimasController;
use App\Http\Controllers\PenelitianController;
use App\Http\Controllers\MasterController;
use App\Http\Controllers\OpenAIController;

Route::post('/send-message', [OpenAIController::class, 'sendMessage']);

// AUTH
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout']);

// QUIZ
Route::prefix('quiz')->group(function () {
    Route::post('/add', [QuizController::class, 'store']);
    Route::post('/delete', [QuizController::class, 'del']);
    Route::post('/', [QuizController::class, 'getQuiz']);
    Route::post('/nilai', [QuizController::class, 'getNilai']);
    Route::post('/editnilai', [QuizController::class, 'updateNilai']);
});

// MAHASISWA
Route::prefix('mahasiswa')->group(function () {
    Route::post('/save', [MahasiswaController::class, 'upsert']);
    Route::post('/delete', [MahasiswaController::class, 'del']);
    Route::post('/', [MahasiswaController::class, 'getMahasiswa']);
});

// ABDIMAS
Route::prefix('abdimas')->group(function () {
    Route::post('/', [AbdimasController::class, 'getAbdimasByDosen']);
    Route::post('/save', [AbdimasController::class, 'upsert']);
    Route::post('/delete', [AbdimasController::class, 'del']);
    Route::get('/{kode}', [AbdimasController::class, 'show']);
});

// PENELITIAN
Route::prefix('penelitian')->group(function () {
    Route::post('/', [PenelitianController::class, 'getPenelitianByDosen']);
    Route::post('/save', [PenelitianController::class, 'upsert']);
    Route::post('/delete', [PenelitianController::class, 'del']);
    Route::get('/{kode}', [PenelitianController::class, 'show']);
});

// MASTER DATA
Route::get('/dosen/{kode}', [MasterController::class, 'getDosen']);
Route::get('/dosen-koor/{kode}', [MasterController::class, 'getDosenKoor']);
Route::post('/course', [MasterController::class, 'getCourse']);
Route::post('/course2', [MasterController::class, 'getCourse2']);
