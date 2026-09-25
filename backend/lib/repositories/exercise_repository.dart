import 'package:postgres/postgres.dart';
import '../db.dart';

class ExerciseRepository {
  static Future<List<Map<String, dynamic>>> search({
    String? query,
    String? category,
    int limit = 30,
  }) async {
    final result = await Db.pool.execute(
      Sql.named('''
        SELECT * FROM exercises
        WHERE (@query::text IS NULL OR name ILIKE '%' || @query || '%')
          AND (@category::text IS NULL OR category = @category)
        ORDER BY name ASC
        LIMIT @limit
      '''),
      parameters: {'query': query, 'category': category, 'limit': limit},
    );
    return result.map((row) => row.toColumnMap()).toList();
  }
}
