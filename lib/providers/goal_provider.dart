import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../services/firebase_service.dart';

class GoalProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Goal> _activeGoals = [];
  bool _isLoading = false;

  List<Goal> get activeGoals => _activeGoals;
  bool get isLoading => _isLoading;

  Future<void> loadActiveGoals(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _activeGoals = await _firebaseService.getActiveGoals(userId);
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
      await _firebaseService.createGoal(goal);
      _activeGoals.add(goal);
      notifyListeners();
    } catch (e) {
      print('Error creating goal: $e');
    }
  }

  Future<void> updateGoal(Goal goal) async {
    try {
      await _firebaseService.updateGoal(goal);
      final index = _activeGoals.indexWhere((g) => g.id == goal.id);
      if (index != -1) {
        _activeGoals[index] = goal;
      }
      notifyListeners();
    } catch (e) {
      print('Error updating goal: $e');
    }
  }

  Goal? getPrimaryGoal() {
    if (_activeGoals.isEmpty) return null;
    return _activeGoals.where((g) => g.priority == 'high').firstOrNull ??
        _activeGoals.first;
  }
}
