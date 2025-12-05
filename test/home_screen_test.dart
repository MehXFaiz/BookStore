import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookdukan/screens/home/home_screen.dart';
import 'package:bookdukan/screens/main_screen.dart';
import 'package:bookdukan/theme/app_theme.dart';

void main() {
  testWidgets('HomeScreen renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const Scaffold(
          body: HomeScreen(isGuest: false),
        ),
      ),
    );

    // Verify that "Hello, John Den.!" text is found (assuming user is logged in)
    expect(find.text('Hello, John Den.!'), findsOneWidget);
    
    // Verify "Weekly Trending Books" header
    expect(find.text('Weekly Trending Books'), findsOneWidget);
    
    // Verify that at least one book from trending books is displayed
    // "My Book Cover" is the title of the first trending book
    expect(find.text('My Book Cover'), findsOneWidget);
  });

  testWidgets('MainScreen navigates tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const MainScreen(),
      ),
    );

    // Initial state: Home tab selected
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.text('Weekly Trending Books'), findsOneWidget);

    // Tap Search tab (BottomNavigationBar) - needing specific finder because HomeScreen has search icon too
    await tester.tap(find.descendant(
      of: find.byType(BottomNavigationBar),
      matching: find.byIcon(Icons.search),
    ));
    await tester.pump();

    // Verify Search screen content
    expect(find.text('Search Screen'), findsOneWidget);
    expect(find.text('Weekly Trending Books'), findsNothing);
  });
}
