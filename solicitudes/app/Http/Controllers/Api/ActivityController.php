<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Activity;
use App\Models\ActivityType;
use Illuminate\Http\Request;

class ActivityController extends Controller
{
    public function types()
    {
        return response()->json(['datos' => ActivityType::orderBy('name')->get(['id', 'name'])]);
    }

    public function index(Request $request)
    {
        $activities = Activity::with('type:id,name')
            ->where('student_id', $request->user()->student->id)
            ->orderByDesc('date')
            ->get();

        return response()->json(['datos' => $activities]);
    }

    public function store(Request $request)
    {
        if ($error = $this->validar($request->all(), [
            'activity_type_id' => 'required|exists:activity_types,id',
            'name' => 'required|string|max:150',
            'date' => 'required|date|before_or_equal:today',
            'description' => 'nullable|string|max:255',
        ], [
            'activity_type_id.required' => 'El tipo de actividad es obligatorio',
            'activity_type_id.exists' => 'El tipo de actividad no existe',
            'name.required' => 'El nombre de la actividad es obligatorio',
            'name.max' => 'El nombre admite máximo 150 caracteres',
            'date.required' => 'La fecha es obligatoria',
            'date.date' => 'La fecha no es válida',
            'date.before_or_equal' => 'La fecha no puede ser futura: registre actividades en las que ya participó',
            'description.max' => 'La descripción admite máximo 255 caracteres',
        ])) {
            return $error;
        }

        $activity = Activity::create([
            'student_id' => $request->user()->student->id,
            'activity_type_id' => $request->activity_type_id,
            'name' => $request->name,
            'date' => $request->date,
            'description' => $request->description,
        ]);

        return response()->json(['mensaje' => 'Actividad registrada', 'dato' => $activity->load('type:id,name')], 201);
    }

    public function destroy(Request $request, $id)
    {
        $activity = Activity::where('student_id', $request->user()->student->id)->findOrFail($id);
        $activity->delete();

        return response()->json(['mensaje' => 'Actividad eliminada']);
    }
}
