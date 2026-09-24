import 'package:dart_frog/dart_frog.dart';
import '../../../lib/middleware/auth_middleware.dart';
import '../../../lib/repositories/goal_repository.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.post) {
    return jsonError(405, 'Method not allowed');
  }

  final user = context.read<AuthenticatedUser>();
  final goal = await GoalRepository.markCompleted(user.id, id);

  if (goal == null) return jsonError(404, 'Goal not found');
  return Response.json(body: goal);
}
