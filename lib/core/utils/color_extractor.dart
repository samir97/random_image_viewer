import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const _bandCount = 5;

/// Extracts 5 band colors from a network image (one per horizontal band).
Future<List<Color>> extractColorsFromImage(
  ImageProvider provider, {
  required List<Color> defaultColors,
}) async {
  assert(defaultColors.length == _bandCount);
  try {
    final image = await _resolveImage(provider);
    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.rawStraightRgba,
    );
    final width = image.width;
    final height = image.height;
    image.dispose();

    if (byteData == null) return defaultColors;

    final result = await compute(processPixelData, (
      byteData.buffer.asUint8List(),
      width,
      height,
    ));

    return result.map((argb) => Color(argb)).toList();
  } catch (_) {
    return defaultColors;
  }
}

/// Returns a list of 5 ARGB ints (one per band).
@visibleForTesting
List<int> processPixelData((Uint8List, int, int) args) {
  final (pixels, width, height) = args;

  final bandHeight = (height / _bandCount).ceil();
  final bandR = List.filled(_bandCount, 0);
  final bandG = List.filled(_bandCount, 0);
  final bandB = List.filled(_bandCount, 0);
  final bandCount = List.filled(_bandCount, 0);

  for (var y = 0; y < height; y++) {
    final band = (y ~/ bandHeight).clamp(0, _bandCount - 1);
    for (var x = 0; x < width; x++) {
      final offset = (y * width + x) * 4;
      if (offset + 3 >= pixels.length) continue;
      bandR[band] += pixels[offset];
      bandG[band] += pixels[offset + 1];
      bandB[band] += pixels[offset + 2];
      bandCount[band]++;
    }
  }

  int pack(int r, int g, int b) => 0xFF000000 | (r << 16) | (g << 8) | b;

  return List.generate(_bandCount, (i) {
    if (bandCount[i] == 0) return 0xFF000000;
    return pack(
      bandR[i] ~/ bandCount[i],
      bandG[i] ~/ bandCount[i],
      bandB[i] ~/ bandCount[i],
    );
  });
}

/// Resolves an [ImageProvider] to a [ui.Image] via its stream.
Future<ui.Image> _resolveImage(ImageProvider provider) {
  final completer = Completer<ui.Image>();
  final stream = provider.resolve(ImageConfiguration.empty);
  late ImageStreamListener listener;
  listener = ImageStreamListener(
    (info, _) {
      completer.complete(info.image.clone());
      stream.removeListener(listener);
    },
    onError: (error, stackTrace) {
      completer.completeError(error, stackTrace);
      stream.removeListener(listener);
    },
  );
  stream.addListener(listener);
  return completer.future;
}
