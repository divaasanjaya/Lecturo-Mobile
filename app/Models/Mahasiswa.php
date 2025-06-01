<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Mahasiswa extends Model
{
    protected $table = 'mahasiswa';
    protected $primaryKey = 'NIM';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'NIM', 'nama', 'kodeKelas'
    ];
}