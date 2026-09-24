import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressPhoto {
  final String id;
  final String userId;
  final String photoUrl; // Firebase Storage path
  final String angle; // 'front', 'side', 'back'
  final DateTime date;
  final double? weight;
  final String notes;
  final Map<String, dynamic>? aiAnalysis; // Results from Claude API analysis

  ProgressPhoto({
    required this.id,
    required this.userId,
    required this.photoUrl,
    required this.angle,
    required this.date,
    this.weight,
    this.notes = '',
    this.aiAnalysis,
  });

  factory ProgressPhoto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProgressPhoto(
      id: doc.id,
      userId: data['userId'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      angle: data['angle'] ?? 'front',
      date: (data['date'] as Timestamp).toDate(),
      weight: data['weight']?.toDouble(),
      notes: data['notes'] ?? '',
      aiAnalysis: data['aiAnalysis'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'photoUrl': photoUrl,
      'angle': angle,
      'date': Timestamp.fromDate(date),
      'weight': weight,
      'notes': notes,
      'aiAnalysis': aiAnalysis,
    };
  }

  String getAIAdvice() {
    if (aiAnalysis == null) return 'Analysis pending...';
    return aiAnalysis?['advice'] ?? 'No feedback available';
  }

  String getProgressSummary() {
    if (aiAnalysis == null) return 'Analysis pending...';
    final observations = aiAnalysis?['observations'] ?? [];
    return observations.isNotEmpty ? observations.join('\n') : 'No observations yet';
  }
}
