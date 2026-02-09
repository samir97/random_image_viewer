import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:random_image_viewer/features/home/widgets/another_button.dart';

void main() {
  group('AnotherButton', () {
    testWidgets('shows "Another" text when not loading', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AnotherButton(isLoading: false)),
        ),
      );

      expect(find.text('Another'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows spinner when loading', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AnotherButton(isLoading: true)),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Another'), findsNothing);
    });

    testWidgets('calls onPressed when tapped (not loading)', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnotherButton(
              isLoading: false,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Another'));
      expect(pressed, isTrue);
    });

    testWidgets('does NOT call onPressed when loading', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnotherButton(
              isLoading: true,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FilledButton));
      expect(pressed, isFalse);
    });
  });
}
