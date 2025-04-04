class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({this.message = 'Server error', this.statusCode});
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);
}

class ValidationException implements Exception {
  final String message;

  ValidationException({required this.message});
}

class CacheException implements Exception {
  final String message;

  CacheException([this.message = 'Cache operation failed']);

  @override
  String toString() => 'CacheException: $message';
}
