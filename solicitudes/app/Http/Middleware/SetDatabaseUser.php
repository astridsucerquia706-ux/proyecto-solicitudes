<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SetDatabaseUser
{
    public function handle(Request $request, Closure $next)
    {
        DB::statement('SET @app_user_id = ?', [optional($request->user())->id]);

        return $next($request);
    }
}
