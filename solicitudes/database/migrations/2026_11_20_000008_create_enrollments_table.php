<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('enrollments', function (Blueprint $table) {
            $table->id();
            $table->foreignId('student_id')->constrained('students');
            $table->foreignId('subject_id')->constrained('subjects');
            $table->foreignId('period_id')->constrained('periods');
            $table->decimal('grade', 2, 1)->nullable();
            $table->string('status', 20)->default('en_curso');
            $table->unique(['student_id', 'subject_id', 'period_id']);
            $table->timestamps();
        });

        DB::statement('ALTER TABLE enrollments ADD CONSTRAINT chk_enrollments_grade CHECK (grade BETWEEN 0.0 AND 5.0)');
        DB::statement("ALTER TABLE enrollments ADD CONSTRAINT chk_enrollments_status CHECK (status IN ('en_curso','aprobada','reprobada','cancelada'))");
    }

    public function down()
    {
        Schema::dropIfExists('enrollments');
    }
};
