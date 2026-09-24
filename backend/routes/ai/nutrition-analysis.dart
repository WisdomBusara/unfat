import 'package:dart_frog/dart_frog.dart';
import '../../lib/ai/claude_service.dart';
import '../../lib/middleware/auth_middleware.dart';
import '../../lib/repositories/meal_repository.dart';
import '../../lib/repositories/user_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return jsonError(405, 'Method not allowed');
  }

  final user = context.read<AuthenticatedUser>();
  final profile = await UserRepository.findById(user.id);
  if (profile == null) return jsonError(404, 'User not found');

  final today = DateTime.now().toUtc();
  final meals = await MealRepository.listForDay(user.id, today);

  if (meals.isEmpty) {
    return jsonError(400, 'No meals logged today yet');
  }

  var totalCalories = 0.0;
  var totalProtein = 0.0;
  var totalCarbs = 0.0;
  var totalFat = 0.0;

  for (final meal in meals) {
    final foods = meal['foods'] as List? ?? [];
    for (final entry in foods) {
      final map = entry as Map<String, dynamic>;
      final food = map['food'] as Map<String, dynamic>;
      final quantity = (map['quantity'] as num?)?.toDouble() ?? 1;
      totalCalories += ((food['calories'] as num?) ?? 0) * quantity;
      totalProtein += ((food['protein'] as num?) ?? 0) * quantity;
      totalCarbs += ((food['carbs'] as num?) ?? 0) * quantity;
      totalFat += ((food['fat'] as num?) ?? 0) * quantity;
    }
  }

  final goals = (profile['goals'] as List?)?.join(', ') ?? 'general health';

  final prompt = '''You are a nutrition coach analyzing a user's daily intake.

User Goal: $goals
Activity level: ${profile['activity_level']}

Today's intake so far:
- Calories: ${totalCalories.toStringAsFixed(0)}
- Protein: ${totalProtein.toStringAsFixed(1)}g
- Carbs: ${totalCarbs.toStringAsFixed(1)}g
- Fat: ${totalFat.toStringAsFixed(1)}g

Provide:
1. Assessment of macronutrient balance for their goal
2. Observations about meal quality and variety
3. Specific, actionable improvements for the rest of the day or tomorrow
4. Positive feedback on what they did well

Keep it practical and sustainable, evidence-based, no fad claims.''';

  final analysis = await ClaudeService.complete(prompt, maxTokens: 800);
  return Response.json(body: {
    'analysis': analysis,
    'totals': {
      'calories': totalCalories,
      'protein': totalProtein,
      'carbs': totalCarbs,
      'fat': totalFat,
    },
  });
}
