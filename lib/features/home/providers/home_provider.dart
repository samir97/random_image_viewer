import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers/providers.dart';
import '../../../core/exceptions/app_exception.dart';
import '../../../core/utils/color_extractor.dart';
import '../../../presentation/theme/app_constants.dart';
import '../models/home_state.dart';

final homeProvider = AsyncNotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
  retry: (_, _) => null,
);

class HomeNotifier extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() async {
    final repo = ref.read(imageRepositoryProvider);
    final image = await repo.getRandomImage();
    final colors = await _extractColors(image.url);
    return HomeState(
      image: image,
      bandColors: colors,
    );
  }

  Future<void> fetchAnotherImage() async {
    final currentState = state.value;
    if (currentState == null) return;
    state = AsyncData(currentState.copyWith(isRefreshing: true, error: null));

    try {
      final repo = ref.read(imageRepositoryProvider);
      final image = await repo.getRandomImage();
      final colors = await _extractColors(image.url);
      state = AsyncData(
        currentState.copyWith(
          image: image,
          isRefreshing: false,
          bandColors: colors,
          error: null,
        ),
      );
    } on AppException catch (e) {
      state = AsyncData(currentState.copyWith(isRefreshing: false, error: e));
    } catch (e, st) {
      state = AsyncData(
        currentState.copyWith(
          isRefreshing: false,
          error: UnknownException(e.toString(), st),
        ),
      );
    }
  }

  void clearError() {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(error: null));
  }

  Future<List<Color>> _extractColors(String url) async {
    return extractColorsFromImage(
      CachedNetworkImageProvider(url),
      defaultColors: AppColors.defaultBandColors,
    );
  }
}
