import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import '../../lib/ai/claude_service.dart';
import '../../lib/middleware/auth_middleware.dart';
import '../../lib/repositories/user_repository.dart';
import '../../lib/repositories/workout_repository.dart';

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

  final goal = body['goal'] as String? ?? 'general fitness';

  final profile = await UserRepository.findById(user.id);
  if (profile == null) return jsonError(404, 'User not found');

  final recentWorkouts = await WorkoutRepository.listForUser(user.id, days: 14);
  final workoutSummary = recentWorkouts.isEmpty
      ? 'No recent workout history'
      : 'Recent workouts: ${recentWorkouts.take(3).map((w) => '${w['workout_type']} (${w['duration_minutes']} min)').join(', ')}';

  final equipment = (profile['available_equipment'] as List?)?.join(', ') ?? 'none specified';
  final preferences = (profile['preferred_activities'] as List?)?.join(', ') ?? 'none specified';

  final prompt = '''You are an evidence-based fitness coach creating a personalized workout recommendation.

User Profile:
- Experience level: ${profile['training_experience']}
- Available equipment: $equipment
- Preferred activities: $preferences
- Goal: $goal
- Activity level: ${profile['activity_level']}

$workoutSummary

Create a specific workout recommendation for the next session that:
1. Matches the user's experience level
2. Uses only available equipment
3. Aligns with stated preferences
4. Progresses toward the goal
5. Is realistic for a single session

Include exercise selection with sets/reps/duration, a progressive overload
suggestion, recovery recommendations, and modifications for different
fitness levels. Base this on evidence-based exercise science.''';

  final recommendation = await ClaudeService.complete(prompt, maxTokens: 1024);
  return Response.json(body: {'recommendation': recommendation});
}
