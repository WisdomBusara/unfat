import 'package:cloud_firestore/cloud_firestore.dart';

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

  Map<String, dynamic> toMap() {
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

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? 'resistance',
      targetMuscles: List<String>.from(map['targetMuscles'] ?? []),
      equipment: map['equipment'],
      difficulty: map['difficulty'] ?? 'intermediate',
      notes: map['notes'] ?? '',
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

  Map<String, dynamic> toMap() {
    return {
      'setNumber': setNumber,
      'reps': reps,
      'weight': weight,
      'durationSeconds': durationSeconds,
      'distance': distance,
      'notes': notes,
    };
  }

  factory WorkoutSet.fromMap(Map<String, dynamic> map) {
    return WorkoutSet(
      setNumber: map['setNumber'] ?? 0,
      reps: map['reps'],
      weight: map['weight']?.toDouble(),
      durationSeconds: map['durationSeconds'],
      distance: map['distance'],
      notes: map['notes'] ?? '',
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

  factory WorkoutSession.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final exercisesList = (data['exercises'] as List?)?.map((e) => Exercise.fromMap(e as Map<String, dynamic>)).toList() ?? [];
    final setsList = (data['sets'] as List?)?.map((setGroup) => (setGroup as List).map((s) => WorkoutSet.fromMap(s as Map<String, dynamic>)).toList()).toList() ?? [];

    return WorkoutSession(
      id: doc.id,
      userId: data['userId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      workoutType: data['workoutType'] ?? 'strength',
      exercises: exercisesList,
      sets: setsList,
      durationMinutes: data['durationMinutes'] ?? 0,
      caloriesBurned: data['caloriesBurned'],
      notes: data['notes'],
      rpe: data['rpe']?.toDouble(),
      completed: data['completed'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'workoutType': workoutType,
      'exercises': exercises.map((e) => e.toMap()).toList(),
      'sets': sets.map((setGroup) => setGroup.map((s) => s.toMap()).toList()).toList(),
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'notes': notes,
      'rpe': rpe,
      'completed': completed,
    };
  }
}
