import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../services/api_service.dart';

class WorkoutProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<WorkoutSession> _workoutHistory = [];
  bool _isLoading = false;

  List<WorkoutSession> get workoutHistory => _workoutHistory;
  bool get isLoading => _isLoading;

  Future<void> loadWorkoutHistory({int days = 90}) async {
    try {
      _isLoading = true;
      notifyListeners();

      _workoutHistory = await _apiService.getWorkoutHistory(days: days);
      notifyListeners();
    } catch (e) {
      print('Error loading workout history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logWorkout(WorkoutSession workout) async {
    try {
      final saved = await _apiService.logWorkout(workout);
      _workoutHistory.insert(0, saved);
      notifyListeners();
    } catch (e) {
      print('Error logging workout: $e');
    }
  }

  int getWorkoutCount({int days = 7}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return _workoutHistory.where((w) => w.date.isAfter(cutoffDate)).length;
  }

  int getTotalDurationMinutes({int days = 7}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return _workoutHistory
        .where((w) => w.date.isAfter(cutoffDate))
        .fold(0, (sum, w) => sum + w.durationMinutes);
  }
}
