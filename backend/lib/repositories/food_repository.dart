import 'package:postgres/postgres.dart';
import '../db.dart';

class FoodRepository {
  static Future<List<Map<String, dynamic>>> search({
    String? query,
    String? cuisine,
    int limit = 30,
  }) async {
    final result = await Db.pool.execute(
      Sql.named('''
        SELECT * FROM foods
        WHERE (@query::text IS NULL OR name ILIKE '%' || @query || '%')
          AND (@cuisine::text IS NULL OR cuisine = @cuisine)
        ORDER BY name ASC
        LIMIT @limit
      '''),
      parameters: {'query': query, 'cuisine': cuisine, 'limit': limit},
    );
    return result.map((row) => row.toColumnMap()).toList();
  }
}
