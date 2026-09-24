import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import '../auth/jwt_service.dart';

/// Marker type so `context.read<AuthenticatedUser>()` works from any
/// protected route.
class AuthenticatedUser {
  final String id;
  AuthenticatedUser(this.id);
}

/// Requires a valid `Authorization: Bearer <token>` header. Rejects the
/// request with 401 before it reaches the route handler if missing/invalid.
Middleware requireAuth() {
  return (handler) {
    return (context) async {
      final authHeader = context.request.headers['authorization'];
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.json(
          statusCode: 401,
          body: {'error': 'Missing or malformed Authorization header'},
        );
      }

      final token = authHeader.substring('Bearer '.length);
      final userId = JwtService.verifyAccessToken(token);

      if (userId == null) {
        return Response.json(
          statusCode: 401,
          body: {'error': 'Invalid or expired access token'},
        );
      }

      return handler(
        context.provide<AuthenticatedUser>(() => AuthenticatedUser(userId)),
      );
    };
  };
}

Response jsonError(int statusCode, String message) {
  return Response(
    statusCode: statusCode,
    body: jsonEncode({'error': message}),
    headers: {'content-type': 'application/json'},
  );
}
