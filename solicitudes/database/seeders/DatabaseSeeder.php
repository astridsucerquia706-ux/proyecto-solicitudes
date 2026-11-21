<?php

namespace Database\Seeders;

use App\Models\Activity;
use App\Models\ActivityType;
use App\Models\CancellationRequest;
use App\Models\Enrollment;
use App\Models\Period;
use App\Models\Program;
use App\Models\Role;
use App\Models\Student;
use App\Models\Subject;
use App\Models\User;
use App\Support\Procedure;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run()
    {
        $rolEstudiante = Role::create(['name' => 'estudiante']);
        $rolDocente = Role::create(['name' => 'docente']);
        $clave = Hash::make('clave123');

        $docente1 = User::create(['name' => 'Carlos Ramírez', 'email' => 'docente1@pascualbravo.test', 'password' => $clave, 'role_id' => $rolDocente->id]);
        User::create(['name' => 'Marta Restrepo', 'email' => 'docente2@pascualbravo.test', 'password' => $clave, 'role_id' => $rolDocente->id]);

        $software = Program::create(['name' => 'Ingeniería de Software']);
        $tecnologia = Program::create(['name' => 'Tecnología en Desarrollo de Software']);

        $planes = [
            [$software, [
                'ISW101' => ['Fundamentos de Programación', 3, 1, []],
                'ISW102' => ['Cálculo Diferencial', 4, 1, []],
                'ISW103' => ['Introducción a la Ingeniería de Software', 2, 1, []],
                'ISW104' => ['Matemáticas Discretas', 3, 1, []],
                'ISW105' => ['Comunicación Oral y Escrita', 2, 1, []],
                'ISW106' => ['Inglés I', 2, 1, []],
                'ISW201' => ['Programación Orientada a Objetos', 3, 2, ['ISW101']],
                'ISW202' => ['Cálculo Integral', 4, 2, ['ISW102']],
                'ISW203' => ['Bases de Datos I', 3, 2, ['ISW101']],
                'ISW204' => ['Álgebra Lineal', 3, 2, ['ISW104']],
                'ISW205' => ['Inglés II', 2, 2, ['ISW106']],
                'ISW301' => ['Bases de Datos II', 3, 3, ['ISW203']],
                'ISW302' => ['Estructuras de Datos', 3, 3, ['ISW201']],
                'ISW303' => ['Física Mecánica', 3, 3, ['ISW202']],
                'ISW304' => ['Cálculo Multivariable', 3, 3, ['ISW202']],
                'ISW305' => ['Inglés III', 2, 3, ['ISW205']],
                'ISW306' => ['Ética Profesional', 2, 3, []],
                'ISW401' => ['Ingeniería de Software I', 3, 4, ['ISW301', 'ISW302']],
                'ISW402' => ['Programación Web', 3, 4, ['ISW201']],
                'ISW403' => ['Estadística y Probabilidad', 3, 4, ['ISW202']],
                'ISW404' => ['Física Eléctrica', 3, 4, ['ISW303']],
                'ISW405' => ['Inglés IV', 2, 4, ['ISW305']],
                'ISW501' => ['Ingeniería de Software II', 3, 5, ['ISW401']],
                'ISW502' => ['Sistemas Operativos', 3, 5, ['ISW302']],
                'ISW503' => ['Desarrollo Móvil', 3, 5, ['ISW402']],
                'ISW504' => ['Métodos Numéricos', 3, 5, ['ISW304']],
                'ISW505' => ['Inglés V', 2, 5, ['ISW405']],
                'ISW506' => ['Arquitectura de Computadores', 3, 5, ['ISW404']],
                'ISW601' => ['Arquitectura de Software', 3, 6, ['ISW501']],
                'ISW602' => ['Redes de Computadores', 3, 6, ['ISW502']],
                'ISW603' => ['Pruebas de Software', 3, 6, ['ISW501']],
                'ISW604' => ['Investigación de Operaciones', 3, 6, ['ISW403']],
                'ISW605' => ['Emprendimiento', 2, 6, []],
                'ISW606' => ['Inglés VI', 2, 6, ['ISW505']],
                'ISW701' => ['Gestión de Proyectos de Software', 3, 7, ['ISW601']],
                'ISW702' => ['Seguridad Informática', 3, 7, ['ISW602']],
                'ISW703' => ['Computación en la Nube', 3, 7, ['ISW602']],
                'ISW704' => ['Inteligencia Artificial', 3, 7, ['ISW403']],
                'ISW705' => ['Metodología de la Investigación', 2, 7, []],
                'ISW706' => ['Inglés VII', 2, 7, ['ISW606']],
                'ISW801' => ['Calidad de Software', 3, 8, ['ISW603']],
                'ISW802' => ['Aprendizaje Automático', 3, 8, ['ISW704']],
                'ISW803' => ['Electiva Profesional I', 3, 8, []],
                'ISW804' => ['Interacción Humano-Computador', 3, 8, ['ISW402']],
                'ISW805' => ['Seminario de Investigación', 2, 8, ['ISW705']],
                'ISW806' => ['Inglés VIII', 2, 8, ['ISW706']],
                'ISW901' => ['Proyecto de Grado I', 4, 9, ['ISW805']],
                'ISW902' => ['Electiva Profesional II', 3, 9, ['ISW803']],
                'ISW903' => ['Auditoría de Sistemas', 3, 9, ['ISW702']],
                'ISW904' => ['Legislación Informática', 2, 9, []],
                'ISW905' => ['Gerencia de Tecnologías de la Información', 3, 9, ['ISW701']],
                'ISW906' => ['Inglés IX', 2, 9, ['ISW806']],
                'ISW1001' => ['Proyecto de Grado II', 4, 10, ['ISW901']],
                'ISW1002' => ['Práctica Profesional', 6, 10, ['ISW901']],
                'ISW1003' => ['Electiva Profesional III', 3, 10, ['ISW902']],
                'ISW1004' => ['Innovación Tecnológica', 2, 10, []],
                'ISW1005' => ['Seminario de Grado', 2, 10, []],
                'ISW1006' => ['Inglés X', 2, 10, ['ISW906']],
            ]],
            [$tecnologia, [
                'TDS101' => ['Algoritmos', 3, 1, []],
                'TDS102' => ['Matemáticas Básicas', 3, 1, []],
                'TDS103' => ['Introducción a la Informática', 2, 1, []],
                'TDS104' => ['Comunicación Oral y Escrita', 2, 1, []],
                'TDS105' => ['Inglés I', 2, 1, []],
                'TDS201' => ['Programación Estructurada', 3, 2, ['TDS101']],
                'TDS202' => ['Estadística', 3, 2, ['TDS102']],
                'TDS203' => ['Bases de Datos', 3, 2, ['TDS101']],
                'TDS204' => ['Lógica Matemática', 3, 2, ['TDS102']],
                'TDS205' => ['Inglés II', 2, 2, ['TDS105']],
                'TDS301' => ['Programación Orientada a Objetos', 3, 3, ['TDS201']],
                'TDS302' => ['Desarrollo Web', 3, 3, ['TDS201']],
                'TDS303' => ['Sistemas Operativos', 3, 3, ['TDS103']],
                'TDS304' => ['Análisis de Sistemas', 3, 3, ['TDS203']],
                'TDS305' => ['Inglés III', 2, 3, ['TDS205']],
                'TDS401' => ['Desarrollo Móvil', 3, 4, ['TDS301']],
                'TDS402' => ['Desarrollo Web Avanzado', 3, 4, ['TDS302']],
                'TDS403' => ['Redes', 3, 4, ['TDS303']],
                'TDS404' => ['Ingeniería de Requisitos', 3, 4, ['TDS304']],
                'TDS405' => ['Ética Profesional', 2, 4, []],
                'TDS406' => ['Inglés IV', 2, 4, ['TDS305']],
                'TDS501' => ['Pruebas de Software', 3, 5, ['TDS404']],
                'TDS502' => ['Servicios Web', 3, 5, ['TDS402']],
                'TDS503' => ['Seguridad de la Información', 3, 5, ['TDS403']],
                'TDS504' => ['Gestión de Proyectos', 3, 5, ['TDS404']],
                'TDS505' => ['Emprendimiento', 2, 5, []],
                'TDS506' => ['Inglés V', 2, 5, ['TDS406']],
                'TDS601' => ['Proyecto Integrador', 4, 6, ['TDS501', 'TDS502']],
                'TDS602' => ['Práctica Profesional', 6, 6, ['TDS504']],
                'TDS603' => ['Electiva Tecnológica', 3, 6, []],
                'TDS604' => ['Computación en la Nube', 3, 6, ['TDS503']],
                'TDS605' => ['Seminario', 2, 6, []],
                'TDS606' => ['Inglés VI', 2, 6, ['TDS506']],
            ]],
        ];

        $m = [];
        foreach ($planes as [$program, $materias]) {
            foreach ($materias as $code => [$name, $credits, $semester]) {
                $m[$code] = Subject::create([
                    'program_id' => $program->id, 'code' => $code, 'name' => $name,
                    'credits' => $credits, 'semester' => $semester,
                ]);
            }
        }
        foreach ($planes as [$program, $materias]) {
            foreach ($materias as $code => [$name, $credits, $semester, $requisitos]) {
                foreach ($requisitos as $requisito) {
                    $m[$code]->prerequisites()->attach($m[$requisito]->id);
                }
            }
        }

        $p20251 = Period::create(['name' => '2025-1', 'start_date' => '2025-01-27', 'end_date' => '2025-06-07']);
        $p20252 = Period::create(['name' => '2025-2', 'start_date' => '2025-07-28', 'end_date' => '2025-12-06']);
        $p20261 = Period::create(['name' => '2026-1', 'start_date' => '2026-01-26', 'end_date' => '2026-06-06']);
        $p20262 = Period::create(['name' => '2026-2', 'start_date' => '2026-07-27', 'end_date' => '2026-12-05']);

        $crear = function ($name, $email, $program, $document, $extra) use ($clave, $rolEstudiante) {
            $user = User::create(['name' => $name, 'email' => $email, 'password' => $clave, 'role_id' => $rolEstudiante->id]);

            return Student::create(array_merge([
                'user_id' => $user->id, 'program_id' => $program->id, 'document' => $document,
            ], $extra));
        };

        $laura = $crear('Laura Gómez', 'laura.gomez@pascualbravo.test', $software, '1001234567',
            ['phone' => '3001112233', 'address' => 'Calle 50 # 40-20', 'birth_date' => '2005-03-14', 'gender' => 'Femenino', 'stratum' => 2, 'city' => 'Medellín']);
        $andres = $crear('Andrés Ríos', 'andres.rios@pascualbravo.test', $software, '1002345678',
            ['phone' => '3012223344', 'address' => 'Carrera 70 # 30-15', 'birth_date' => '2004-08-02', 'gender' => 'Masculino', 'stratum' => 3, 'city' => 'Bello']);
        $valentina = $crear('Valentina Torres', 'valentina.torres@pascualbravo.test', $software, '1003456789',
            ['phone' => '3023334455', 'birth_date' => '2007-01-20', 'gender' => 'Femenino', 'stratum' => 1, 'city' => 'Medellín']);
        $santiago = $crear('Santiago Herrera', 'santiago.herrera@pascualbravo.test', $tecnologia, '1004567890',
            ['phone' => '3034445566', 'birth_date' => '2003-11-09', 'gender' => 'Masculino', 'stratum' => 2, 'city' => 'Itagüí']);
        $camila = $crear('Camila Ospina', 'camila.ospina@pascualbravo.test', $tecnologia, '1005678901',
            ['phone' => '3045556677', 'birth_date' => '2005-06-30', 'gender' => 'Femenino', 'stratum' => 3, 'city' => 'Envigado']);

        $e = [];
        $matricular = function ($student, $period, array $notas) use ($m, &$e) {
            foreach ($notas as $code => $grade) {
                $status = $grade === null ? 'en_curso' : ($grade >= 3.0 ? 'aprobada' : 'reprobada');
                $e[$student->id . $code . $period->name] = Enrollment::create([
                    'student_id' => $student->id, 'subject_id' => $m[$code]->id,
                    'period_id' => $period->id, 'grade' => $grade, 'status' => $status,
                ]);
            }
        };

        $matricular($laura, $p20261, ['ISW101' => 4.2, 'ISW102' => 3.4, 'ISW103' => 4.5, 'ISW104' => 3.8, 'ISW105' => 4.6, 'ISW106' => 4.0]);
        $matricular($laura, $p20262, ['ISW201' => null, 'ISW202' => null, 'ISW203' => null, 'ISW204' => null, 'ISW205' => null]);

        $matricular($andres, $p20251, ['ISW101' => 3.8, 'ISW102' => 2.5, 'ISW103' => 4.0, 'ISW104' => 3.6, 'ISW105' => 4.2, 'ISW106' => 4.5]);
        $matricular($andres, $p20252, ['ISW102' => 3.2, 'ISW201' => 3.9, 'ISW203' => 4.1, 'ISW204' => 3.3, 'ISW205' => 3.7]);
        $matricular($andres, $p20261, ['ISW202' => 3.5, 'ISW301' => 4.0, 'ISW302' => 3.4, 'ISW305' => 3.9, 'ISW306' => 4.3]);
        $matricular($andres, $p20262, ['ISW303' => null, 'ISW304' => null, 'ISW401' => null, 'ISW402' => null, 'ISW405' => null]);

        $matricular($valentina, $p20262, ['ISW101' => null, 'ISW102' => null, 'ISW103' => null, 'ISW104' => null, 'ISW105' => null, 'ISW106' => null]);

        $matricular($santiago, $p20261, ['TDS101' => 4.4, 'TDS102' => 3.0, 'TDS103' => 3.9, 'TDS104' => 4.1, 'TDS105' => 3.5]);
        $matricular($santiago, $p20262, ['TDS201' => null, 'TDS202' => null, 'TDS203' => null, 'TDS204' => null, 'TDS205' => null]);

        $matricular($camila, $p20252, ['TDS101' => 3.6, 'TDS102' => 2.8, 'TDS103' => 4.1, 'TDS104' => 3.9, 'TDS105' => 4.0]);
        $matricular($camila, $p20261, ['TDS102' => 3.5, 'TDS201' => 4.0, 'TDS203' => 3.8, 'TDS205' => 3.6]);
        $matricular($camila, $p20262, ['TDS202' => null, 'TDS204' => null, 'TDS301' => null, 'TDS302' => null, 'TDS304' => null, 'TDS305' => null]);

        $tipos = [];
        foreach (['Congreso', 'Semillero de investigación', 'Proyecto de investigación', 'Publicación', 'Deporte', 'Otro'] as $nombre) {
            $tipos[$nombre] = ActivityType::create(['name' => $nombre]);
        }
        foreach ([
            [$laura, 'Semillero de investigación', 'Semillero de Bases de Datos', '2026-03-10', 'Participación en el semillero del programa'],
            [$laura, 'Deporte', 'Torneo interno de voleibol', '2026-05-22', 'Equipo femenino de la facultad'],
            [$andres, 'Congreso', 'Congreso de Ingeniería 2026', '2026-04-18', 'Asistente'],
            [$andres, 'Proyecto de investigación', 'Prototipo de inventarios', '2026-09-05', 'Apoyo en el desarrollo'],
            [$santiago, 'Deporte', 'Selección de fútbol sala', '2026-08-15', null],
            [$camila, 'Publicación', 'Artículo en revista estudiantil', '2026-06-01', 'Coautora'],
            [$camila, 'Congreso', 'Encuentro de Semilleros', '2026-10-02', 'Ponente'],
        ] as [$student, $tipo, $name, $date, $description]) {
            Activity::create([
                'student_id' => $student->id, 'activity_type_id' => $tipos[$tipo]->id,
                'name' => $name, 'date' => $date, 'description' => $description,
            ]);
        }

        $solicitar = function ($student, $code, $reason) use ($e, $p20262) {
            DB::statement('SET @app_user_id = ?', [$student->user_id]);

            return CancellationRequest::create([
                'enrollment_id' => $e[$student->id . $code . $p20262->name]->id,
                'reason' => $reason,
            ]);
        };

        $solicitar($laura, 'ISW202', 'Cambié de horario en el trabajo y no puedo asistir a las clases de la tarde.');
        $aprobar = $solicitar($andres, 'ISW303', 'Tengo carga académica alta y prefiero ver Física Mecánica el próximo semestre.');
        $rechazar = $solicitar($santiago, 'TDS202', 'No me está yendo bien en los parciales.');
        $solicitar($camila, 'TDS301', 'Problemas de salud que me impiden asistir durante varias semanas.');

        DB::statement('SET @app_user_id = ?', [$docente1->id]);
        Procedure::call('CALL sp_resolver_solicitud(?, ?, ?, ?)', [$aprobar->id, $docente1->id, 'aprobada', 'Se aprueba: la solicitud está dentro de las fechas del calendario académico.']);
        Procedure::call('CALL sp_resolver_solicitud(?, ?, ?, ?)', [$rechazar->id, $docente1->id, 'rechazada', 'Se rechaza: el bajo rendimiento no es causal de cancelación; se recomienda tutoría.']);
        DB::statement('SET @app_user_id = NULL');
    }
}
