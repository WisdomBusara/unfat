import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory WeightEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WeightEntry(
      id: doc.id,
      userId: data['userId'] ?? '',
      weight: (data['weight'] ?? 0.0).toDouble(),
      waistCircumference: data['waistCircumference']?.toDouble(),
      bodyFatPercentage: data['bodyFatPercentage']?.toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      notes: data['notes'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'weight': weight,
      'waistCircumference': waistCircumference,
      'bodyFatPercentage': bodyFatPercentage,
      'date': Timestamp.fromDate(date),
      'notes': notes,
    };
  }
}
