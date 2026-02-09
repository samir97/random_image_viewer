import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:random_image_viewer/core/exceptions/app_exception.dart';

void main() {
  group('AppExceptionHandler', () {
    test('maps connectionTimeout to NetworkException', () {
      final dioError = DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: '/'),
      );

      final result = AppExceptionHandler.handle(dioError, StackTrace.current);

      expect(result, isA<NetworkException>());
      expect(result.message, 'Connection timed out');
    });

    test('maps sendTimeout to NetworkException', () {
      final dioError = DioException(
        type: DioExceptionType.sendTimeout,
        requestOptions: RequestOptions(path: '/'),
      );

      final result = AppExceptionHandler.handle(dioError, StackTrace.current);

      expect(result, isA<NetworkException>());
    });

    test('maps receiveTimeout to NetworkException', () {
      final dioError = DioException(
        type: DioExceptionType.receiveTimeout,
        requestOptions: RequestOptions(path: '/'),
      );

      final result = AppExceptionHandler.handle(dioError, StackTrace.current);

      expect(result, isA<NetworkException>());
    });

    test('maps connectionError to NetworkException', () {
      final dioError = DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(path: '/'),
      );

      final result = AppExceptionHandler.handle(dioError, StackTrace.current);

      expect(result, isA<NetworkException>());
      expect(result.message, 'No internet connection');
    });

    test('maps DioException with response to ServerException', () {
      final dioError = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: '/'),
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 500,
          statusMessage: 'Internal Server Error',
        ),
      );

      final result = AppExceptionHandler.handle(dioError, StackTrace.current);

      expect(result, isA<ServerException>());
      expect((result as ServerException).statusCode, 500);
      expect(result.message, 'Internal Server Error');
    });

    test('maps DioException without response to NetworkException', () {
      final dioError = DioException(
        type: DioExceptionType.unknown,
        requestOptions: RequestOptions(path: '/'),
      );

      final result = AppExceptionHandler.handle(dioError, StackTrace.current);

      expect(result, isA<NetworkException>());
    });

    test('maps FormatException to ServerException', () {
      final result = AppExceptionHandler.handle(
        const FormatException('bad json'),
        StackTrace.current,
      );

      expect(result, isA<ServerException>());
      expect(result.message, 'Invalid response format');
    });

    test('maps unknown error to UnknownException', () {
      final result = AppExceptionHandler.handle(
        Exception('something else'),
        StackTrace.current,
      );

      expect(result, isA<UnknownException>());
    });
  });
}
