class Exercise {
  final String id;
  final String name;
  final String category; // 'resistance', 'cardio', 'calisthenics', 'mobility', 'yoga', 'combat'
  final List<String> targetMuscles;
  final String? equipment;
  final String difficulty; // 'beginner', 'intermediate', 'advanced'
  final String notes;

  Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.targetMuscles,
    this.equipment,
    this.difficulty = 'intermediate',
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'targetMuscles': targetMuscles,
      'equipment': equipment,
      'difficulty': difficulty,
      'notes': notes,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    // Two shapes land here: our own toJson() output (targetMuscles), and
    // the /exercises catalog endpoint (primary_muscles + secondary_muscles
    // as separate columns) — merge the latter into one list.
    final targetMuscles = json.containsKey('targetMuscles') || json.containsKey('target_muscles')
        ? List<String>.from(json['targetMuscles'] ?? json['target_muscles'] ?? [])
        : [
            ...List<String>.from(json['primary_muscles'] ?? []),
            ...List<String>.from(json['secondary_muscles'] ?? []),
          ];

    return Exercise(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? 'resistance',
      targetMuscles: targetMuscles,
      equipment: json['equipment'],
      difficulty: json['difficulty'] ?? 'intermediate',
      notes: json['notes'] ?? '',
    );
  }
}

class WorkoutSet {
  final int setNumber;
  final int? reps;
  final double? weight; // kg
  final int? durationSeconds;
  final String? distance; // km
  final String notes;

  WorkoutSet({
    required this.setNumber,
    this.reps,
    this.weight,
    this.durationSeconds,
    this.distance,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'setNumber': setNumber,
      'reps': reps,
      'weight': weight,
      'durationSeconds': durationSeconds,
      'distance': distance,
      'notes': notes,
    };
  }

  factory WorkoutSet.fromJson(Map<String, dynamic> json) {
    return WorkoutSet(
      setNumber: json['setNumber'] ?? json['set_number'] ?? 0,
      reps: json['reps'],
      weight: (json['weight'] as num?)?.toDouble(),
      durationSeconds: json['durationSeconds'] ?? json['duration_seconds'],
      distance: json['distance'],
      notes: json['notes'] ?? '',
    );
  }
}

class WorkoutSession {
  final String id;
  final String userId;
  final DateTime date;
  final String workoutType; // 'strength', 'cardio', 'calisthenics', 'mobility', 'combat'
  final List<Exercise> exercises;
  final List<List<WorkoutSet>> sets; // sets[i] = sets for exercises[i]
  final int durationMinutes;
  final int? caloriesBurned;
  final String? notes;
  final double? rpe; // Rate of Perceived Exertion (1-10)
  final bool completed;

  WorkoutSession({
    required this.id,
    required this.userId,
    required this.date,
    required this.workoutType,
    required this.exercises,
    required this.sets,
    required this.durationMinutes,
    this.caloriesBurned,
    this.notes,
    this.rpe,
    this.completed = true,
  });

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    final exercisesList = (json['exercises'] as List? ?? [])
        .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
        .toList();
    final setsList = (json['sets'] as List? ?? [])
        .map((setGroup) => (setGroup as List)
            .map((s) => WorkoutSet.fromJson(s as Map<String, dynamic>))
            .toList())
        .toList();

    return WorkoutSession(
      id: json['id'] as String,
      userId: json['user_id'] ?? '',
      date: DateTime.parse(json['date'] as String),
      workoutType: json['workout_type'] ?? 'strength',
      exercises: exercisesList,
      sets: setsList,
      durationMinutes: json['duration_minutes'] ?? 0,
      caloriesBurned: json['calories_burned'],
      notes: json['notes'],
      rpe: (json['rpe'] as num?)?.toDouble(),
      completed: json['completed'] ?? true,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'date': date.toIso8601String(),
      'workoutType': workoutType,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'sets': sets.map((setGroup) => setGroup.map((s) => s.toJson()).toList()).toList(),
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'notes': notes,
      'rpe': rpe,
      'completed': completed,
    };
  }
}
