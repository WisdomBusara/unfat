import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import '../../lib/ai/claude_service.dart';
import '../../lib/middleware/auth_middleware.dart';
import '../../lib/repositories/user_repository.dart';
import '../../lib/repositories/weight_repository.dart';

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

  final daysToTarget = body['daysToTarget'] as int? ?? 90;

  final profile = await UserRepository.findById(user.id);
  if (profile == null) return jsonError(404, 'User not found');

  final latestWeight = await WeightRepository.latestForUser(user.id);
  if (latestWeight == null) {
    return jsonError(400, 'Log at least one weight entry first');
  }

  final currentWeight = latestWeight['weight'] as double;
  // Accept a per-goal target override — a user's profile-level target
  // weight (set at onboarding) and a specific Goal's target can legitimately
  // differ, and the strategy text should match whichever the caller means.
  final targetWeight =
      (body['targetWeight'] as num?)?.toDouble() ?? (profile['target_weight'] as num).toDouble();
  final weightToLose = currentWeight - targetWeight;
  final weeksToTarget = daysToTarget / 7;
  final weeklyRate = weeksToTarget > 0 ? weightToLose / weeksToTarget : 0;
  final pace = weeklyRate <= 0.5
      ? 'conservative'
      : weeklyRate <= 1
          ? 'moderate'
          : 'aggressive';

  final equipment = (profile['available_equipment'] as List?)?.join(', ') ?? 'none specified';

  final prompt = '''You are an evidence-based fitness coach creating a weight loss strategy.

User Profile:
- Age: ${profile['age']}
- Sex: ${profile['sex']}
- Height: ${profile['height']} cm
- Experience: ${profile['training_experience']}
- Available equipment: $equipment

Weight Loss Target:
- Current: $currentWeight kg
- Target: $targetWeight kg
- Weight to lose: ${weightToLose.toStringAsFixed(1)} kg
- Timeframe: $daysToTarget days (~${weeksToTarget.toStringAsFixed(1)} weeks)
- Weekly rate: ${weeklyRate.toStringAsFixed(2)} kg/week ($pace)

Create a realistic strategy covering:
1. Appropriate deficit calculation, noting this pace is $pace
2. Exercise recommendations (resistance + cardio + NEAT)
3. Nutrition approach (calorie deficit without extreme restriction)
4. Recovery priorities
5. Monitoring methods beyond scale weight
6. How to maintain after reaching target

${weeklyRate > 1 ? 'This is a rapid rate — emphasize safety and muscle preservation, and suggest extending the timeframe if the user has flexibility.' : 'This is a healthy, sustainable pace.'}
Emphasize body composition over scale weight alone.''';

  final strategy = await ClaudeService.complete(prompt, maxTokens: 1200);
  return Response.json(body: {
    'strategy': strategy,
    'weeklyRateKg': weeklyRate,
    'pace': pace,
  });
}
