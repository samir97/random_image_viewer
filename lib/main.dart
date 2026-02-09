import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_image_viewer/features/home/pages/home_page.dart';
import 'package:random_image_viewer/presentation/theme/app_constants.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Random Image Viewer',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const HomePage(),
      ),
    ),
  );
}
