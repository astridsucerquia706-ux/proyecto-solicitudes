<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Activity extends Model
{
    protected $fillable = ['student_id', 'activity_type_id', 'name', 'date', 'description'];

    protected $casts = ['date' => 'date:Y-m-d'];

    public function student()
    {
        return $this->belongsTo(Student::class);
    }

    public function type()
    {
        return $this->belongsTo(ActivityType::class, 'activity_type_id');
    }
}
