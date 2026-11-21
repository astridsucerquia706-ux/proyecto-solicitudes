<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Support\Facades\Validator;

class Controller extends BaseController
{
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests;

    protected function validar(array $data, array $rules, array $messages = [])
    {
        $validator = Validator::make($data, $rules, $messages);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 400);
        }

        return null;
    }

    protected function error(string $message, int $status = 400)
    {
        return response()->json(['error' => $message], $status);
    }

    protected function errorBaseDatos(\PDOException $e)
    {
        $info = $e->errorInfo;

        if (isset($info[0], $info[2]) && $info[0] === '45000') {
            return $this->error($info[2]);
        }

        return $this->error('No se pudo completar la operación en la base de datos', 500);
    }
}
