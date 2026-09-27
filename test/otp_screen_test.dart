import 'package:delivery/features/auth/presentation/screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('keypad fills boxes, backspace removes, full code calls back', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    var verified = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: OtpScreen(phone: '712480991', onVerified: () => verified++),
      ),
    );
    expect(find.text('Sent to +254 712 480 991'), findsOneWidget);

    await tester.tap(find.text('1'));
    await tester.tap(find.text('2'));
    await tester.pump();
    await tester.tap(find.text('⌫'));
    await tester.pump();
    expect(verified, 0);

    for (final d in ['2', '3', '4']) {
      await tester.tap(find.text(d));
    }
    await tester.pump();
    expect(verified, 1);
  });
}
