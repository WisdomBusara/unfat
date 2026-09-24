import 'dart:convert';
import 'package:postgres/postgres.dart';
import '../db.dart';

class MealRepository {
  static Future<Map<String, dynamic>> create({
    required String userId,
    required String mealType,
    required List<dynamic> foods,
    required DateTime date,
    String notes = '',
  }) async {
    final result = await Db.pool.execute(
      Sql.named('''
        INSERT INTO meals (user_id, meal_type, foods, date, notes)
        VALUES (@userId, @mealType, @foods::jsonb, @date, @notes)
        RETURNING *
      '''),
      parameters: {
        'userId': userId,
        'mealType': mealType,
        'foods': jsonEncode(foods),
        'date': date,
        'notes': notes,
      },
    );
    return result.first.toColumnMap();
  }

  static Future<List<Map<String, dynamic>>> listForDay(
    String userId,
    DateTime day,
  ) async {
    final startOfDay = DateTime.utc(day.year, day.month, day.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final result = await Db.pool.execute(
      Sql.named('''
        SELECT * FROM meals
        WHERE user_id = @userId AND date >= @start AND date < @end
        ORDER BY date ASC
      '''),
      parameters: {'userId': userId, 'start': startOfDay, 'end': endOfDay},
    );
    return result.map((row) => row.toColumnMap()).toList();
  }
}
