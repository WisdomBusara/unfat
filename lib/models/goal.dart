import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final String id;
  final String userId;
  final String title;
  final String goalType; // 'fat_loss', 'muscle_gain', 'strength', 'cardio', 'general_health'
  final double? targetWeight;
  final int? targetReps;
  final double? targetDistance;
  final DateTime startDate;
  final DateTime targetDate;
  final String priority; // 'high', 'medium', 'low'
  final List<String> strategies; // ['resistance_training', 'cardio', 'nutrition', 'sleep', ...]
  final String notes;
  final bool completed;
  final DateTime? completedDate;

  Goal({
    required this.id,
    required this.userId,
    required this.title,
    required this.goalType,
    this.targetWeight,
    this.targetReps,
    this.targetDistance,
    required this.startDate,
    required this.targetDate,
    this.priority = 'medium',
    this.strategies = const [],
    this.notes = '',
    this.completed = false,
    this.completedDate,
  });

  factory Goal.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Goal(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      goalType: data['goalType'] ?? 'general_health',
      targetWeight: data['targetWeight']?.toDouble(),
      targetReps: data['targetReps'],
      targetDistance: data['targetDistance']?.toDouble(),
      startDate: (data['startDate'] as Timestamp).toDate(),
      targetDate: (data['targetDate'] as Timestamp).toDate(),
      priority: data['priority'] ?? 'medium',
      strategies: List<String>.from(data['strategies'] ?? []),
      notes: data['notes'] ?? '',
      completed: data['completed'] ?? false,
      completedDate: data['completedDate'] != null ? (data['completedDate'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'goalType': goalType,
      'targetWeight': targetWeight,
      'targetReps': targetReps,
      'targetDistance': targetDistance,
      'startDate': Timestamp.fromDate(startDate),
      'targetDate': Timestamp.fromDate(targetDate),
      'priority': priority,
      'strategies': strategies,
      'notes': notes,
      'completed': completed,
      'completedDate': completedDate != null ? Timestamp.fromDate(completedDate!) : null,
    };
  }

  int progressPercentage(double currentValue, {double? startValue}) {
    if (targetWeight == null) return 0;
    startValue ??= targetWeight! * 1.1; // Assume 10% above target
    final progress = ((startValue - currentValue) / (startValue - targetWeight!)) * 100;
    return progress.clamp(0, 100).toInt();
  }
}
