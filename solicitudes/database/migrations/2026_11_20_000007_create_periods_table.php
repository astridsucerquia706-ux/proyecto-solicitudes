<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('periods', function (Blueprint $table) {
            $table->id();
            $table->string('name', 10)->unique();
            $table->date('start_date');
            $table->date('end_date');
            $table->timestamps();
        });

        DB::statement('ALTER TABLE periods ADD CONSTRAINT chk_periods_dates CHECK (end_date > start_date)');
    }

    public function down()
    {
        Schema::dropIfExists('periods');
    }
};
