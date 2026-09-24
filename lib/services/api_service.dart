import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'api_client.dart';
import 'token_storage.dart';
import '../models/user.dart';
import '../models/weight_entry.dart';
import '../models/workout.dart';
import '../models/goal.dart';
import '../models/nutrition.dart';
import '../models/progress_photo.dart';

// Re-exported so screens that only import ApiService can still catch
// ApiException without a second import.
export 'api_client.dart' show ApiException;

class ApiService {
  final Dio _dio = ApiClient().dio;

  // Auth
  Future<UserProfile> signUp(String email, String password, String name) async {
    try {
      final response = await _dio.post('/auth/signup', data: {
        'email': email,
        'password': password,
        'name': name,
      });
      return _handleAuthResponse(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<UserProfile> signIn(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return _handleAuthResponse(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> signOut() async {
    final refreshToken = await TokenStorage.refreshToken;
    try {
      await _dio.post('/auth/logout', data: {'refreshToken': refreshToken});
    } catch (_) {
      // Best-effort server-side revoke; always clear local tokens regardless.
    }
    await TokenStorage.clear();
  }

  Future<bool> hasValidSession() async {
    return await TokenStorage.accessToken != null;
  }

  UserProfile _handleAuthResponse(Map<String, dynamic> data) {
    final userJson = data['user'] as Map<String, dynamic>;
    TokenStorage.saveTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
      userId: userJson['id'] as String,
    );
    return UserProfile.fromJson(userJson);
  }

  // User Profile
  Future<UserProfile?> getUserProfile() async {
    try {
      final response = await _dio.get('/users/me');
      return UserProfile.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<UserProfile> updateUserProfile(UserProfile profile) async {
    try {
      final response = await _dio.put('/users/me', data: profile.toUpdateJson());
      return UserProfile.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // Weight
  Future<WeightEntry> addWeightEntry(WeightEntry entry) async {
    try {
      final response = await _dio.post('/weight', data: entry.toCreateJson());
      return WeightEntry.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<WeightEntry>> getWeightHistory({int days = 90}) async {
    try {
      final response = await _dio.get('/weight', queryParameters: {'days': days});
      return (response.data as List)
          .map((e) => WeightEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<WeightEntry?> getLatestWeight() async {
    final history = await getWeightHistory(days: 3650);
    return history.isEmpty ? null : history.first;
  }

  // Workouts
  Future<WorkoutSession> logWorkout(WorkoutSession workout) async {
    try {
      final response = await _dio.post('/workouts', data: workout.toCreateJson());
      return WorkoutSession.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<WorkoutSession>> getWorkoutHistory({int days = 90}) async {
    try {
      final response = await _dio.get('/workouts', queryParameters: {'days': days});
      return (response.data as List)
          .map((e) => WorkoutSession.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // Goals
  Future<Goal> createGoal(Goal goal) async {
    try {
      final response = await _dio.post('/goals', data: goal.toCreateJson());
      return Goal.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<Goal>> getActiveGoals() async {
    try {
      final response = await _dio.get('/goals');
      return (response.data as List)
          .map((e) => Goal.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Goal> completeGoal(String goalId) async {
    try {
      final response = await _dio.post('/goals/$goalId/complete');
      return Goal.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // Nutrition
  Future<MealEntry> logMeal(MealEntry meal) async {
    try {
      final response = await _dio.post('/nutrition/meals', data: meal.toCreateJson());
      return MealEntry.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<MealEntry>> getDailyMeals(DateTime date) async {
    try {
      final response = await _dio.get('/nutrition/meals', queryParameters: {
        'date': date.toIso8601String().split('T').first,
      });
      return (response.data as List)
          .map((e) => MealEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // Progress Photos — uploads as base64 JSON; the backend stores it in
  // MinIO and runs Claude vision analysis before returning.
  Future<ProgressPhoto> uploadProgressPhoto({
    required String filePath,
    required String angle,
    double? weight,
    String? notes,
  }) async {
    try {
      final bytes = await File(filePath).readAsBytes();
      final contentType = filePath.toLowerCase().endsWith('.png')
          ? 'image/png'
          : 'image/jpeg';

      final response = await _dio.post(
        '/photos/upload',
        data: {
          'imageBase64': base64Encode(bytes),
          'contentType': contentType,
          'angle': angle,
          'weight': weight,
          'notes': notes ?? '',
        },
        options: Options(sendTimeout: const Duration(seconds: 60)),
      );
      return ProgressPhoto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<ProgressPhoto>> getProgressPhotos({String? angle}) async {
    try {
      final response = await _dio.get('/photos', queryParameters: {
        if (angle != null) 'angle': angle,
      });
      return (response.data as List)
          .map((e) => ProgressPhoto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // AI coaching
  Future<String> getWorkoutRecommendation(String goal) async {
    try {
      final response = await _dio.post('/ai/workout-recommendation', data: {'goal': goal});
      return response.data['recommendation'] as String;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<String> getNutritionAnalysis() async {
    try {
      final response = await _dio.post('/ai/nutrition-analysis');
      return response.data['analysis'] as String;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<String> getWeightLossStrategy({int daysToTarget = 90}) async {
    try {
      final response = await _dio.post('/ai/weight-loss-strategy', data: {
        'daysToTarget': daysToTarget,
      });
      return response.data['strategy'] as String;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
