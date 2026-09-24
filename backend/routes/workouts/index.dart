import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import '../../lib/middleware/auth_middleware.dart';
import '../../lib/repositories/workout_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  final user = context.read<AuthenticatedUser>();

  if (context.request.method == HttpMethod.get) {
    final days = int.tryParse(
          context.request.uri.queryParameters['days'] ?? '',
        ) ??
        90;
    final workouts = await WorkoutRepository.listForUser(user.id, days: days);
    return Response.json(body: workouts);
  }

  if (context.request.method == HttpMethod.post) {
    final Map<String, dynamic> body;
    try {
      body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
    } catch (_) {
      return jsonError(400, 'Invalid JSON body');
    }

    final workoutType = body['workoutType'] as String?;
    if (workoutType == null) return jsonError(400, 'workoutType is required');

    final workout = await WorkoutRepository.create(
      userId: user.id,
      date: body['date'] != null
          ? DateTime.parse(body['date'] as String)
          : DateTime.now().toUtc(),
      workoutType: workoutType,
      exercises: body['exercises'] as List? ?? [],
      sets: body['sets'] as List? ?? [],
      durationMinutes: body['durationMinutes'] as int? ?? 0,
      caloriesBurned: body['caloriesBurned'] as int?,
      notes: body['notes'] as String?,
      rpe: (body['rpe'] as num?)?.toDouble(),
      completed: body['completed'] as bool? ?? true,
    );
    return Response.json(statusCode: 201, body: workout);
  }

  return jsonError(405, 'Method not allowed');
}
