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
  final name = (body['name'] as String?)?.trim();

  if (email == null || email.isEmpty || !email.contains('@')) {
    return jsonError(400, 'A valid email is required');
  }
  if (password == null || !PasswordService.isStrongEnough(password)) {
    return jsonError(400, 'Password must be at least 8 characters');
  }
  if (name == null || name.isEmpty) {
    return jsonError(400, 'Name is required');
  }

  final existing = await UserRepository.findByEmail(email);
  if (existing != null) {
    return jsonError(409, 'An account with this email already exists');
  }

  final user = await UserRepository.create(
    email: email,
    passwordHash: PasswordService.hash(password),
    name: name,
  );

  final userId = user['id'] as String;
  final accessToken = JwtService.issueAccessToken(userId);
  final refresh = JwtService.issueRefreshToken();

  await RefreshTokenRepository.store(
    userId: userId,
    tokenHash: refresh.hash,
    expiresAt: refresh.expiresAt,
  );

  return Response.json(
    statusCode: 201,
    body: {
      'accessToken': accessToken,
      'refreshToken': refresh.raw,
      'user': _publicUser(user),
    },
  );
}

Map<String, dynamic> _publicUser(Map<String, dynamic> user) {
  final copy = Map<String, dynamic>.from(user)..remove('password_hash');
  return copy;
}
