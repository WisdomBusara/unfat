import 'package:flutter/material.dart';
import '../models/nutrition.dart';
import '../services/api_service.dart';

class NutritionProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  Map<DateTime, DailyNutrition> _nutritionHistory = {};
  bool _isLoading = false;

  Map<DateTime, DailyNutrition> get nutritionHistory => _nutritionHistory;
  bool get isLoading => _isLoading;

  Future<void> loadDailyNutrition(DateTime date) async {
    try {
      _isLoading = true;
      notifyListeners();

      final meals = await _apiService.getDailyMeals(date);
      final dateKey = DateTime(date.year, date.month, date.day);
      _nutritionHistory[dateKey] = DailyNutrition(date: dateKey, meals: meals);
      notifyListeners();
    } catch (e) {
      print('Error loading daily nutrition: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logMeal(MealEntry meal) async {
    try {
      final saved = await _apiService.logMeal(meal);
      final dateKey = DateTime(saved.date.year, saved.date.month, saved.date.day);

      if (_nutritionHistory.containsKey(dateKey)) {
        _nutritionHistory[dateKey]!.meals.add(saved);
      } else {
        _nutritionHistory[dateKey] = DailyNutrition(date: dateKey, meals: [saved]);
      }
      notifyListeners();
    } catch (e) {
      print('Error logging meal: $e');
    }
  }

  DailyNutrition getTodayNutrition() {
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return _nutritionHistory[today] ?? DailyNutrition(date: today, meals: []);
  }
}
