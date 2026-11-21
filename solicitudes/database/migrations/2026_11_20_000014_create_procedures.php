<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up()
    {
        $this->down();

        DB::unprepared("
            CREATE PROCEDURE sp_resolver_solicitud(
                IN p_request_id BIGINT UNSIGNED,
                IN p_reviewer_id BIGINT UNSIGNED,
                IN p_decision VARCHAR(20),
                IN p_observation VARCHAR(255)
            )
            BEGIN
                DECLARE v_status VARCHAR(20);

                DECLARE EXIT HANDLER FOR SQLEXCEPTION
                BEGIN
                    ROLLBACK;
                    RESIGNAL;
                END;

                IF p_decision NOT IN ('aprobada', 'rechazada') THEN
                    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La decisión debe ser aprobada o rechazada';
                END IF;

                START TRANSACTION;

                SELECT status INTO v_status FROM requests WHERE id = p_request_id FOR UPDATE;
                IF v_status IS NULL THEN
                    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La solicitud no existe';
                END IF;
                IF v_status <> 'pendiente' THEN
                    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La solicitud ya fue resuelta';
                END IF;

                UPDATE requests
                SET status = p_decision,
                    reviewer_id = p_reviewer_id,
                    observation = p_observation,
                    updated_at = NOW()
                WHERE id = p_request_id;

                COMMIT;
            END
        ");

        DB::unprepared("
            CREATE PROCEDURE sp_reporte_solicitudes(IN p_period_id BIGINT UNSIGNED)
            BEGIN
                SELECT p.name AS periodo, r.status AS estado, COUNT(*) AS cantidad
                FROM requests r
                JOIN enrollments e ON e.id = r.enrollment_id
                JOIN periods p ON p.id = e.period_id
                WHERE p_period_id IS NULL OR e.period_id = p_period_id
                GROUP BY p.name, r.status
                ORDER BY p.name, r.status;
            END
        ");

        DB::unprepared("
            CREATE PROCEDURE sp_promedios_por_programa()
            BEGIN
                DECLARE v_done INT DEFAULT 0;
                DECLARE v_program_id BIGINT UNSIGNED;
                DECLARE v_program_name VARCHAR(100);
                DECLARE v_average DECIMAL(3,2);
                DECLARE v_students INT;

                DECLARE cur_programs CURSOR FOR SELECT id, name FROM programs ORDER BY name;
                DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;

                DROP TEMPORARY TABLE IF EXISTS tmp_promedios;
                CREATE TEMPORARY TABLE tmp_promedios (
                    programa VARCHAR(100),
                    estudiantes INT,
                    promedio DECIMAL(3,2)
                );

                OPEN cur_programs;
                recorrer: LOOP
                    FETCH cur_programs INTO v_program_id, v_program_name;
                    IF v_done = 1 THEN
                        LEAVE recorrer;
                    END IF;

                    SELECT COUNT(*) INTO v_students FROM students WHERE program_id = v_program_id;

                    SELECT AVG(e.grade) INTO v_average
                    FROM enrollments e
                    JOIN students s ON s.id = e.student_id
                    WHERE s.program_id = v_program_id AND e.status IN ('aprobada', 'reprobada');

                    INSERT INTO tmp_promedios VALUES (v_program_name, v_students, v_average);
                END LOOP;
                CLOSE cur_programs;

                SELECT programa, estudiantes, promedio FROM tmp_promedios;
                DROP TEMPORARY TABLE tmp_promedios;
            END
        ");

        DB::unprepared("
            CREATE FUNCTION fn_promedio_estudiante(p_student_id BIGINT UNSIGNED)
            RETURNS DECIMAL(3,2)
            READS SQL DATA
            BEGIN
                DECLARE v_average DECIMAL(3,2);
                SELECT AVG(grade) INTO v_average
                FROM enrollments
                WHERE student_id = p_student_id AND status IN ('aprobada', 'reprobada');
                RETURN v_average;
            END
        ");
    }

    public function down()
    {
        DB::unprepared('DROP PROCEDURE IF EXISTS sp_resolver_solicitud');
        DB::unprepared('DROP PROCEDURE IF EXISTS sp_reporte_solicitudes');
        DB::unprepared('DROP PROCEDURE IF EXISTS sp_promedios_por_programa');
        DB::unprepared('DROP FUNCTION IF EXISTS fn_promedio_estudiante');
    }
};
