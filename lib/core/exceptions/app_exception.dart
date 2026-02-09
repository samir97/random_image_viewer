import 'package:dio/dio.dart';

sealed class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;
  const AppException(this.message, [this.stackTrace]);

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkException extends AppException {
  const NetworkException(super.message, [super.stackTrace]);
}

class ServerException extends AppException {
  final int? statusCode;
  const ServerException(
    String message, {
    this.statusCode,
    StackTrace? stackTrace,
  }) : super(message, stackTrace);
}

class UnknownException extends AppException {
  const UnknownException(super.message, [super.stackTrace]);
}

abstract final class AppExceptionHandler {
  static AppException handle(Object error, StackTrace stackTrace) {
    return switch (error) {
      DioException(type: DioExceptionType.connectionTimeout) ||
      DioException(type: DioExceptionType.sendTimeout) ||
      DioException(
        type: DioExceptionType.receiveTimeout,
      ) => NetworkException('Connection timed out', stackTrace),
      DioException(type: DioExceptionType.connectionError) => NetworkException(
        'No internet connection',
        stackTrace,
      ),
      DioException(response: final response?) => ServerException(
        response.statusMessage ?? 'Server error',
        statusCode: response.statusCode,
        stackTrace: stackTrace,
      ),
      DioException() => NetworkException('Network error occurred', stackTrace),
      FormatException() => ServerException(
        'Invalid response format',
        stackTrace: stackTrace,
      ),
      _ => UnknownException(error.toString(), stackTrace),
    };
  }
}
