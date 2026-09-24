import 'package:flutter/material.dart';
import '../models/weight_entry.dart';
import '../services/api_service.dart';

class WeightProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<WeightEntry> _weightHistory = [];
  bool _isLoading = false;

  List<WeightEntry> get weightHistory => _weightHistory;
  WeightEntry? get latestWeight => _weightHistory.isEmpty ? null : _weightHistory.first;
  bool get isLoading => _isLoading;

  Future<void> loadWeightHistory({int days = 90}) async {
    try {
      _isLoading = true;
      notifyListeners();

      _weightHistory = await _apiService.getWeightHistory(days: days);
      notifyListeners();
    } catch (e) {
      print('Error loading weight history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addWeightEntry(WeightEntry entry) async {
    try {
      final saved = await _apiService.addWeightEntry(entry);
      _weightHistory.insert(0, saved);
      notifyListeners();
    } catch (e) {
      print('Error adding weight entry: $e');
    }
  }

  double? getWeightChange({int days = 7}) {
    if (_weightHistory.isEmpty) return null;

    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final oldWeight = _weightHistory
        .lastWhere((w) => w.date.isBefore(cutoffDate), orElse: () => _weightHistory.last);
    final newWeight = _weightHistory.first;

    return oldWeight.weight - newWeight.weight;
  }

  double getAverageWeight({int days = 7}) {
    if (_weightHistory.isEmpty) return 0;

    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final recentWeights = _weightHistory.where((w) => w.date.isAfter(cutoffDate)).toList();

    if (recentWeights.isEmpty) return _weightHistory.first.weight;

    return recentWeights.fold(0.0, (sum, w) => sum + w.weight) / recentWeights.length;
  }
}
