<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\CancellationRequest;
use App\Models\Student;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class StudentController extends Controller
{
    public function index(Request $request)
    {
        $query = Student::with('user:id,name,email', 'program:id,name');

        if ($request->filled('q')) {
            $texto = $request->q;
            $query->where(function ($q) use ($texto) {
                $q->where('document', 'like', "%{$texto}%")
                  ->orWhereHas('user', fn ($u) => $u->where('name', 'like', "%{$texto}%"));
            });
        }

        $students = $query->get()->sortBy('user.name')->values();

        return response()->json(['datos' => $students]);
    }

    public function show($id)
    {
        $student = Student::with([
            'user:id,name,email',
            'program:id,name',
            'activities' => fn ($q) => $q->orderByDesc('date'),
            'activities.type:id,name',
        ])->findOrFail($id);

        $historial = $student->enrollments()
            ->with('subject:id,code,name,semester', 'period:id,name')
            ->join('periods', 'periods.id', '=', 'enrollments.period_id')
            ->join('subjects', 'subjects.id', '=', 'enrollments.subject_id')
            ->orderBy('periods.start_date')
            ->orderBy('subjects.semester')
            ->orderBy('subjects.code')
            ->select('enrollments.*')
            ->get();

        $solicitudes = CancellationRequest::with('enrollment.subject:id,code,name', 'enrollment.period:id,name', 'reviewer:id,name')
            ->whereHas('enrollment', fn ($q) => $q->where('student_id', $student->id))
            ->orderByDesc('created_at')
            ->get();

        $promedio = DB::selectOne('SELECT fn_promedio_estudiante(?) AS promedio', [$student->id])->promedio;

        return response()->json([
            'dato' => $student,
            'historial' => $historial,
            'solicitudes' => $solicitudes,
            'promedio' => $promedio,
        ]);
    }
}
