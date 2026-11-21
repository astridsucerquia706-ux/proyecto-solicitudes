<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    private array $triggers = [
        'trg_requests_before_insert',
        'trg_requests_after_insert',
        'trg_requests_before_update',
        'trg_requests_after_update',
        'trg_enrollments_before_update',
        'trg_enrollments_after_update',
    ];

    public function up()
    {
        $this->down();

        DB::unprepared("
            CREATE TRIGGER trg_requests_before_insert BEFORE INSERT ON requests
            FOR EACH ROW
            BEGIN
                DECLARE v_status VARCHAR(20);
                DECLARE v_pending INT;

                SELECT status INTO v_status FROM enrollments WHERE id = NEW.enrollment_id;
                IF v_status IS NULL OR v_status <> 'en_curso' THEN
                    SIGNAL SQLSTATE '45000'
                        SET MESSAGE_TEXT = 'Solo se puede solicitar la cancelación de una materia en curso';
                END IF;

                SELECT COUNT(*) INTO v_pending FROM requests
                WHERE enrollment_id = NEW.enrollment_id AND status = 'pendiente';
                IF v_pending > 0 THEN
                    SIGNAL SQLSTATE '45000'
                        SET MESSAGE_TEXT = 'Ya existe una solicitud pendiente para esta materia';
                END IF;

                SET NEW.status = 'pendiente';
                SET NEW.reviewer_id = NULL;
                SET NEW.observation = NULL;
                SET NEW.decided_at = NULL;
            END
        ");

        DB::unprepared("
            CREATE TRIGGER trg_requests_after_insert AFTER INSERT ON requests
            FOR EACH ROW
            BEGIN
                INSERT INTO audits (table_name, record_id, action, old_values, new_values, user_id, created_at)
                VALUES ('requests', NEW.id, 'INSERT', NULL,
                        JSON_OBJECT('enrollment_id', NEW.enrollment_id, 'reason', NEW.reason, 'status', NEW.status),
                        @app_user_id, NOW());
            END
        ");

        DB::unprepared("
            CREATE TRIGGER trg_requests_before_update BEFORE UPDATE ON requests
            FOR EACH ROW
            BEGIN
                IF OLD.status <> 'pendiente' AND NEW.status <> OLD.status THEN
                    SIGNAL SQLSTATE '45000'
                        SET MESSAGE_TEXT = 'La solicitud ya fue resuelta y no se puede cambiar';
                END IF;

                IF OLD.status = 'pendiente' AND NEW.status IN ('aprobada', 'rechazada') THEN
                    IF NEW.observation IS NULL OR TRIM(NEW.observation) = '' THEN
                        SIGNAL SQLSTATE '45000'
                            SET MESSAGE_TEXT = 'La observación es obligatoria para aprobar o rechazar';
                    END IF;
                    SET NEW.decided_at = NOW();
                END IF;
            END
        ");

        DB::unprepared("
            CREATE TRIGGER trg_requests_after_update AFTER UPDATE ON requests
            FOR EACH ROW
            BEGIN
                IF NEW.status = 'aprobada' AND OLD.status <> 'aprobada' THEN
                    UPDATE enrollments SET status = 'cancelada', updated_at = NOW()
                    WHERE id = NEW.enrollment_id;
                END IF;

                INSERT INTO audits (table_name, record_id, action, old_values, new_values, user_id, created_at)
                VALUES ('requests', NEW.id, 'UPDATE',
                        JSON_OBJECT('status', OLD.status, 'reviewer_id', OLD.reviewer_id, 'observation', OLD.observation),
                        JSON_OBJECT('status', NEW.status, 'reviewer_id', NEW.reviewer_id, 'observation', NEW.observation),
                        @app_user_id, NOW());
            END
        ");

        DB::unprepared("
            CREATE TRIGGER trg_enrollments_before_update BEFORE UPDATE ON enrollments
            FOR EACH ROW
            BEGIN
                IF NEW.grade IS NOT NULL AND NEW.status <> 'cancelada'
                   AND (OLD.grade IS NULL OR NEW.grade <> OLD.grade) THEN
                    SET NEW.status = IF(NEW.grade >= 3.0, 'aprobada', 'reprobada');
                END IF;
            END
        ");

        DB::unprepared("
            CREATE TRIGGER trg_enrollments_after_update AFTER UPDATE ON enrollments
            FOR EACH ROW
            BEGIN
                IF NOT (OLD.status <=> NEW.status) OR NOT (OLD.grade <=> NEW.grade) THEN
                    INSERT INTO audits (table_name, record_id, action, old_values, new_values, user_id, created_at)
                    VALUES ('enrollments', NEW.id, 'UPDATE',
                            JSON_OBJECT('status', OLD.status, 'grade', OLD.grade),
                            JSON_OBJECT('status', NEW.status, 'grade', NEW.grade),
                            @app_user_id, NOW());
                END IF;
            END
        ");
    }

    public function down()
    {
        foreach ($this->triggers as $trigger) {
            DB::unprepared("DROP TRIGGER IF EXISTS {$trigger}");
        }
    }
};
