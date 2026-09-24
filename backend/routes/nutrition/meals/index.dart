import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import '../../../lib/middleware/auth_middleware.dart';
import '../../../lib/repositories/meal_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  final user = context.read<AuthenticatedUser>();

  if (context.request.method == HttpMethod.get) {
    final dateParam = context.request.uri.queryParameters['date'];
    final day = dateParam != null ? DateTime.parse(dateParam) : DateTime.now();
    final meals = await MealRepository.listForDay(user.id, day);
    return Response.json(body: meals);
  }

  if (context.request.method == HttpMethod.post) {
    final Map<String, dynamic> body;
    try {
      body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
    } catch (_) {
      return jsonError(400, 'Invalid JSON body');
    }

    final mealType = body['mealType'] as String?;
    if (mealType == null) return jsonError(400, 'mealType is required');

    final meal = await MealRepository.create(
      userId: user.id,
      mealType: mealType,
      foods: body['foods'] as List? ?? [],
      date: body['date'] != null
          ? DateTime.parse(body['date'] as String)
          : DateTime.now().toUtc(),
      notes: body['notes'] as String? ?? '',
    );
    return Response.json(statusCode: 201, body: meal);
  }

  return jsonError(405, 'Method not allowed');
}
