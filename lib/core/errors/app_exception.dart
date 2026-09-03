class AppException implements Exception {
  const AppException({required this.message, this.code, this.cause});

  final String message;
  final String? code;
  final Object? cause;

  @override
  String toString() {
    if (code == null || code!.isEmpty) {
      return message;
    }

    return '$code: $message';
  }
}

class NetworkException extends AppException {
  const NetworkException({required super.message, super.code, super.cause});
}

class AuthenticationException extends AppException {
  const AuthenticationException({
    required super.message,
    super.code,
    super.cause,
  });
}

class AuthorizationException extends AppException {
  const AuthorizationException({
    required super.message,
    super.code,
    super.cause,
  });
}

class ValidationException extends AppException {
  const ValidationException({required super.message, super.code, super.cause});
}
