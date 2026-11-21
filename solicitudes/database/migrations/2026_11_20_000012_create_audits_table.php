<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('audits', function (Blueprint $table) {
            $table->id();
            $table->string('table_name', 50);
            $table->unsignedBigInteger('record_id');
            $table->string('action', 10);
            $table->json('old_values')->nullable();
            $table->json('new_values')->nullable();
            $table->foreignId('user_id')->nullable()->constrained('users');
            $table->dateTime('created_at')->useCurrent();
        });

        DB::statement("ALTER TABLE audits ADD CONSTRAINT chk_audits_action CHECK (action IN ('INSERT','UPDATE','DELETE'))");
    }

    public function down()
    {
        Schema::dropIfExists('audits');
    }
};
