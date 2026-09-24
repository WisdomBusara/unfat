import 'package:postgres/postgres.dart';
import 'env.dart';

class Db {
  static Pool? _pool;

  static Pool get pool {
    _pool ??= Pool.withEndpoints(
      [
        Endpoint(
          host: Env.dbHost,
          port: Env.dbPort,
          database: Env.dbName,
          username: Env.dbUser,
          password: Env.dbPassword,
        ),
      ],
      settings: const PoolSettings(
        maxConnectionCount: 10,
        sslMode: SslMode.disable,
      ),
    );
    return _pool!;
  }

  static Future<void> close() async {
    await _pool?.close();
    _pool = null;
  }
}
