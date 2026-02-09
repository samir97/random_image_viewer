import 'package:flutter/material.dart';

class AnotherButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const AnotherButton({super.key, required this.isLoading, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Load another image',
      child: FilledButton(
        onPressed: isLoading ? () {} : onPressed,
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: Theme.of(context).textTheme.titleMedium,
        ),
        child: isLoading
            ? const CircularProgressIndicator.adaptive()
            : const Text('Another'),
      ),
    );
  }
}
