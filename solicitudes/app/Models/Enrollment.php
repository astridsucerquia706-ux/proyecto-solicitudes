<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Enrollment extends Model
{
    protected $fillable = ['student_id', 'subject_id', 'period_id', 'grade', 'status'];

    public function student()
    {
        return $this->belongsTo(Student::class);
    }

    public function subject()
    {
        return $this->belongsTo(Subject::class);
    }

    public function period()
    {
        return $this->belongsTo(Period::class);
    }

    public function requests()
    {
        return $this->hasMany(CancellationRequest::class);
    }
}
