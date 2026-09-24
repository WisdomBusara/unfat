import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import '../../lib/auth/jwt_service.dart';
import '../../lib/auth/password_service.dart';
import '../../lib/middleware/auth_middleware.dart';
import '../../lib/repositories/refresh_token_repository.dart';
import '../../lib/repositories/user_repository.dart';

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

  final email = (body['email'] as String?)?.trim().toLowerCase();
  final password = body['password'] as String?;

  if (email == null || password == null) {
    return jsonError(400, 'Email and password are required');
  }

  final user = await UserRepository.findByEmail(email);

  // Same error for "no such user" and "wrong password" — don't leak
  // which one it was.
  if (user == null ||
      !PasswordService.verify(password, user['password_hash'] as String)) {
    return jsonError(401, 'Invalid email or password');
  }

  final userId = user['id'] as String;
  final accessToken = JwtService.issueAccessToken(userId);
  final refresh = JwtService.issueRefreshToken();

  await RefreshTokenRepository.store(
    userId: userId,
    tokenHash: refresh.hash,
    expiresAt: refresh.expiresAt,
  );

  final publicUser = Map<String, dynamic>.from(user)..remove('password_hash');

  return Response.json(
    body: {
      'accessToken': accessToken,
      'refreshToken': refresh.raw,
      'user': publicUser,
    },
  );
}
