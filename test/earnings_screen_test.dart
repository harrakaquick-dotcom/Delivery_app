import 'package:delivery/features/earnings/presentation/screens/earnings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('range tabs swap totals', (tester) async {
    tester.view.physicalSize = const Size(390, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: EarningsScreen())),
      ),
    );
    expect(find.text('KES 1,840'), findsOneWidget);

    await tester.tap(find.text('This week'));
    await tester.pump();
    expect(find.text('KES 9,420'), findsOneWidget);

    await tester.tap(find.text('Month'));
    await tester.pump();
    expect(find.text('KES 38,260'), findsOneWidget);
    expect(find.text('213 deliveries · 4 payouts'), findsOneWidget);
  });
}
