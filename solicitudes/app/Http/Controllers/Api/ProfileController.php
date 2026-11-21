<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class ProfileController extends Controller
{
    public function show(Request $request)
    {
        $student = $request->user()->student->load('user:id,name,email', 'program');

        return response()->json(['dato' => $student]);
    }

    public function update(Request $request)
    {
        if ($error = $this->validar($request->all(), [
            'phone' => 'nullable|string|max:20',
            'address' => 'nullable|string|max:150',
            'birth_date' => 'nullable|date|before:today',
            'gender' => 'nullable|in:Femenino,Masculino,No binario,Prefiero no decir',
            'stratum' => 'nullable|integer|between:1,6',
            'city' => 'nullable|string|max:60',
        ], [
            'phone.max' => 'El teléfono admite máximo 20 caracteres',
            'address.max' => 'La dirección admite máximo 150 caracteres',
            'birth_date.date' => 'La fecha de nacimiento no es válida',
            'birth_date.before' => 'La fecha de nacimiento debe ser anterior a hoy',
            'gender.in' => 'El género seleccionado no es válido',
            'stratum.between' => 'El estrato debe estar entre 1 y 6',
            'stratum.integer' => 'El estrato debe ser un número',
            'city.max' => 'La ciudad admite máximo 60 caracteres',
        ])) {
            return $error;
        }

        $student = $request->user()->student;
        $student->update($request->only(['phone', 'address', 'birth_date', 'gender', 'stratum', 'city']));

        return response()->json(['mensaje' => 'Datos actualizados', 'dato' => $student->load('user:id,name,email', 'program')]);
    }
}
