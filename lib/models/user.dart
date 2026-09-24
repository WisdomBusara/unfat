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

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['id'] as String,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      sex: json['sex'] ?? 'other',
      height: (json['height'] ?? 0.0).toDouble(),
      targetWeight: (json['target_weight'] ?? 0.0).toDouble(),
      activityLevel: json['activity_level'] ?? 'moderate',
      trainingExperience: json['training_experience'] ?? 'beginner',
      goals: List<String>.from(json['goals'] ?? []),
      preferredActivities: List<String>.from(json['preferred_activities'] ?? []),
      availableEquipment: List<String>.from(json['available_equipment'] ?? []),
      hasEatingDisorderHistory: json['has_eating_disorder_history'] ?? false,
      hasCardiovascularIssues: json['has_cardiovascular_issues'] ?? false,
      measurementUnit: json['measurement_unit'] ?? 'metric',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Fields accepted by `PUT /users/me` — only the ones the user can edit.
  Map<String, dynamic> toUpdateJson() {
    return {
      'age': age,
      'sex': sex,
      'height': height,
      'targetWeight': targetWeight,
      'activityLevel': activityLevel,
      'trainingExperience': trainingExperience,
      'goals': goals,
      'preferredActivities': preferredActivities,
      'availableEquipment': availableEquipment,
      'measurementUnit': measurementUnit,
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
