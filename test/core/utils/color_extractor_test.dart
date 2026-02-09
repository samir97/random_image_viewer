import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:random_image_viewer/core/utils/color_extractor.dart';

/// Helper: build RGBA pixel data for a [width]×[height] image.
/// [pixelAt] returns (r, g, b, a) for each coordinate.
Uint8List _buildPixels(
  int width,
  int height,
  (int, int, int, int) Function(int x, int y) pixelAt,
) {
  final bytes = Uint8List(width * height * 4);
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final (r, g, b, a) = pixelAt(x, y);
      final offset = (y * width + x) * 4;
      bytes[offset] = r;
      bytes[offset + 1] = g;
      bytes[offset + 2] = b;
      bytes[offset + 3] = a;
    }
  }
  return bytes;
}

int _pack(int r, int g, int b) => 0xFF000000 | (r << 16) | (g << 8) | b;

void main() {
  group('processPixelData', () {
    test('all-red image returns red for all 5 bands', () {
      final pixels = _buildPixels(10, 20, (_, _) => (255, 0, 0, 255));
      final result = processPixelData((pixels, 10, 20));

      expect(result.length, 5);
      for (final argb in result) {
        expect(argb, _pack(255, 0, 0));
      }
    });

    test('top-blue bottom-green extracts correct per-band colors', () {
      // 20 rows, 5 bands of 4 rows each
      // rows 0-9 blue, rows 10-19 green
      final pixels = _buildPixels(10, 20, (_, y) {
        if (y < 10) return (0, 0, 255, 255);
        return (0, 255, 0, 255);
      });
      final result = processPixelData((pixels, 10, 20));

      expect(result.length, 5);
      expect(result[0], _pack(0, 0, 255)); // band 0: blue
      expect(result[1], _pack(0, 0, 255)); // band 1: blue
      // band 2 is mixed — skip exact assertion
      expect(result[3], _pack(0, 255, 0)); // band 3: green
      expect(result[4], _pack(0, 255, 0)); // band 4: green
    });

    test('single pixel image works', () {
      final pixels = _buildPixels(1, 1, (_, _) => (42, 100, 200, 255));
      final result = processPixelData((pixels, 1, 1));

      expect(result.length, 5);
      expect(result[0], _pack(42, 100, 200));
    });

    test('band clamping on short image (height=2)', () {
      // height=2, bandHeight = ceil(2/5) = 1
      // row 0 → band 0, row 1 → band 1, bands 2-4 have no pixels → black
      final pixels = _buildPixels(4, 2, (_, y) {
        if (y == 0) return (255, 0, 0, 255);
        return (0, 0, 255, 255);
      });
      final result = processPixelData((pixels, 4, 2));

      expect(result.length, 5);
      expect(result[0], _pack(255, 0, 0));
      expect(result[1], _pack(0, 0, 255));
      // Bands 2-4 have no pixels, fall back to black
      expect(result[2], 0xFF000000);
      expect(result[3], 0xFF000000);
      expect(result[4], 0xFF000000);
    });
  });
}
