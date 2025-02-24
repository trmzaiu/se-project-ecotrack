import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wastesortapp/frontend/screen/home/splash_screen.dart';

void main() {
  testWidgets('Splash screen navigates to Home screen', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SplashScreen()));

    expect(find.text('Waste Sorting App'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Welcome to Waste Sorting App!'), findsOneWidget);
  });
}
