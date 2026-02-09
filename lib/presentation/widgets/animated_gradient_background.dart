import 'package:flutter/material.dart';

class AnimatedGradientBackground extends StatelessWidget {
  final List<Color> bandColors;
  final Widget child;

  const AnimatedGradientBackground({
    super.key,
    required this.bandColors,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    assert(bandColors.length == 5);
    final blendTarget = Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.white;

    return TweenAnimationBuilder<List<Color>>(
      tween: _BandColorsTween(end: bandColors),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeInOut,
      builder: (context, colors, child) {
        final deepTop = Color.lerp(colors[0], blendTarget, 0.1)!;
        final deepBottom = Color.lerp(colors[4], blendTarget, 0.1)!;

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                deepTop,
                colors[0],
                colors[1],
                colors[2],
                colors[3],
                colors[4],
                deepBottom,
              ],
              stops: const [0.0, 0.1, 0.3, 0.5, 0.7, 0.9, 1.0],
            ),
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}

class _BandColorsTween extends Tween<List<Color>> {
  _BandColorsTween({required List<Color> end}) : super(end: end);

  @override
  List<Color> lerp(double t) {
    final b = begin ?? end!;
    return List.generate(
      end!.length,
      (i) => Color.lerp(b[i], end![i], t)!,
    );
  }
}
