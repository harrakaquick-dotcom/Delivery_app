import 'package:delivery/core/providers/session_providers.dart';
import 'package:delivery/core/routing/app_router.dart';
import 'package:delivery/features/auth/presentation/screens/login_screen.dart';
import 'package:delivery/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('profile shows standing and signs out to login', (tester) async {
    tester.view.physicalSize = const Size(390, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(onlineProvider.notifier).state = true;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: const Scaffold(body: ProfileScreen()),
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );
    expect(find.text('Brian Otieno'), findsOneWidget);
    expect(find.text('4.9 / 5'), findsOneWidget);
    expect(find.text('Documents'), findsOneWidget);

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(container.read(onlineProvider), isFalse);
  });
}
