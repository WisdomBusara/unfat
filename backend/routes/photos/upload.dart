import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import '../../lib/ai/claude_service.dart';
import '../../lib/middleware/auth_middleware.dart';
import '../../lib/repositories/photo_repository.dart';
import '../../lib/repositories/user_repository.dart';
import '../../lib/storage/minio_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return jsonError(405, 'Method not allowed');
  }

  final user = context.read<AuthenticatedUser>();

  final Map<String, dynamic> body;
  try {
    body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
  } catch (_) {
    return jsonError(400, 'Invalid JSON body');
  }

  final imageBase64 = body['imageBase64'] as String?;
  final contentType = body['contentType'] as String? ?? 'image/jpeg';
  final angle = body['angle'] as String?;

  if (imageBase64 == null) return jsonError(400, 'imageBase64 is required');
  if (angle == null || !['front', 'side', 'back'].contains(angle)) {
    return jsonError(400, 'angle must be one of: front, side, back');
  }

  final bytes = base64Decode(imageBase64);
  if (bytes.length > 10 * 1024 * 1024) {
    return jsonError(413, 'Image exceeds 10MB limit');
  }

  // 1. Upload to MinIO.
  final uploaded = await MinioService.uploadPhoto(
    userId: user.id,
    bytes: bytes,
    contentType: contentType,
  );

  // 2. Persist the photo row immediately so it's not lost if AI analysis fails.
  final weight = (body['weight'] as num?)?.toDouble();
  final date = DateTime.now().toUtc();
  var photo = await PhotoRepository.create(
    userId: user.id,
    photoUrl: uploaded.publicUrl,
    objectKey: uploaded.objectKey,
    angle: angle,
    date: date,
    weight: weight,
    notes: body['notes'] as String? ?? '',
  );

  // 3. Best-effort AI analysis — a failure here shouldn't lose the photo.
  try {
    final profile = await UserRepository.findById(user.id);
    final previous = await PhotoRepository.findMostRecentBeforeForAngle(
      user.id,
      angle,
    );

    final prompt = _buildAnalysisPrompt(
      profile: profile,
      angle: angle,
      weight: weight,
      notes: body['notes'] as String? ?? '',
      hasPreviousPhoto: previous != null,
    );

    final advice = await ClaudeService.completeWithImage(
      prompt: prompt,
      base64Image: imageBase64,
      mediaType: contentType,
    );

    final analysis = {
      'advice': advice,
      'analyzedAt': DateTime.now().toUtc().toIso8601String(),
    };

    await PhotoRepository.updateAnalysis(photo['id'] as String, analysis);
    photo = {...photo, 'ai_analysis': analysis};
  } catch (e) {
    photo = {
      ...photo,
      'ai_analysis': {'error': 'Analysis failed, will retry later'},
    };
  }

  return Response.json(statusCode: 201, body: photo);
}

String _buildAnalysisPrompt({
  required Map<String, dynamic>? profile,
  required String angle,
  required double? weight,
  required String notes,
  required bool hasPreviousPhoto,
}) {
  final goals = (profile?['goals'] as List?)?.join(', ') ?? 'general fitness';
  final experience = profile?['training_experience'] ?? 'beginner';

  return '''You are an evidence-based fitness coach reviewing a progress photo.

User goals: $goals
Training experience: $experience
Photo angle: $angle
${weight != null ? 'Weight at time of photo: $weight kg' : ''}
${notes.isNotEmpty ? 'User notes: $notes' : ''}
${hasPreviousPhoto ? 'This user has previous photos on file for comparison, though only this one is attached.' : 'This is their first photo from this angle.'}

Provide:
1. Observable body composition notes (muscle definition, posture, visible changes if any context suggests them)
2. Progress relative to their stated goal
3. 2-3 specific, actionable next steps
4. Brief encouragement

Be honest and evidence-based. Do not make medical diagnoses, do not comment on
attractiveness, and do not promise specific outcomes.''';
}
