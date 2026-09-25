import 'package:dart_frog/dart_frog.dart';
import '../../lib/middleware/auth_middleware.dart';
import '../../lib/repositories/exercise_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return jsonError(405, 'Method not allowed');
  }

  final params = context.request.uri.queryParameters;
  final exercises = await ExerciseRepository.search(
    query: params['search'],
    category: params['category'],
    limit: int.tryParse(params['limit'] ?? '') ?? 30,
  );
  return Response.json(body: exercises);
}
