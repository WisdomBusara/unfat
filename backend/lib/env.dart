import 'dart:io';

class Env {
  static String get dbHost => _require('DB_HOST');
  static int get dbPort => int.parse(_get('DB_PORT', '5432'));
  static String get dbName => _require('DB_NAME');
  static String get dbUser => _require('DB_USER');
  static String get dbPassword => _require('DB_PASSWORD');

  static String get jwtAccessSecret => _require('JWT_ACCESS_SECRET');
  static String get jwtRefreshSecret => _require('JWT_REFRESH_SECRET');
  static int get accessTokenTtlMinutes =>
      int.parse(_get('ACCESS_TOKEN_TTL_MINUTES', '15'));
  static int get refreshTokenTtlDays =>
      int.parse(_get('REFRESH_TOKEN_TTL_DAYS', '30'));

  static String get minioEndpoint => _require('MINIO_ENDPOINT');
  static int get minioPort => int.parse(_get('MINIO_PORT', '9000'));
  static String get minioAccessKey => _require('MINIO_ACCESS_KEY');
  static String get minioSecretKey => _require('MINIO_SECRET_KEY');
  static String get minioBucket => _get('MINIO_BUCKET', 'kaza-photos');
  static bool get minioUseSsl => _get('MINIO_USE_SSL', 'true') == 'true';
  static String get minioPublicUrl => _require('MINIO_PUBLIC_URL');

  static String get claudeApiKey => _require('CLAUDE_API_KEY');

  static String _get(String key, String fallback) =>
      Platform.environment[key] ?? fallback;

  static String _require(String key) {
    final value = Platform.environment[key];
    if (value == null || value.isEmpty) {
      throw StateError('Missing required environment variable: $key');
    }
    return value;
  }
}
