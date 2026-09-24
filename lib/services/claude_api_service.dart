import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/progress_photo.dart';
import '../models/workout.dart';
import '../models/nutrition.dart';
import '../models/user.dart';

class ClaudeAPIService {
  static const String _baseUrl = 'https://api.anthropic.com/v1';
  final String _apiKey;

  ClaudeAPIService(this._apiKey);

  // Analyze progress photo and provide feedback
  Future<Map<String, dynamic>> analyzeProgressPhoto(
    ProgressPhoto photo,
    UserProfile user, {
    ProgressPhoto? previousPhoto,
  }) async {
    try {
      final prompt = _buildPhotoAnalysisPrompt(photo, user, previousPhoto);
      final response = await _callClaude(prompt);

      return {
        'advice': response,
        'observations': _extractObservations(response),
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      print('Error analyzing photo: $e');
      return {
        'error': 'Failed to analyze photo',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  // Generate personalized workout recommendation
  Future<String> generateWorkoutRecommendation(
    UserProfile user,
    List<WorkoutSession> recentWorkouts,
    String goal,
  ) async {
    try {
      final prompt = _buildWorkoutRecommendationPrompt(user, recentWorkouts, goal);
      return await _callClaude(prompt);
    } catch (e) {
      print('Error generating workout recommendation: $e');
      return 'Unable to generate recommendation at this time.';
    }
  }

  // Analyze nutrition and provide advice
  Future<String> analyzeNutrition(
    DailyNutrition nutrition,
    UserProfile user,
  ) async {
    try {
      final prompt = _buildNutritionAnalysisPrompt(nutrition, user);
      return await _callClaude(prompt);
    } catch (e) {
      print('Error analyzing nutrition: $e');
      return 'Unable to analyze nutrition at this time.';
    }
  }

  // Generate weight loss strategy
  Future<String> generateWeightLossStrategy(
    UserProfile user,
    double currentWeight,
    double targetWeight,
    int daysToTarget,
  ) async {
    try {
      final prompt = _buildWeightLossStrategyPrompt(
        user,
        currentWeight,
        targetWeight,
        daysToTarget,
      );
      return await _callClaude(prompt);
    } catch (e) {
      print('Error generating weight loss strategy: $e');
      return 'Unable to generate strategy at this time.';
    }
  }

  // Call Claude API
  Future<String> _callClaude(String prompt) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/messages'),
      headers: {
        'x-api-key': _apiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'model': 'claude-3-5-sonnet-20241022',
        'max_tokens': 1024,
        'messages': [
          {
            'role': 'user',
            'content': prompt,
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['content'] as List;
      return content.first['text'] ?? 'No response';
    } else {
      throw Exception('Claude API error: ${response.statusCode} - ${response.body}');
    }
  }

  // Build prompts
  String _buildPhotoAnalysisPrompt(
    ProgressPhoto photo,
    UserProfile user,
    ProgressPhoto? previousPhoto,
  ) {
    final comparison = previousPhoto != null
        ? '\nPrevious photo was from ${previousPhoto.date}.\nCompare visible changes in body composition, posture, and muscle definition.'
        : '';

    return '''You are an evidence-based fitness coach analyzing progress photos for a user.

User Profile:
- Age: ${user.age}
- Sex: ${user.sex}
- Height: ${user.height} cm
- Goal: ${user.goals.join(', ')}
- Current stats from photo date: Weight ${photo.weight} kg

Photo Details:
- Angle: ${photo.angle}
- Date: ${photo.date}
- User notes: ${photo.notes}
$comparison

Provide:
1. Observable body composition changes (be specific about visible muscle, fat distribution)
2. Posture and form observations
3. Progress toward stated goals
4. Specific, actionable recommendations for next steps
5. Positive encouragement

Keep analysis evidence-based and realistic. Do not make medical diagnoses.''';
  }

  String _buildWorkoutRecommendationPrompt(
    UserProfile user,
    List<WorkoutSession> recentWorkouts,
    String goal,
  ) {
    final workoutSummary = recentWorkouts.isNotEmpty
        ? 'Recent workouts: ${recentWorkouts.take(3).map((w) => '${w.workoutType} (${w.durationMinutes} min)').join(', ')}'
        : 'No recent workout history';

    return '''You are an evidence-based fitness coach creating personalized workout recommendations.

User Profile:
- Experience level: ${user.trainingExperience}
- Available equipment: ${user.availableEquipment.join(', ')}
- Preferred activities: ${user.preferredActivities.join(', ')}
- Goal: $goal
- Activity level: ${user.activityLevel}

$workoutSummary

Create a specific workout recommendation for the next session that:
1. Matches the user's experience level
2. Uses only available equipment
3. Aligns with stated preferences
4. Progresses toward the goal
5. Is realistic for a single session

Include:
- Exercise selection with sets/reps/duration
- Progressive overload suggestion
- Recovery recommendations
- Modifications for different fitness levels

Base recommendations on evidence-based exercise science.''';
  }

  String _buildNutritionAnalysisPrompt(DailyNutrition nutrition, UserProfile user) {
    return '''You are a nutrition coach analyzing a user's daily intake.

User Profile:
- Goal: ${user.goals.join(', ')}
- Activity level: ${user.activityLevel}

Daily Intake Summary (${nutrition.date}):
- Calories: ${nutrition.totalCalories()} / ${nutrition.calorieTarget}
- Protein: ${nutrition.totalProtein().toStringAsFixed(1)}g / ${nutrition.proteinTarget?.toStringAsFixed(1) ?? '?'}g
- Carbs: ${nutrition.totalCarbs().toStringAsFixed(1)}g / ${nutrition.carbTarget?.toStringAsFixed(1) ?? '?'}g
- Fat: ${nutrition.totalFat().toStringAsFixed(1)}g / ${nutrition.fatTarget?.toStringAsFixed(1) ?? '?'}g

Provide:
1. Assessment of macronutrient balance
2. Observations about meal quality and variety
3. Specific, actionable improvements
4. Recommendations for next day
5. Positive feedback on what they did well

Keep recommendations practical and sustainable.''';
  }

  String _buildWeightLossStrategyPrompt(
    UserProfile user,
    double currentWeight,
    double targetWeight,
    int daysToTarget,
  ) {
    final weightToLose = currentWeight - targetWeight;
    final weeksToTarget = daysToTarget / 7;
    final weeklyRate = weightToLose / weeksToTarget;

    return '''You are an evidence-based fitness coach creating a weight loss strategy.

User Profile:
- Age: ${user.age}
- Sex: ${user.sex}
- Height: ${user.height} cm
- Experience: ${user.trainingExperience}
- Available: ${user.availableEquipment.join(', ')}

Weight Loss Target:
- Current: $currentWeight kg
- Target: $targetWeight kg
- Weight to lose: $weightToLose kg
- Timeframe: $daysToTarget days (~${weeksToTarget.toStringAsFixed(1)} weeks)
- Weekly rate: ${weeklyRate.toStringAsFixed(2)} kg/week

Create a realistic strategy covering:
1. Appropriate deficit calculation (${weeklyRate.toStringAsFixed(2)} kg/week is ${weeklyRate <= 0.5 ? 'conservative' : weeklyRate <= 1 ? 'moderate' : 'aggressive'})
2. Exercise recommendations (resistance + cardio + NEAT)
3. Nutrition approach (calorie deficit without extreme restriction)
4. Recovery priorities
5. Monitoring methods beyond scale weight
6. How to maintain after reaching target

Base recommendations on evidence. Address: ${weeklyRate > 1 ? 'This is a rapid rate - emphasize safety and muscle preservation.' : 'This is a healthy, sustainable pace.'}
Emphasize body composition over scale weight alone.''';
  }

  List<String> _extractObservations(String response) {
    // Simple extraction of numbered points
    final lines = response.split('\n');
    final observations = <String>[];

    for (final line in lines) {
      if (line.contains(RegExp(r'^\d+\.'))) {
        observations.add(line.replaceFirst(RegExp(r'^\d+\.\s*'), ''));
      }
    }

    return observations.isNotEmpty ? observations : [response.substring(0, 200)];
  }
}
