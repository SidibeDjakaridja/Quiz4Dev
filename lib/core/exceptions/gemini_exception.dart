class AIException implements Exception {
  const AIException([this.message = 'Unknown problem']);

  final String message;

  @override
  String toString() => 'AIException: $message';
}

// Garder l'ancienne classe pour la compatibilité
class GeminiException implements Exception {
  const GeminiException([this.message = 'Unknown problem']);

  final String message;

  @override
  String toString() => 'AIException: $message';
}
