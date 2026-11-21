<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('subjects', function (Blueprint $table) {
            $table->id();
            $table->foreignId('program_id')->constrained('programs');
            $table->string('code', 20)->unique();
            $table->string('name', 100);
            $table->unsignedTinyInteger('credits');
            $table->unsignedTinyInteger('semester');
            $table->timestamps();
        });

        DB::statement('ALTER TABLE subjects ADD CONSTRAINT chk_subjects_credits CHECK (credits > 0)');
        DB::statement('ALTER TABLE subjects ADD CONSTRAINT chk_subjects_semester CHECK (semester BETWEEN 1 AND 10)');
    }

    public function down()
    {
        Schema::dropIfExists('subjects');
    }
};
