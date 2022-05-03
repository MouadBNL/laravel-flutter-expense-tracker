<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
            'device_name' => 'required',
        ]);
        
        $user = User::where('email', $request->email)->first();
        
        if (! $user || ! Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['The provided credentials are incorrect.'],
            ]);
        }
        
        return $user->createToken($request->device_name)->plainTextToken;
    }

    public function register(Request $request)
    {
        $request->validate([
            'email' => ['required','email','unique:users,email'],
            'password' => ['required', 'confirmed', 'min:8'],
            'name' => ['required', 'string']
        ]);

        
        $user = User::create([
            'email' => $request->email,
            'password' => bcrypt($request->password),
            'name' => $request->name
        ]);

        return $user->createToken($request->device_name)->plainTextToken;
    }

    public function logout() {
        auth()->user()->tokens()->delete();

        return response()->noContent();
    }
}
