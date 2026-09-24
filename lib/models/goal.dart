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

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] as String,
      userId: json['user_id'] ?? '',
      title: json['title'] ?? '',
      goalType: json['goal_type'] ?? 'general_health',
      targetWeight: (json['target_weight'] as num?)?.toDouble(),
      targetReps: json['target_reps'],
      targetDistance: (json['target_distance'] as num?)?.toDouble(),
      startDate: DateTime.parse(json['start_date'] as String),
      targetDate: DateTime.parse(json['target_date'] as String),
      priority: json['priority'] ?? 'medium',
      strategies: List<String>.from(json['strategies'] ?? []),
      notes: json['notes'] ?? '',
      completed: json['completed'] ?? false,
      completedDate: json['completed_date'] != null
          ? DateTime.parse(json['completed_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'goalType': goalType,
      'targetWeight': targetWeight,
      'targetReps': targetReps,
      'targetDistance': targetDistance,
      'startDate': startDate.toIso8601String(),
      'targetDate': targetDate.toIso8601String(),
      'priority': priority,
      'strategies': strategies,
      'notes': notes,
    };
  }

  int progressPercentage(double currentValue, {double? startValue}) {
    if (targetWeight == null) return 0;
    startValue ??= targetWeight! * 1.1; // Assume 10% above target
    final progress = ((startValue - currentValue) / (startValue - targetWeight!)) * 100;
    return progress.clamp(0, 100).toInt();
  }
}
