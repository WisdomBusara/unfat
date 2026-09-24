import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import '../../lib/middleware/auth_middleware.dart';
import '../../lib/repositories/user_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  final user = context.read<AuthenticatedUser>();

  if (context.request.method == HttpMethod.get) {
    final profile = await UserRepository.findById(user.id);
    if (profile == null) return jsonError(404, 'User not found');
    profile.remove('password_hash');
    return Response.json(body: profile);
  }

  if (context.request.method == HttpMethod.put) {
    final Map<String, dynamic> body;
    try {
      body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
    } catch (_) {
      return jsonError(400, 'Invalid JSON body');
    }

    final updated = await UserRepository.update(
      id: user.id,
      age: body['age'] as int?,
      sex: body['sex'] as String?,
      height: (body['height'] as num?)?.toDouble(),
      targetWeight: (body['targetWeight'] as num?)?.toDouble(),
      activityLevel: body['activityLevel'] as String?,
      trainingExperience: body['trainingExperience'] as String?,
      goals: (body['goals'] as List?)?.cast<String>(),
      preferredActivities: (body['preferredActivities'] as List?)?.cast<String>(),
      availableEquipment: (body['availableEquipment'] as List?)?.cast<String>(),
      measurementUnit: body['measurementUnit'] as String?,
    );
    updated.remove('password_hash');
    return Response.json(body: updated);
  }

  return jsonError(405, 'Method not allowed');
}
