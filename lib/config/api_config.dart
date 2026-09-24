class ApiConfig {
  /// Point this at your VPS in production. Override with
  /// --dart-define=API_BASE_URL=https://api.wisdombusara.com for release
  /// builds; defaults to localhost for `dart_frog dev` during development.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );
}
