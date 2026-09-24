import 'dart:convert';
import 'package:postgres/postgres.dart';
import '../db.dart';

class UserRepository {
  static Future<Map<String, dynamic>?> findByEmail(String email) async {
    final result = await Db.pool.execute(
      Sql.named('SELECT * FROM users WHERE email = @email'),
      parameters: {'email': email},
    );
    if (result.isEmpty) return null;
    return result.first.toColumnMap();
  }

  static Future<Map<String, dynamic>?> findById(String id) async {
    final result = await Db.pool.execute(
      Sql.named('SELECT * FROM users WHERE id = @id'),
      parameters: {'id': id},
    );
    if (result.isEmpty) return null;
    return result.first.toColumnMap();
  }

  static Future<Map<String, dynamic>> create({
    required String email,
    required String passwordHash,
    required String name,
  }) async {
    final result = await Db.pool.execute(
      Sql.named('''
        INSERT INTO users (email, password_hash, name)
        VALUES (@email, @passwordHash, @name)
        RETURNING *
      '''),
      parameters: {
        'email': email,
        'passwordHash': passwordHash,
        'name': name,
      },
    );
    return result.first.toColumnMap();
  }

  static Future<Map<String, dynamic>> update({
    required String id,
    int? age,
    String? sex,
    double? height,
    double? targetWeight,
    String? activityLevel,
    String? trainingExperience,
    List<String>? goals,
    List<String>? preferredActivities,
    List<String>? availableEquipment,
    String? measurementUnit,
  }) async {
    final result = await Db.pool.execute(
      Sql.named('''
        UPDATE users SET
          age = COALESCE(@age, age),
          sex = COALESCE(@sex, sex),
          height = COALESCE(@height, height),
          target_weight = COALESCE(@targetWeight, target_weight),
          activity_level = COALESCE(@activityLevel, activity_level),
          training_experience = COALESCE(@trainingExperience, training_experience),
          goals = COALESCE(@goals::jsonb, goals),
          preferred_activities = COALESCE(@preferredActivities::jsonb, preferred_activities),
          available_equipment = COALESCE(@availableEquipment::jsonb, available_equipment),
          measurement_unit = COALESCE(@measurementUnit, measurement_unit),
          updated_at = now()
        WHERE id = @id
        RETURNING *
      '''),
      parameters: {
        'id': id,
        'age': age,
        'sex': sex,
        'height': height,
        'targetWeight': targetWeight,
        'activityLevel': activityLevel,
        'trainingExperience': trainingExperience,
        'goals': goals != null ? jsonEncode(goals) : null,
        'preferredActivities':
            preferredActivities != null ? jsonEncode(preferredActivities) : null,
        'availableEquipment':
            availableEquipment != null ? jsonEncode(availableEquipment) : null,
        'measurementUnit': measurementUnit,
      },
    );
    return result.first.toColumnMap();
  }
}
