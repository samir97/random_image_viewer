import 'dart:ui';

import '../../../core/exceptions/app_exception.dart';
import '../../../domain/entities/random_image.dart';
import '../../../presentation/theme/app_constants.dart';

const _sentinel = Object();

class HomeState {
  final RandomImage image;
  final bool isRefreshing;
  final List<Color> bandColors;
  final AppException? error;

  const HomeState({
    required this.image,
    this.isRefreshing = false,
    this.bandColors = AppColors.defaultBandColors,
    this.error,
  });

  HomeState copyWith({
    RandomImage? image,
    bool? isRefreshing,
    List<Color>? bandColors,
    Object? error = _sentinel,
  }) {
    return HomeState(
      image: image ?? this.image,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      bandColors: bandColors ?? this.bandColors,
      error: identical(error, _sentinel) ? this.error : error as AppException?,
    );
  }
}
