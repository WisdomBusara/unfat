import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String email;
  final String name;
  final int age;
  final String sex; // 'male', 'female', 'other'
  final double height; // cm
  final double targetWeight; // kg
  final String activityLevel; // 'sedentary', 'light', 'moderate', 'active', 'very_active'
  final String trainingExperience; // 'beginner', 'intermediate', 'advanced'
  final List<String> goals; // ['fat_loss', 'muscle_gain', 'strength', ...]
  final List<String> preferredActivities; // ['gym', 'running', 'calisthenics', ...]
  final List<String> availableEquipment;
  final bool hasEatingDisorderHistory;
  final bool hasCardiovascularIssues;
  final String measurementUnit; // 'metric', 'imperial'
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.age,
    required this.sex,
    required this.height,
    required this.targetWeight,
    required this.activityLevel,
    required this.trainingExperience,
    required this.goals,
    required this.preferredActivities,
    required this.availableEquipment,
    this.hasEatingDisorderHistory = false,
    this.hasCardiovascularIssues = false,
    this.measurementUnit = 'metric',
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      sex: data['sex'] ?? 'other',
      height: (data['height'] ?? 0.0).toDouble(),
      targetWeight: (data['targetWeight'] ?? 0.0).toDouble(),
      activityLevel: data['activityLevel'] ?? 'moderate',
      trainingExperience: data['trainingExperience'] ?? 'beginner',
      goals: List<String>.from(data['goals'] ?? []),
      preferredActivities: List<String>.from(data['preferredActivities'] ?? []),
      availableEquipment: List<String>.from(data['availableEquipment'] ?? []),
      hasEatingDisorderHistory: data['hasEatingDisorderHistory'] ?? false,
      hasCardiovascularIssues: data['hasCardiovascularIssues'] ?? false,
      measurementUnit: data['measurementUnit'] ?? 'metric',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'age': age,
      'sex': sex,
      'height': height,
      'targetWeight': targetWeight,
      'activityLevel': activityLevel,
      'trainingExperience': trainingExperience,
      'goals': goals,
      'preferredActivities': preferredActivities,
      'availableEquipment': availableEquipment,
      'hasEatingDisorderHistory': hasEatingDisorderHistory,
      'hasCardiovascularIssues': hasCardiovascularIssues,
      'measurementUnit': measurementUnit,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserProfile copyWith({
    String? name,
    int? age,
    double? height,
    double? targetWeight,
    String? activityLevel,
    List<String>? goals,
    List<String>? preferredActivities,
  }) {
    return UserProfile(
      uid: uid,
      email: email,
      name: name ?? this.name,
      age: age ?? this.age,
      sex: sex,
      height: height ?? this.height,
      targetWeight: targetWeight ?? this.targetWeight,
      activityLevel: activityLevel ?? this.activityLevel,
      trainingExperience: trainingExperience,
      goals: goals ?? this.goals,
      preferredActivities: preferredActivities ?? this.preferredActivities,
      availableEquipment: availableEquipment,
      hasEatingDisorderHistory: hasEatingDisorderHistory,
      hasCardiovascularIssues: hasCardiovascularIssues,
      measurementUnit: measurementUnit,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
