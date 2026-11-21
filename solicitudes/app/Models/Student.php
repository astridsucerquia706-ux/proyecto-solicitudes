<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Student extends Model
{
    protected $fillable = [
        'user_id', 'program_id', 'document', 'phone', 'address',
        'birth_date', 'gender', 'stratum', 'city',
    ];

    protected $casts = ['birth_date' => 'date:Y-m-d'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function program()
    {
        return $this->belongsTo(Program::class);
    }

    public function enrollments()
    {
        return $this->hasMany(Enrollment::class);
    }

    public function activities()
    {
        return $this->hasMany(Activity::class);
    }
}
