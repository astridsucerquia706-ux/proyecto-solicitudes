<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Period;
use App\Support\Procedure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ReportController extends Controller
{
    public function periods()
    {
        return response()->json(['datos' => Period::orderByDesc('start_date')->get(['id', 'name'])]);
    }

    public function requests(Request $request)
    {
        return response()->json(['datos' => $this->datosSolicitudes($request->period_id)]);
    }

    public function averages()
    {
        return response()->json(['datos' => $this->datosPromedios()]);
    }

    public function activities()
    {
        return response()->json(['datos' => $this->datosActividades()]);
    }

    public function export(Request $request, string $tipo)
    {
        switch ($tipo) {
            case 'solicitudes':
                $filas = $this->datosSolicitudes($request->period_id);
                $encabezado = ['Periodo', 'Estado', 'Cantidad'];
                $campos = ['periodo', 'estado', 'cantidad'];
                break;
            case 'promedios':
                $filas = $this->datosPromedios();
                $encabezado = ['Programa', 'Estudiantes', 'Promedio'];
                $campos = ['programa', 'estudiantes', 'promedio'];
                break;
            case 'actividades':
                $filas = $this->datosActividades();
                $encabezado = ['Programa', 'Tipo de actividad', 'Cantidad'];
                $campos = ['programa', 'tipo', 'cantidad'];
                break;
            default:
                return $this->error('Tipo de reporte no válido', 404);
        }

        $callback = function () use ($filas, $encabezado, $campos) {
            $salida = fopen('php://output', 'w');
            fwrite($salida, "\xEF\xBB\xBF");
            fputcsv($salida, $encabezado, ';');
            foreach ($filas as $fila) {
                fputcsv($salida, array_map(fn ($c) => $fila->$c, $campos), ';');
            }
            fclose($salida);
        };

        return response()->stream($callback, 200, [
            'Content-Type' => 'text/csv; charset=UTF-8',
            'Content-Disposition' => "attachment; filename=reporte_{$tipo}.csv",
        ]);
    }

    private function datosSolicitudes($periodId)
    {
        return Procedure::call('CALL sp_reporte_solicitudes(?)', [$periodId ?: null]);
    }

    private function datosPromedios()
    {
        return Procedure::call('CALL sp_promedios_por_programa()');
    }

    private function datosActividades()
    {
        return DB::select("
            SELECT pr.name AS programa, t.name AS tipo, COUNT(*) AS cantidad
            FROM activities a
            JOIN activity_types t ON t.id = a.activity_type_id
            JOIN students s ON s.id = a.student_id
            JOIN programs pr ON pr.id = s.program_id
            GROUP BY pr.name, t.name
            ORDER BY pr.name, cantidad DESC
        ");
    }
}
