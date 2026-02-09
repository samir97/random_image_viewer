import 'package:dio/dio.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/exceptions/app_exception.dart';
import '../../domain/entities/random_image.dart';
import '../../domain/repositories/image_repository.dart';

class ImageRepositoryImpl implements ImageRepository {
  final Dio _dio;

  const ImageRepositoryImpl(this._dio);

  @override
  Future<RandomImage> getRandomImage() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.randomImage,
      );
      final data = response.data;
      if (data == null) throw const FormatException('Empty response body');
      return RandomImage.fromJson(data);
    } catch (e, st) {
      throw AppExceptionHandler.handle(e, st);
    }
  }
}
