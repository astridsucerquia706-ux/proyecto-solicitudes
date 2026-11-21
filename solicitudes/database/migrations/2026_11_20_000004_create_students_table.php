<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('students', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->unique()->constrained('users');
            $table->foreignId('program_id')->constrained('programs');
            $table->string('document', 20)->unique();
            $table->string('phone', 20)->nullable();
            $table->string('address', 150)->nullable();
            $table->date('birth_date')->nullable();
            $table->string('gender', 20)->nullable();
            $table->unsignedTinyInteger('stratum')->nullable();
            $table->string('city', 60)->nullable();
            $table->timestamps();
        });

        DB::statement('ALTER TABLE students ADD CONSTRAINT chk_students_stratum CHECK (stratum BETWEEN 1 AND 6)');
    }

    public function down()
    {
        Schema::dropIfExists('students');
    }
};
