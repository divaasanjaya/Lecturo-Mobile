<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Quiz extends Model
{
    protected $table = 'quiz';
    public $timestamps = false; // Jika tidak ada kolom created_at / updated_at

    protected $fillable = [
        'nama', 'kodeMatkul', 'deskripsi', 'tanggal', 'kodeKelas'
    ];
}