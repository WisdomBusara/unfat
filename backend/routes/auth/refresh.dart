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
  if (rawToken == null || rawToken.isEmpty) {
    return jsonError(400, 'refreshToken is required');
  }

  final tokenHash = JwtService.hashRefreshToken(rawToken);
  final userId = await RefreshTokenRepository.findValidUserId(tokenHash);

  if (userId == null) {
    return jsonError(401, 'Refresh token is invalid, expired, or revoked');
  }

  // Rotate: revoke the used token, issue a new pair. Limits the damage
  // window if a refresh token is ever stolen.
  await RefreshTokenRepository.revoke(tokenHash);

  final newAccessToken = JwtService.issueAccessToken(userId);
  final newRefresh = JwtService.issueRefreshToken();

  await RefreshTokenRepository.store(
    userId: userId,
    tokenHash: newRefresh.hash,
    expiresAt: newRefresh.expiresAt,
  );

  return Response.json(
    body: {
      'accessToken': newAccessToken,
      'refreshToken': newRefresh.raw,
    },
  );
}
