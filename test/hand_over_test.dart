import 'package:delivery/features/delivery/presentation/screens/hand_over_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('continue unlocks after four digits', (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    var verified = 0;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: HandOverScreen(onVerified: () => verified++)),
      ),
    );
    expect(find.text('Enter 4 digits to continue'), findsOneWidget);

    for (final d in ['4', '2', '1', '9']) {
      await tester.tap(find.text(d));
      await tester.pump();
    }
    expect(find.text('Code verified — continue →'), findsOneWidget);
    await tester.tap(find.text('Code verified — continue →'));
    expect(verified, 1);
  });
}
