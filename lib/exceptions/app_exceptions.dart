class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, [this.statusCode]);
}

class GenderPredictionException extends AppException {
  GenderPredictionException(String message, [int? code]) : super(message, code);
}

class NetworkException extends AppException {
  NetworkException(String message, [int? code]) : super(message, code);
}
