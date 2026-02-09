import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract final class AppColors {
  static const defaultDominant = Color(0xFF121212);
  static const defaultAccent = Color(0xFF1E1E1E);

  static const defaultDominantLight = Color(0xFFFAFAFA);
  static const defaultAccentLight = Color(0xFFF5F5F5);

  static const defaultBandColors = [
    Color(0xFF121212),
    Color(0xFF151515),
    Color(0xFF181818),
    Color(0xFF1B1B1B),
    Color(0xFF1E1E1E),
  ];

  static const defaultBandColorsLight = [
    Color(0xFFFAFAFA),
    Color(0xFFF8F8F8),
    Color(0xFFF6F6F6),
    Color(0xFFF5F5F5),
    Color(0xFFF3F3F3),
  ];
}

abstract final class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
  );
}
