import 'dart:convert';
import 'package:postgres/postgres.dart';
import '../db.dart';

class WorkoutRepository {
  static Future<Map<String, dynamic>> create({
    required String userId,
    required DateTime date,
    required String workoutType,
    required List<dynamic> exercises,
    required List<dynamic> sets,
    int durationMinutes = 0,
    int? caloriesBurned,
    String? notes,
    double? rpe,
    bool completed = true,
  }) async {
    final result = await Db.pool.execute(
      Sql.named('''
        INSERT INTO workout_sessions
          (user_id, date, workout_type, exercises, sets, duration_minutes,
           calories_burned, notes, rpe, completed)
        VALUES
          (@userId, @date, @workoutType, @exercises::jsonb, @sets::jsonb,
           @durationMinutes, @caloriesBurned, @notes, @rpe, @completed)
        RETURNING *
      '''),
      parameters: {
        'userId': userId,
        'date': date,
        'workoutType': workoutType,
        'exercises': jsonEncode(exercises),
        'sets': jsonEncode(sets),
        'durationMinutes': durationMinutes,
        'caloriesBurned': caloriesBurned,
        'notes': notes,
        'rpe': rpe,
        'completed': completed,
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
        SELECT * FROM workout_sessions
        WHERE user_id = @userId AND date >= @since
        ORDER BY date DESC
      '''),
      parameters: {'userId': userId, 'since': since},
    );
    return result.map((row) => row.toColumnMap()).toList();
  }
}
