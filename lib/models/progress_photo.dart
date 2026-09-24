class ProgressPhoto {
  final String id;
  final String userId;
  final String photoUrl;
  final String angle; // 'front', 'side', 'back'
  final DateTime date;
  final double? weight;
  final String notes;
  final Map<String, dynamic>? aiAnalysis;

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

  factory ProgressPhoto.fromJson(Map<String, dynamic> json) {
    return ProgressPhoto(
      id: json['id'] as String,
      userId: json['user_id'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      angle: json['angle'] ?? 'front',
      date: DateTime.parse(json['date'] as String),
      weight: (json['weight'] as num?)?.toDouble(),
      notes: json['notes'] ?? '',
      aiAnalysis: json['ai_analysis'] as Map<String, dynamic>?,
    );
  }

  String getAIAdvice() {
    if (aiAnalysis == null) return 'Analysis pending...';
    if (aiAnalysis!.containsKey('error')) return aiAnalysis!['error'] as String;
    return aiAnalysis?['advice'] ?? 'No feedback available';
  }
}
