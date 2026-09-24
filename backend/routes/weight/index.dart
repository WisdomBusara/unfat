import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import '../../lib/middleware/auth_middleware.dart';
import '../../lib/repositories/weight_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  final user = context.read<AuthenticatedUser>();

  if (context.request.method == HttpMethod.get) {
    final days = int.tryParse(
          context.request.uri.queryParameters['days'] ?? '',
        ) ??
        90;
    final entries = await WeightRepository.listForUser(user.id, days: days);
    return Response.json(body: entries);
  }

  if (context.request.method == HttpMethod.post) {
    final Map<String, dynamic> body;
    try {
      body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
    } catch (_) {
      return jsonError(400, 'Invalid JSON body');
    }

    final weight = (body['weight'] as num?)?.toDouble();
    if (weight == null) return jsonError(400, 'weight is required');

    final entry = await WeightRepository.create(
      userId: user.id,
      weight: weight,
      waistCircumference: (body['waistCircumference'] as num?)?.toDouble(),
      bodyFatPercentage: (body['bodyFatPercentage'] as num?)?.toDouble(),
      date: body['date'] != null
          ? DateTime.parse(body['date'] as String)
          : DateTime.now().toUtc(),
      notes: body['notes'] as String? ?? '',
    );
    return Response.json(statusCode: 201, body: entry);
  }

  return jsonError(405, 'Method not allowed');
}
