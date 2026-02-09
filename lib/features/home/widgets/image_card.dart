import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String imageUrl;
  final Color glowColor;

  const ImageCard({
    super.key,
    required this.imageUrl,
    this.glowColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Semantics(
      image: true,
      label: 'Random image',
      child: TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: glowColor.withValues(alpha: 0.4)),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
      builder: (context, glow, child) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: glow ?? Colors.transparent,
                blurRadius: 40,
                spreadRadius: 4,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        );
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 500),
            fadeInCurve: Curves.easeOut,
            placeholder: (context, url) => ColoredBox(
              color: onSurface.withValues(alpha: 0.06),
              child: const Center(
                child: CircularProgressIndicator.adaptive(strokeWidth: 2),
              ),
            ),
            errorWidget: (context, url, error) => ColoredBox(
              color: onSurface.withValues(alpha: 0.06),
              child: Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 32,
                  color: onSurface.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}
