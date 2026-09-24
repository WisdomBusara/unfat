class WeightEntry {
  final String id;
  final String userId;
  final double weight; // kg
  final double? waistCircumference; // cm, optional
  final double? bodyFatPercentage; // optional
  final DateTime date;
  final String notes;

  WeightEntry({
    required this.id,
    required this.userId,
    required this.weight,
    this.waistCircumference,
    this.bodyFatPercentage,
    required this.date,
    this.notes = '',
  });

  factory WeightEntry.fromJson(Map<String, dynamic> json) {
    return WeightEntry(
      id: json['id'] as String,
      userId: json['user_id'] ?? '',
      weight: (json['weight'] ?? 0.0).toDouble(),
      waistCircumference: (json['waist_circumference'] as num?)?.toDouble(),
      bodyFatPercentage: (json['body_fat_percentage'] as num?)?.toDouble(),
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'weight': weight,
      'waistCircumference': waistCircumference,
      'bodyFatPercentage': bodyFatPercentage,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }
}
