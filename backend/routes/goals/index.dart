import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import '../../lib/middleware/auth_middleware.dart';
import '../../lib/repositories/goal_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  final user = context.read<AuthenticatedUser>();

  if (context.request.method == HttpMethod.get) {
    final goals = await GoalRepository.listActiveForUser(user.id);
    return Response.json(body: goals);
  }

  if (context.request.method == HttpMethod.post) {
    final Map<String, dynamic> body;
    try {
      body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
    } catch (_) {
      return jsonError(400, 'Invalid JSON body');
    }

    final title = body['title'] as String?;
    final goalType = body['goalType'] as String?;
    final targetDate = body['targetDate'] as String?;
    if (title == null || goalType == null || targetDate == null) {
      return jsonError(400, 'title, goalType and targetDate are required');
    }

    final goal = await GoalRepository.create(
      userId: user.id,
      title: title,
      goalType: goalType,
      targetWeight: (body['targetWeight'] as num?)?.toDouble(),
      targetReps: body['targetReps'] as int?,
      targetDistance: (body['targetDistance'] as num?)?.toDouble(),
      startDate: body['startDate'] != null
          ? DateTime.parse(body['startDate'] as String)
          : DateTime.now().toUtc(),
      targetDate: DateTime.parse(targetDate),
      priority: body['priority'] as String? ?? 'medium',
      strategies: (body['strategies'] as List?)?.cast<String>() ?? const [],
      notes: body['notes'] as String? ?? '',
    );
    return Response.json(statusCode: 201, body: goal);
  }

  return jsonError(405, 'Method not allowed');
}
