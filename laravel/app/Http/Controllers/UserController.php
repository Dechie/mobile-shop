<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

use App\Models\User;

class UserController extends Controller
{
    //
    public function register(Request $request) {
        $request->validate([
            'name' => 'required',
            'phone'=> 'required|unique:users',
            'cardNumber' => 'required|unique:users',
            'password' => 'required',
        ]);

        $user = User::create([
            'name' => $request->name,
            'phone' => $request->phone,
            'cardNumber' => $request->cardNumber,
            'password' => Hash::make($request->password),
        ]);

        $token = $user->createToken('userToken')->plainTextToken;

        return response()->json([
            'name' => $user->name,
            'phone'=> $user->phone, 
            'cardNumber' => $user->cardNumber, 
            'token' => $token,
        ], 201);
        
    }

    public function login(Request $request) {
 
    }
}
