import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wastesortapp/frontend/screen/home/home_screen.dart';
import 'package:wastesortapp/frontend/screen/splash_screen.dart';

void main() {
  testWidgets('Splash screen navigates to Home screen', (WidgetTester tester) async {
    // Xây dựng ứng dụng với SplashScreen
    await tester.pumpWidget(MaterialApp(
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomeScreen(), // Giả sử màn hình home có route '/home'
      },
    ));

    // Kiểm tra xem SplashScreen có hiển thị đúng tiêu đề không
    expect(find.text('Waste Sorting App'), findsOneWidget);

    // Giả sử màn hình splash có thời gian delay, ví dụ 3 giây, để chuyển sang HomeScreen
    await tester.pumpAndSettle(); // Đợi cho đến khi mọi chuyển hướng hoàn tất

    // Kiểm tra xem HomeScreen có hiển thị không (lý thuyết là 'Welcome to Waste Sorting App!' xuất hiện ở màn hình Home)
    expect(find.text('Welcome to Waste Sorting App!'), findsOneWidget);

    // Kiểm tra màn hình đã chuyển hướng sang Home Screen chưa
    expect(find.byType(HomeScreen), findsOneWidget); // HomeScreen phải xuất hiện sau khi chuyển hướng
  });
}
