import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:random_image_viewer/application/providers/providers.dart';
import 'package:random_image_viewer/core/exceptions/app_exception.dart';
import 'package:random_image_viewer/domain/entities/random_image.dart';
import 'package:random_image_viewer/features/home/providers/home_provider.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockImageRepository mockRepository;
  late ProviderContainer container;

  const testImage = RandomImage(url: 'https://images.unsplash.com/test');
  const testImage2 = RandomImage(url: 'https://images.unsplash.com/test2');

  setUp(() {
    mockRepository = MockImageRepository();
    container = ProviderContainer(
      overrides: [
        imageRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('HomeNotifier', () {
    test('initial build fetches image', () async {
      when(() => mockRepository.getRandomImage())
          .thenAnswer((_) async => testImage);

      // Read the provider to trigger build
      final future = container.read(homeProvider.future);
      final state = await future;

      expect(state.image, testImage);
      expect(state.isRefreshing, false);
      expect(state.error, isNull);
      verify(() => mockRepository.getRandomImage()).called(1);
    });

    test('fetchAnotherImage updates state with new image', () async {
      when(() => mockRepository.getRandomImage())
          .thenAnswer((_) async => testImage);

      // Wait for initial load
      await container.read(homeProvider.future);

      // Setup second fetch
      when(() => mockRepository.getRandomImage())
          .thenAnswer((_) async => testImage2);

      // Fetch another
      await container.read(homeProvider.notifier).fetchAnotherImage();

      final state = container.read(homeProvider).value!;
      expect(state.image, testImage2);
      expect(state.isRefreshing, false);
      expect(state.error, isNull);
    });

    test('fetchAnotherImage preserves current state on error', () async {
      when(() => mockRepository.getRandomImage())
          .thenAnswer((_) async => testImage);

      // Wait for initial load
      await container.read(homeProvider.future);

      // Setup error on second fetch
      when(() => mockRepository.getRandomImage())
          .thenThrow(const NetworkException('No internet connection'));

      // Fetch another
      await container.read(homeProvider.notifier).fetchAnotherImage();

      final state = container.read(homeProvider).value!;
      expect(state.image, testImage); // Original image preserved
      expect(state.isRefreshing, false);
      expect(state.error, isA<NetworkException>());
    });

    test('fetchAnotherImage wraps non-AppException as UnknownException',
        () async {
      when(() => mockRepository.getRandomImage())
          .thenAnswer((_) async => testImage);

      await container.read(homeProvider.future);

      // Throw a non-AppException error
      when(() => mockRepository.getRandomImage())
          .thenThrow(StateError('unexpected'));

      await container.read(homeProvider.notifier).fetchAnotherImage();

      final state = container.read(homeProvider).value!;
      expect(state.image, testImage);
      expect(state.isRefreshing, false);
      expect(state.error, isA<UnknownException>());
    });


  });
}
