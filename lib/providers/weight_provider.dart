import 'package:flutter/material.dart';
import '../models/weight_entry.dart';
import '../services/firebase_service.dart';

class WeightProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<WeightEntry> _weightHistory = [];
  WeightEntry? _latestWeight;
  bool _isLoading = false;

  List<WeightEntry> get weightHistory => _weightHistory;
  WeightEntry? get latestWeight => _latestWeight;
  bool get isLoading => _isLoading;

  Future<void> loadWeightHistory(String userId, {int days = 90}) async {
    try {
      _isLoading = true;
      notifyListeners();

      _weightHistory = await _firebaseService.getWeightHistory(userId, days: days);
      _latestWeight = await _firebaseService.getLatestWeight(userId);
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
      await _firebaseService.addWeightEntry(entry);
      _weightHistory.insert(0, entry);
      _latestWeight = entry;
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
