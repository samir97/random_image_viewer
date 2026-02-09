import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/exceptions/app_exception.dart';
import '../../../presentation/theme/app_constants.dart';
import '../../../presentation/widgets/animated_gradient_background.dart';
import '../../../presentation/widgets/app_error_widget.dart';
import '../providers/home_provider.dart';
import '../widgets/another_button.dart';
import '../widgets/image_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(homeProvider, (prev, next) {
      final error = next.value?.error;
      if (error == null) return;
      if (prev?.value?.error == error) return;

      final colorScheme = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  iconForException(error),
                  color: colorScheme.onError,
                  size: 18,
                ),
                const SizedBox(width: 14),
                Text(error.message),
              ],
            ),
            backgroundColor: colorScheme.error,
          ),
        );
      ref.read(homeProvider.notifier).clearError();
    });

    final homeState = ref.watch(homeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBandColors = isDark
        ? AppColors.defaultBandColors
        : AppColors.defaultBandColorsLight;
    return AnimatedGradientBackground(
      bandColors: homeState.value?.bandColors ?? defaultBandColors,
      child: Scaffold(
        body: homeState.when(
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          error: (error, _) => AppErrorWidget(
            exception: error is AppException
                ? error
                : UnknownException(error.toString()),
            onRetry: () => ref.invalidate(homeProvider),
          ),
          data: (data) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    child: ImageCard(
                      key: ValueKey(data.image.url),
                      imageUrl: data.image.url,
                      glowColor: data.bandColors[4],
                    ),
                  ),
                  const SizedBox(height: 40),
                  AnotherButton(
                    isLoading: data.isRefreshing,
                    onPressed: () =>
                        ref.read(homeProvider.notifier).fetchAnotherImage(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
