import '../entities/random_image.dart';

abstract interface class ImageRepository {
  Future<RandomImage> getRandomImage();
}
