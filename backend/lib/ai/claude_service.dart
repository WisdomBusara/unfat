import 'dart:convert';
import 'package:http/http.dart' as http;
import '../env.dart';

/// Server-side Claude proxy. The API key lives only here, never in the
/// Flutter app — the mobile client calls our /ai/* routes instead.
class ClaudeService {
  static const _baseUrl = 'https://api.anthropic.com/v1/messages';
  static const _model = 'claude-3-5-sonnet-20241022';

  static Future<String> complete(String prompt, {int maxTokens = 1024}) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'x-api-key': Env.claudeApiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'model': _model,
        'max_tokens': maxTokens,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw ClaudeApiException(response.statusCode, response.body);
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final content = data['content'] as List;
    return (content.first as Map<String, dynamic>)['text'] as String? ?? '';
  }

  /// Same as [complete] but sends the image alongside the prompt for
  /// vision analysis (progress photo review).
  static Future<String> completeWithImage({
    required String prompt,
    required String base64Image,
    required String mediaType,
    int maxTokens = 1024,
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'x-api-key': Env.claudeApiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'model': _model,
        'max_tokens': maxTokens,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'image',
                'source': {
                  'type': 'base64',
                  'media_type': mediaType,
                  'data': base64Image,
                },
              },
              {'type': 'text', 'text': prompt},
            ],
          },
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw ClaudeApiException(response.statusCode, response.body);
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final content = data['content'] as List;
    return (content.first as Map<String, dynamic>)['text'] as String? ?? '';
  }
}

class ClaudeApiException implements Exception {
  final int statusCode;
  final String body;
  ClaudeApiException(this.statusCode, this.body);

  @override
  String toString() => 'ClaudeApiException($statusCode): $body';
}
