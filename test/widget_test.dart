import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/main.dart';

void main() {
  testWidgets('App loads and displays initial screen', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const FitnessApp());

    // Verify app title
    expect(find.text('FitFusion'), findsOneWidget);

    // Verify main sections exist
    expect(find.text('Popular Workouts'), findsOneWidget);
    expect(find.text('Workout Categories'), findsOneWidget);
    expect(find.text('Quick Workouts'), findsOneWidget);
  });

  testWidgets('Bottom navigation works', (WidgetTester tester) async {
    await tester.pumpWidget(const FitnessApp());

    // Verify home screen is first
    expect(find.text('Popular Workouts'), findsOneWidget);

    // Tap on favorites
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();
    expect(find.text('Favorites'), findsOneWidget);

    // Tap on plans
    await tester.tap(find.byIcon(Icons.calendar_today));
    await tester.pumpAndSettle();
    expect(find.text('Workout Plans'), findsOneWidget);

    // Tap on profile
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Workout cards display correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const FitnessApp());

    // Verify workout cards exist
    expect(find.byType(WorkoutCard), findsWidgets);

    // Verify first workout card has content
    expect(find.byType(WorkoutCard).first, findsOneWidget);
    expect(find.byType(Image).first, findsOneWidget);
  });

  testWidgets('Search button exists', (WidgetTester tester) async {
    await tester.pumpWidget(const FitnessApp());
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}