import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:uuid/uuid.dart';
import '../env.dart';

class TokenPair {
  final String accessToken;
  final String refreshToken;
  final DateTime refreshExpiresAt;

  TokenPair({
    required this.accessToken,
    required this.refreshToken,
    required this.refreshExpiresAt,
  });
}

class JwtService {
  static const _uuid = Uuid();

  static String issueAccessToken(String userId) {
    final jwt = JWT(
      {'sub': userId, 'type': 'access'},
      issuer: 'kaza-api',
    );
    return jwt.sign(
      SecretKey(Env.jwtAccessSecret),
      expiresIn: Duration(minutes: Env.accessTokenTtlMinutes),
    );
  }

  /// Returns the raw refresh token (given to the client) plus its hash
  /// (stored in the DB) and expiry. Only the hash is persisted so a leaked
  /// DB dump can't be used to mint sessions.
  static ({String raw, String hash, DateTime expiresAt}) issueRefreshToken() {
    final raw = _uuid.v4() + _uuid.v4();
    final hash = sha256.convert(utf8.encode(raw)).toString();
    final expiresAt = DateTime.now().toUtc().add(
          Duration(days: Env.refreshTokenTtlDays),
        );
    return (raw: raw, hash: hash, expiresAt: expiresAt);
  }

  static String hashRefreshToken(String raw) {
    return sha256.convert(utf8.encode(raw)).toString();
  }

  /// Verifies an access token and returns the user id, or null if invalid/expired.
  static String? verifyAccessToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(Env.jwtAccessSecret));
      final payload = jwt.payload as Map<String, dynamic>;
      if (payload['type'] != 'access') return null;
      return payload['sub'] as String?;
    } on JWTExpiredException {
      return null;
    } on JWTException {
      return null;
    }
  }
}
