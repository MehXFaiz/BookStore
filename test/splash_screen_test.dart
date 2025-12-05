import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookdukan/screens/splash_screen.dart';
import 'package:bookdukan/theme/app_theme.dart';

void main() {
  testWidgets('SplashScreen renders and animates', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );

    // Initial state: widgets should be present in tree even if 0 opacity (FadeTransition keeps child)
    // Actually, FadeTransition always builds child.
    expect(find.text('Greenbolt'), findsOneWidget);
    
    // Pump frames to advance animation and finish timer
    await tester.pump(const Duration(seconds: 4));
    // Check that we are still alive (navigation pushReplacement might strip widgets but since we mocked nothing, it tries to push LoginScreen)
    // We just want to ensure no crash.
  });
}
