<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use GuzzleHttp\Client;

class OpenAIController extends Controller
{
    public function sendMessage(Request $request)
    {
        $userMessage = $request->input('message');

        $client = new Client();

        $response = $client->post('https://openrouter.ai/api/v1/chat/completions', [
            'headers' => [
                'Authorization' => 'Bearer ' . env('OPENROUTER_API_KEY'),
                'Content-Type'  => 'application/json',
                'HTTP-Referer'  => 'http://127.0.0.1:8000/', // sesuai domain aplikasi kamu
            ],
            'json' => [
                'model' => 'meta-llama/llama-3-8b-instruct',
                'messages' => [
                    ['role' => 'user', 'content' => $userMessage]
                ],
            ],
        ]);

        $responseBody = json_decode($response->getBody(), true);

        return response()->json([
            'response' => $responseBody['choices'][0]['message']['content']
        ]);
    }
}

