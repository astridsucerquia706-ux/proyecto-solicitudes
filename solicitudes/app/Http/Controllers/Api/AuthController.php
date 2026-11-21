<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        if ($error = $this->validar($request->all(), [
            'email' => 'required|email',
            'password' => 'required',
        ], [
            'email.required' => 'El correo es obligatorio',
            'email.email' => 'El correo no es válido',
            'password.required' => 'La contraseña es obligatoria',
        ])) {
            return $error;
        }

        $user = User::with('role', 'student')->where('email', $request->email)->first();

        if (! $user || ! Hash::check($request->password, $user->password)) {
            return $this->error('Correo o contraseña incorrectos', 401);
        }

        $token = $user->createToken('api')->plainTextToken;

        return response()->json(['token' => $token, 'usuario' => $this->datosUsuario($user)]);
    }

    public function me(Request $request)
    {
        $user = $request->user()->load('role', 'student');

        return response()->json(['dato' => $this->datosUsuario($user)]);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json(['mensaje' => 'Sesión cerrada']);
    }

    private function datosUsuario(User $user): array
    {
        return [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'role' => $user->role->name,
            'student_id' => optional($user->student)->id,
        ];
    }
}
