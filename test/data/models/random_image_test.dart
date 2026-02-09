import 'package:flutter_test/flutter_test.dart';
import 'package:random_image_viewer/domain/entities/random_image.dart';

void main() {
  group('RandomImage', () {
    const testUrl = 'https://images.unsplash.com/test-image';
    const testJson = {'url': testUrl};

    test('fromJson creates correct entity', () {
      final image = RandomImage.fromJson(testJson);

      expect(image, isA<RandomImage>());
      expect(image.url, testUrl);
    });

    test('fromJson throws on missing url field', () {
      expect(
        () => RandomImage.fromJson(const <String, dynamic>{}),
        throwsA(isA<Error>()),
      );
    });
  });
}
