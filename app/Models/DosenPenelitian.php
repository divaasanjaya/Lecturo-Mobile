<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DosenPenelitian extends Model
{
    protected $table = 'dosen_penelitian';
    public $incrementing = false;
    public $timestamps = false;

    protected $fillable = [
        'kodeDosen', 'kodePenelitian'
    ];
}