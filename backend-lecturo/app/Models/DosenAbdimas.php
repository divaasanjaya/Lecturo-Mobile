<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DosenAbdimas extends Model
{
    protected $table = 'dosen_abdimas';
    public $incrementing = false;
    public $timestamps = false;

    protected $fillable = [
        'kodeDosen', 'kodeAbdimas'
    ];
}
