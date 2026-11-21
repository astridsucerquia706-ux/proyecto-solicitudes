<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Subject extends Model
{
    protected $fillable = ['program_id', 'code', 'name', 'credits', 'semester'];

    public function program()
    {
        return $this->belongsTo(Program::class);
    }

    public function prerequisites()
    {
        return $this->belongsToMany(Subject::class, 'prerequisites', 'subject_id', 'required_subject_id');
    }

    public function enrollments()
    {
        return $this->hasMany(Enrollment::class);
    }
}
