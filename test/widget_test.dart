import 'package:delivery/app.dart';
import 'package:delivery/features/auth/presentation/screens/login_screen.dart';
import 'package:delivery/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('splash moves on to sign-in', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: HarrakaAgentApp()));
    expect(find.byType(SplashScreen), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('send code enables after 9 digits', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    InkWell button() =>
        tester.widget(find.widgetWithText(InkWell, 'Send code →'));
    expect(button().onTap, isNull);
    await tester.enterText(find.byType(TextField), '712480991');
    await tester.pump();
    expect(button().onTap, isNotNull);
  });
}
