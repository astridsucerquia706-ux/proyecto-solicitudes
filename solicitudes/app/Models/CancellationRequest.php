<?php

namespace App\Models;

use DateTimeInterface;
use Illuminate\Database\Eloquent\Model;

class CancellationRequest extends Model
{
    protected $table = 'requests';

    protected $fillable = ['enrollment_id', 'reason'];

    protected $casts = [
        'created_at' => 'datetime:Y-m-d H:i',
        'updated_at' => 'datetime:Y-m-d H:i',
        'decided_at' => 'datetime:Y-m-d H:i',
    ];

    protected function serializeDate(DateTimeInterface $date)
    {
        return $date->format('Y-m-d H:i');
    }

    public function enrollment()
    {
        return $this->belongsTo(Enrollment::class);
    }

    public function reviewer()
    {
        return $this->belongsTo(User::class, 'reviewer_id');
    }
}
