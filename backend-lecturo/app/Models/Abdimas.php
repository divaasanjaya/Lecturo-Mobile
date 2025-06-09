<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Abdimas extends Model
{
    protected $table = 'abdimas';
    protected $primaryKey = 'kode';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'kode', 'nama', 'deskripsi', 'tanggal'
    ];
}
