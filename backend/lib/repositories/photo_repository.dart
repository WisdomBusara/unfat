import 'dart:convert';
import 'package:postgres/postgres.dart';
import '../db.dart';

class PhotoRepository {
  static Future<Map<String, dynamic>> create({
    required String userId,
    required String photoUrl,
    required String objectKey,
    required String angle,
    required DateTime date,
    double? weight,
    String notes = '',
  }) async {
    final result = await Db.pool.execute(
      Sql.named('''
        INSERT INTO progress_photos
          (user_id, photo_url, object_key, angle, date, weight, notes)
        VALUES
          (@userId, @photoUrl, @objectKey, @angle, @date, @weight, @notes)
        RETURNING *
      '''),
      parameters: {
        'userId': userId,
        'photoUrl': photoUrl,
        'objectKey': objectKey,
        'angle': angle,
        'date': date,
        'weight': weight,
        'notes': notes,
      },
    );
    return result.first.toColumnMap();
  }

  static Future<List<Map<String, dynamic>>> listForUser(
    String userId, {
    String? angle,
  }) async {
    final result = await Db.pool.execute(
      Sql.named('''
        SELECT * FROM progress_photos
        WHERE user_id = @userId
          AND (@angle::text IS NULL OR angle = @angle)
        ORDER BY date DESC
      '''),
      parameters: {'userId': userId, 'angle': angle},
    );
    return result.map((row) => row.toColumnMap()).toList();
  }

  static Future<Map<String, dynamic>?> findMostRecentBeforeForAngle(
    String userId,
    String angle,
  ) async {
    final result = await Db.pool.execute(
      Sql.named('''
        SELECT * FROM progress_photos
        WHERE user_id = @userId AND angle = @angle
        ORDER BY date DESC LIMIT 1
      '''),
      parameters: {'userId': userId, 'angle': angle},
    );
    return result.isEmpty ? null : result.first.toColumnMap();
  }

  static Future<void> updateAnalysis(
    String photoId,
    Map<String, dynamic> analysis,
  ) async {
    await Db.pool.execute(
      Sql.named('''
        UPDATE progress_photos SET ai_analysis = @analysis::jsonb
        WHERE id = @id
      '''),
      parameters: {'id': photoId, 'analysis': jsonEncode(analysis)},
    );
  }
}
