<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Enrollment;
use App\Models\Subject;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AcademicController extends Controller
{
    public function history(Request $request)
    {
        $studentId = $request->user()->student->id;

        $enrollments = Enrollment::with('subject:id,code,name,credits,semester', 'period:id,name')
            ->join('periods', 'periods.id', '=', 'enrollments.period_id')
            ->join('subjects', 'subjects.id', '=', 'enrollments.subject_id')
            ->where('enrollments.student_id', $studentId)
            ->orderBy('periods.start_date')
            ->orderBy('subjects.semester')
            ->orderBy('subjects.code')
            ->select('enrollments.*')
            ->get();

        $promedio = DB::selectOne('SELECT fn_promedio_estudiante(?) AS promedio', [$studentId])->promedio;

        return response()->json(['datos' => $enrollments, 'promedio' => $promedio]);
    }

    public function pending(Request $request)
    {
        $student = $request->user()->student;

        $matriculas = Enrollment::where('student_id', $student->id)
            ->whereIn('status', ['aprobada', 'en_curso'])
            ->get()
            ->keyBy('subject_id');
        $aprobadas = $matriculas->where('status', 'aprobada')->keys()->all();

        $materias = Subject::with('prerequisites:id,code,name')
            ->where('program_id', $student->program_id)
            ->orderBy('semester')->orderBy('code')
            ->get()
            ->map(function ($subject) use ($aprobadas, $matriculas) {
                $prerrequisitos = $subject->prerequisites->map(fn ($p) => [
                    'code' => $p->code,
                    'name' => $p->name,
                    'aprobada' => in_array($p->id, $aprobadas),
                ]);
                $matricula = $matriculas->get($subject->id);

                if ($matricula && $matricula->status === 'aprobada') {
                    $situacion = 'aprobada';
                } elseif ($matricula && $matricula->status === 'en_curso') {
                    $situacion = 'en_curso';
                } elseif ($prerrequisitos->every(fn ($p) => $p['aprobada'])) {
                    $situacion = 'disponible';
                } else {
                    $situacion = 'bloqueada';
                }

                return [
                    'id' => $subject->id,
                    'code' => $subject->code,
                    'name' => $subject->name,
                    'credits' => $subject->credits,
                    'semester' => $subject->semester,
                    'situacion' => $situacion,
                    'nota' => $situacion === 'aprobada' ? $matricula->grade : null,
                    'prerrequisitos' => $prerrequisitos,
                ];
            });

        return response()->json(['datos' => $materias]);
    }

    public function cancelable(Request $request)
    {
        $studentId = $request->user()->student->id;

        $enrollments = Enrollment::with('subject:id,code,name', 'period:id,name')
            ->where('student_id', $studentId)
            ->where('status', 'en_curso')
            ->whereDoesntHave('requests', fn ($q) => $q->where('status', 'pendiente'))
            ->get();

        return response()->json(['datos' => $enrollments]);
    }
}
