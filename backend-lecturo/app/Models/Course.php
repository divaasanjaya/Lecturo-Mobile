<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Course extends Model
{
    protected $table = 'course';
    protected $primaryKey = 'kodeMatkul';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'kodeMatkul', 'nama', 'kodeKelas', 'sks', 'dosenPengampu'
    ];
}
