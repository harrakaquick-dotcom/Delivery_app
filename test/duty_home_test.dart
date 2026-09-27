import 'package:delivery/core/providers/session_providers.dart';
import 'package:delivery/features/duty/presentation/screens/duty_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('toggle flips duty and reveals the listening card', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: DutyHomeScreen())),
      ),
    );

    expect(find.text('Good morning, Brian'), findsOneWidget);
    expect(find.text('Listening for orders'), findsNothing);

    await tester.tap(find.text('Go online'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(container.read(onlineProvider), isTrue);
    expect(find.text('Brian, you are online'), findsOneWidget);
    expect(find.text('Listening for orders'), findsOneWidget);
  });
}
