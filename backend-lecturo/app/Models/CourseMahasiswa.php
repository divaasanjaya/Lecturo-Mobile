<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CourseMahasiswa extends Model
{
    protected $table = 'course_mahasiswa';
    public $incrementing = false;
    public $timestamps = false;

    protected $fillable = [
        'kodeMatkul', 'NIM'
    ];
}
