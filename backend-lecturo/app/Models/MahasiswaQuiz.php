<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MahasiswaQuiz extends Model
{
    protected $table = 'mahasiswa_quiz';
    public $incrementing = false;
    public $timestamps = false;

    protected $fillable = [
        'nim', 'nilai', 'namaQuiz', 'kodeKelas'
    ];
}