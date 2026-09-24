import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../services/api_service.dart';

class GoalProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Goal> _activeGoals = [];
  bool _isLoading = false;

  List<Goal> get activeGoals => _activeGoals;
  bool get isLoading => _isLoading;

  Future<void> loadActiveGoals() async {
    try {
      _isLoading = true;
      notifyListeners();

      _activeGoals = await _apiService.getActiveGoals();
      notifyListeners();
    } catch (e) {
      print('Error loading goals: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createGoal(Goal goal) async {
    try {
      final saved = await _apiService.createGoal(goal);
      _activeGoals.add(saved);
      notifyListeners();
    } catch (e) {
      print('Error creating goal: $e');
    }
  }

  Future<void> completeGoal(String goalId) async {
    try {
      await _apiService.completeGoal(goalId);
      _activeGoals.removeWhere((g) => g.id == goalId);
      notifyListeners();
    } catch (e) {
      print('Error completing goal: $e');
    }
  }

  Goal? getPrimaryGoal() {
    if (_activeGoals.isEmpty) return null;
    return _activeGoals.where((g) => g.priority == 'high').firstOrNull ??
        _activeGoals.first;
  }
}
