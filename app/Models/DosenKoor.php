<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DosenKoor extends Model
{
    protected $table = 'dosenkoor';
    protected $primaryKey = 'kodeDosen';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'kodeDosen', 'matkulKoor', 'kontakKoor', 'email'
    ];
}