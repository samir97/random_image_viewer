import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:random_image_viewer/core/exceptions/app_exception.dart';
import 'package:random_image_viewer/domain/entities/random_image.dart';
import 'package:random_image_viewer/features/home/models/home_state.dart';
import 'package:random_image_viewer/features/home/pages/home_page.dart';
import 'package:random_image_viewer/features/home/providers/home_provider.dart';
import 'package:random_image_viewer/presentation/theme/app_constants.dart';
Widget _buildApp(HomeNotifier Function() createNotifier) {
  return ProviderScope(
    overrides: [homeProvider.overrideWith(createNotifier)],
    child: MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const HomePage(),
    ),
  );
}

/// Stub notifier that immediately sets state without doing any real work.
class _DataHomeNotifier extends HomeNotifier {
  final HomeState _initialState;
  _DataHomeNotifier(this._initialState);

  @override
  Future<HomeState> build() async => _initialState;

  @override
  Future<void> fetchAnotherImage() async {}
}

/// Keeps a completer so we can control when build finishes (avoids pending timer).
class _LoadingHomeNotifier extends HomeNotifier {
  final Completer<HomeState> _completer = Completer<HomeState>();

  @override
  Future<HomeState> build() => _completer.future;

  void complete(HomeState state) => _completer.complete(state);
}

class _ErrorHomeNotifier extends HomeNotifier {
  @override
  Future<HomeState> build() async {
    throw const NetworkException('No internet connection');
  }
}

void main() {
  const testImage = RandomImage(url: 'https://example.com/image.jpg');

  group('HomePage', () {
    testWidgets('loading state renders CircularProgressIndicator', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final notifier = _LoadingHomeNotifier();

      await tester.pumpWidget(
        _buildApp(() => notifier),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete the future so no pending timers remain
      notifier.complete(const HomeState(image: testImage));
      await tester.pump();
    });

    testWidgets('error state renders error message and RETRY button', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildApp(_ErrorHomeNotifier.new),
      );
      await tester.pumpAndSettle();

      expect(find.text('No internet connection'), findsOneWidget);
      expect(find.text('RETRY'), findsOneWidget);
    });

    testWidgets('data state renders Another button', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _buildApp(
          () => _DataHomeNotifier(const HomeState(image: testImage)),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Another'), findsOneWidget);
    });
  });
}
