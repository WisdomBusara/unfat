import 'package:dart_frog/dart_frog.dart';
import '../../lib/middleware/auth_middleware.dart';
import '../../lib/repositories/photo_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return jsonError(405, 'Method not allowed');
  }

  final user = context.read<AuthenticatedUser>();
  final angle = context.request.uri.queryParameters['angle'];
  final photos = await PhotoRepository.listForUser(user.id, angle: angle);
  return Response.json(body: photos);
}
