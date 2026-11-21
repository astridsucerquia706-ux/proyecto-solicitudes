<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('requests', function (Blueprint $table) {
            $table->id();
            $table->foreignId('enrollment_id')->constrained('enrollments');
            $table->string('reason', 255);
            $table->string('status', 20)->default('pendiente');
            $table->foreignId('reviewer_id')->nullable()->constrained('users');
            $table->string('observation', 255)->nullable();
            $table->dateTime('created_at')->useCurrent();
            $table->dateTime('updated_at')->nullable();
            $table->dateTime('decided_at')->nullable();
        });

        DB::statement("ALTER TABLE requests ADD CONSTRAINT chk_requests_status CHECK (status IN ('pendiente','aprobada','rechazada'))");
    }

    public function down()
    {
        Schema::dropIfExists('requests');
    }
};
