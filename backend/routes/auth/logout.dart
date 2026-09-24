import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import '../../lib/auth/jwt_service.dart';
import '../../lib/middleware/auth_middleware.dart';
import '../../lib/repositories/refresh_token_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return jsonError(405, 'Method not allowed');
  }

  final Map<String, dynamic> body;
  try {
    body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
  } catch (_) {
    return jsonError(400, 'Invalid JSON body');
  }

  final rawToken = body['refreshToken'] as String?;
  if (rawToken != null) {
    await RefreshTokenRepository.revoke(JwtService.hashRefreshToken(rawToken));
  }

  return Response.json(body: {'success': true});
}
