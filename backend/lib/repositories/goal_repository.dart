import 'dart:convert';
import 'package:postgres/postgres.dart';
import '../db.dart';

class GoalRepository {
  static Future<Map<String, dynamic>> create({
    required String userId,
    required String title,
    required String goalType,
    double? targetWeight,
    int? targetReps,
    double? targetDistance,
    required DateTime startDate,
    required DateTime targetDate,
    String priority = 'medium',
    List<String> strategies = const [],
    String notes = '',
  }) async {
    final result = await Db.pool.execute(
      Sql.named('''
        INSERT INTO goals
          (user_id, title, goal_type, target_weight, target_reps, target_distance,
           start_date, target_date, priority, strategies, notes)
        VALUES
          (@userId, @title, @goalType, @targetWeight, @targetReps, @targetDistance,
           @startDate, @targetDate, @priority, @strategies::jsonb, @notes)
        RETURNING *
      '''),
      parameters: {
        'userId': userId,
        'title': title,
        'goalType': goalType,
        'targetWeight': targetWeight,
        'targetReps': targetReps,
        'targetDistance': targetDistance,
        'startDate': startDate,
        'targetDate': targetDate,
        'priority': priority,
        'strategies': jsonEncode(strategies),
        'notes': notes,
      },
    );
    return result.first.toColumnMap();
  }

  static Future<List<Map<String, dynamic>>> listActiveForUser(String userId) async {
    final result = await Db.pool.execute(
      Sql.named('''
        SELECT * FROM goals
        WHERE user_id = @userId AND completed = FALSE
        ORDER BY target_date ASC
      '''),
      parameters: {'userId': userId},
    );
    return result.map((row) => row.toColumnMap()).toList();
  }

  static Future<Map<String, dynamic>?> markCompleted(
    String userId,
    String goalId,
  ) async {
    final result = await Db.pool.execute(
      Sql.named('''
        UPDATE goals SET completed = TRUE, completed_date = now()
        WHERE id = @goalId AND user_id = @userId
        RETURNING *
      '''),
      parameters: {'goalId': goalId, 'userId': userId},
    );
    return result.isEmpty ? null : result.first.toColumnMap();
  }
}
