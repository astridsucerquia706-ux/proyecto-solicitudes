<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('prerequisites', function (Blueprint $table) {
            $table->id();
            $table->foreignId('subject_id')->constrained('subjects');
            $table->foreignId('required_subject_id')->constrained('subjects');
            $table->unique(['subject_id', 'required_subject_id']);
            $table->timestamps();
        });

        DB::statement('ALTER TABLE prerequisites ADD CONSTRAINT chk_prerequisites_distinct CHECK (subject_id <> required_subject_id)');
    }

    public function down()
    {
        Schema::dropIfExists('prerequisites');
    }
};
