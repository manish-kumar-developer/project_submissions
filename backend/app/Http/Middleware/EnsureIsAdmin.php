<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureIsAdmin
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();
        
        if (!$user) {
            return response()->json([
                'status' => 'error',
                'message' => 'Unauthenticated'
            ], 401);
        }

        if ($user->role !== 'admin') {
            return response()->json([
                'status' => 'error',
                'message' => 'Insufficient privileges. Admin access required.'
            ], 403);
        }

        return $next($request);
    }
}