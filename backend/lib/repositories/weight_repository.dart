import 'package:postgres/postgres.dart';
import '../db.dart';

class WeightRepository {
  static Future<Map<String, dynamic>> create({
    required String userId,
    required double weight,
    double? waistCircumference,
    double? bodyFatPercentage,
    required DateTime date,
    String notes = '',
  }) async {
    final result = await Db.pool.execute(
      Sql.named('''
        INSERT INTO weight_entries
          (user_id, weight, waist_circumference, body_fat_percentage, date, notes)
        VALUES
          (@userId, @weight, @waistCircumference, @bodyFatPercentage, @date, @notes)
        RETURNING *
      '''),
      parameters: {
        'userId': userId,
        'weight': weight,
        'waistCircumference': waistCircumference,
        'bodyFatPercentage': bodyFatPercentage,
        'date': date,
        'notes': notes,
      },
    );
    return result.first.toColumnMap();
  }

  static Future<List<Map<String, dynamic>>> listForUser(
    String userId, {
    int days = 90,
  }) async {
    final since = DateTime.now().toUtc().subtract(Duration(days: days));
    final result = await Db.pool.execute(
      Sql.named('''
        SELECT * FROM weight_entries
        WHERE user_id = @userId AND date >= @since
        ORDER BY date DESC
      '''),
      parameters: {'userId': userId, 'since': since},
    );
    return result.map((row) => row.toColumnMap()).toList();
  }

  static Future<Map<String, dynamic>?> latestForUser(String userId) async {
    final result = await Db.pool.execute(
      Sql.named('''
        SELECT * FROM weight_entries
        WHERE user_id = @userId
        ORDER BY date DESC LIMIT 1
      '''),
      parameters: {'userId': userId},
    );
    return result.isEmpty ? null : result.first.toColumnMap();
  }
}
