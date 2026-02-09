import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:random_image_viewer/core/constants/api_endpoints.dart';
import 'package:random_image_viewer/core/exceptions/app_exception.dart';
import 'package:random_image_viewer/data/repositories/image_repository_impl.dart';
import 'package:random_image_viewer/domain/entities/random_image.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockDio mockDio;
  late ImageRepositoryImpl repository;

  setUp(() {
    mockDio = MockDio();
    repository = ImageRepositoryImpl(mockDio);
  });

  group('ImageRepositoryImpl', () {
    const testUrl = 'https://images.unsplash.com/test-image';

    test('returns RandomImage on success', () async {
      when(() => mockDio.get<Map<String, dynamic>>(ApiEndpoints.randomImage))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ApiEndpoints.randomImage),
                data: {'url': testUrl},
                statusCode: 200,
              ));

      final result = await repository.getRandomImage();

      expect(result, isA<RandomImage>());
      expect(result.url, testUrl);
      verify(() => mockDio.get<Map<String, dynamic>>(ApiEndpoints.randomImage))
          .called(1);
    });

    test('throws AppException on connection error', () async {
      when(() => mockDio.get<Map<String, dynamic>>(ApiEndpoints.randomImage))
          .thenThrow(DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(path: '/'),
      ));

      expect(
        () => repository.getRandomImage(),
        throwsA(isA<NetworkException>()),
      );
    });

    test('translates FormatException to ServerException', () async {
      when(() => mockDio.get<Map<String, dynamic>>(ApiEndpoints.randomImage))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ApiEndpoints.randomImage),
                data: null,
                statusCode: 200,
              ));

      expect(
        () => repository.getRandomImage(),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
