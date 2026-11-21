<?php

use App\Http\Controllers\Api\AcademicController;
use App\Http\Controllers\Api\ActivityController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\ReportController;
use App\Http\Controllers\Api\RequestController;
use App\Http\Controllers\Api\StudentController;
use Illuminate\Support\Facades\Route;

Route::post('/login', [AuthController::class, 'login']);

Route::middleware(['auth:sanctum', 'db.user'])->group(function () {
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);

    Route::middleware('role:estudiante')->prefix('student')->group(function () {
        Route::get('/profile', [ProfileController::class, 'show']);
        Route::put('/profile', [ProfileController::class, 'update']);

        Route::get('/history', [AcademicController::class, 'history']);
        Route::get('/pending-subjects', [AcademicController::class, 'pending']);
        Route::get('/cancelable-enrollments', [AcademicController::class, 'cancelable']);

        Route::get('/activity-types', [ActivityController::class, 'types']);
        Route::get('/activities', [ActivityController::class, 'index']);
        Route::post('/activities', [ActivityController::class, 'store']);
        Route::delete('/activities/{id}', [ActivityController::class, 'destroy']);

        Route::get('/requests', [RequestController::class, 'myIndex']);
        Route::post('/requests', [RequestController::class, 'store']);
    });

    Route::middleware('role:docente')->prefix('teacher')->group(function () {
        Route::get('/requests', [RequestController::class, 'index']);
        Route::get('/requests/{id}', [RequestController::class, 'show']);
        Route::patch('/requests/{id}/decide', [RequestController::class, 'decide']);

        Route::get('/students', [StudentController::class, 'index']);
        Route::get('/students/{id}', [StudentController::class, 'show']);

        Route::get('/periods', [ReportController::class, 'periods']);
        Route::get('/reports/requests', [ReportController::class, 'requests']);
        Route::get('/reports/averages', [ReportController::class, 'averages']);
        Route::get('/reports/activities', [ReportController::class, 'activities']);
        Route::get('/reports/export/{tipo}', [ReportController::class, 'export']);
    });
});
