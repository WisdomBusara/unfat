import 'package:postgres/postgres.dart';
import '../db.dart';

class RefreshTokenRepository {
  static Future<void> store({
    required String userId,
    required String tokenHash,
    required DateTime expiresAt,
  }) async {
    await Db.pool.execute(
      Sql.named('''
        INSERT INTO refresh_tokens (user_id, token_hash, expires_at)
        VALUES (@userId, @tokenHash, @expiresAt)
      '''),
      parameters: {
        'userId': userId,
        'tokenHash': tokenHash,
        'expiresAt': expiresAt,
      },
    );
  }

  /// Returns the user_id if the token hash is valid, unrevoked and unexpired.
  static Future<String?> findValidUserId(String tokenHash) async {
    final result = await Db.pool.execute(
      Sql.named('''
        SELECT user_id FROM refresh_tokens
        WHERE token_hash = @tokenHash
          AND revoked = FALSE
          AND expires_at > now()
      '''),
      parameters: {'tokenHash': tokenHash},
    );
    if (result.isEmpty) return null;
    return result.first.toColumnMap()['user_id'] as String;
  }

  static Future<void> revoke(String tokenHash) async {
    await Db.pool.execute(
      Sql.named('UPDATE refresh_tokens SET revoked = TRUE WHERE token_hash = @tokenHash'),
      parameters: {'tokenHash': tokenHash},
    );
  }

  static Future<void> revokeAllForUser(String userId) async {
    await Db.pool.execute(
      Sql.named('UPDATE refresh_tokens SET revoked = TRUE WHERE user_id = @userId'),
      parameters: {'userId': userId},
    );
  }
}
