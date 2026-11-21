<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Audit;
use App\Models\CancellationRequest;
use App\Models\Enrollment;
use Illuminate\Http\Request;
use App\Support\Procedure;

class RequestController extends Controller
{
    private array $relaciones = [
        'enrollment.subject:id,code,name',
        'enrollment.period:id,name',
        'reviewer:id,name',
    ];

    public function myIndex(Request $request)
    {
        $studentId = $request->user()->student->id;

        $requests = CancellationRequest::with($this->relaciones)
            ->whereHas('enrollment', fn ($q) => $q->where('student_id', $studentId))
            ->orderByDesc('created_at')
            ->get();

        return response()->json(['datos' => $requests]);
    }

    public function store(Request $request)
    {
        if ($error = $this->validar($request->all(), [
            'enrollment_id' => 'required|integer',
            'reason' => 'required|string|min:10|max:255',
        ], [
            'enrollment_id.required' => 'Debe seleccionar la materia que desea cancelar',
            'reason.required' => 'El motivo es obligatorio',
            'reason.min' => 'Explique el motivo con al menos 10 caracteres',
            'reason.max' => 'El motivo admite máximo 255 caracteres',
        ])) {
            return $error;
        }

        $enrollment = Enrollment::where('id', $request->enrollment_id)
            ->where('student_id', $request->user()->student->id)
            ->first();

        if (! $enrollment) {
            return $this->error('La materia seleccionada no pertenece a su historial');
        }

        try {
            $cancellation = CancellationRequest::create([
                'enrollment_id' => $enrollment->id,
                'reason' => $request->reason,
            ]);
        } catch (\PDOException $e) {
            return $this->errorBaseDatos($e);
        }

        return response()->json([
            'mensaje' => 'Solicitud enviada',
            'dato' => $cancellation->fresh()->load($this->relaciones),
        ], 201);
    }

    public function index(Request $request)
    {
        $query = CancellationRequest::with(array_merge($this->relaciones, [
            'enrollment.student:id,user_id,document,program_id',
            'enrollment.student.user:id,name',
            'enrollment.student.program:id,name',
        ]));

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }
        if ($request->filled('period_id')) {
            $query->whereHas('enrollment', fn ($q) => $q->where('period_id', $request->period_id));
        }
        if ($request->filled('q')) {
            $texto = $request->q;
            $query->whereHas('enrollment.student', function ($q) use ($texto) {
                $q->where('document', 'like', "%{$texto}%")
                  ->orWhereHas('user', fn ($u) => $u->where('name', 'like', "%{$texto}%"));
            });
        }

        $requests = $query->orderByRaw("status = 'pendiente' DESC")->orderByDesc('created_at')->get();

        return response()->json(['datos' => $requests]);
    }

    public function show($id)
    {
        $cancellation = CancellationRequest::with(array_merge($this->relaciones, [
            'enrollment.student:id,user_id,document,program_id',
            'enrollment.student.user:id,name,email',
            'enrollment.student.program:id,name',
        ]))->findOrFail($id);

        $historial = Audit::with('user:id,name')
            ->where('table_name', 'requests')
            ->where('record_id', $cancellation->id)
            ->orderBy('id')
            ->get();

        return response()->json(['dato' => $cancellation, 'historial' => $historial]);
    }

    public function decide(Request $request, $id)
    {
        if ($error = $this->validar($request->all(), [
            'decision' => 'required|in:aprobada,rechazada',
            'observation' => 'required|string|min:5|max:255',
        ], [
            'decision.required' => 'Debe indicar si aprueba o rechaza la solicitud',
            'decision.in' => 'La decisión debe ser aprobada o rechazada',
            'observation.required' => 'La observación es obligatoria',
            'observation.min' => 'La observación debe tener al menos 5 caracteres',
            'observation.max' => 'La observación admite máximo 255 caracteres',
        ])) {
            return $error;
        }

        $cancellation = CancellationRequest::findOrFail($id);

        try {
            Procedure::call('CALL sp_resolver_solicitud(?, ?, ?, ?)', [
                $cancellation->id,
                $request->user()->id,
                $request->decision,
                $request->observation,
            ]);
        } catch (\PDOException $e) {
            return $this->errorBaseDatos($e);
        }

        $cancellation = $cancellation->fresh()->load(array_merge($this->relaciones, [
            'enrollment:id,student_id,subject_id,period_id,status',
            'enrollment.student:id,user_id',
        ]));

        return response()->json([
            'mensaje' => $request->decision === 'aprobada' ? 'Solicitud aprobada' : 'Solicitud rechazada',
            'dato' => $cancellation,
            'student_user_id' => $cancellation->enrollment->student->user_id,
        ]);
    }
}
