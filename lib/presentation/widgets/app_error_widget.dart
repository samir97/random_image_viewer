import 'package:flutter/material.dart';

import '../../core/exceptions/app_exception.dart';

IconData iconForException(AppException exception) => switch (exception) {
  NetworkException() => Icons.wifi_off_rounded,
  ServerException() => Icons.cloud_off_rounded,
  UnknownException() => Icons.error_outline_rounded,
};

class AppErrorWidget extends StatelessWidget {
  final AppException exception;
  final VoidCallback? onRetry;

  const AppErrorWidget({super.key, required this.exception, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final icon = iconForException(exception);
    final message = exception.message;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 20),
          Text(message, style: theme.textTheme.titleMedium),
          if (onRetry != null) ...[
            const SizedBox(height: 28),
            OutlinedButton(onPressed: onRetry, child: const Text('RETRY')),
          ],
        ],
      ),
    );
  }
}
