import 'package:delivery/features/support/presentation/screens/support_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('chip fills the box and send adds a bubble', (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: SupportScreen(orderId: '#HRK-48213')),
    );
    expect(find.text('SUPPORT · ORDER #HRK-48213'), findsOneWidget);
    expect(find.text('What went wrong?'), findsOneWidget);

    await tester.tap(find.text('Wrong address'));
    await tester.pump();
    await tester.tap(find.text('Send'));
    await tester.pump();

    expect(find.text('Wrong address'), findsNWidgets(2));
    expect(find.text('YOU · NOW'), findsOneWidget);
  });
}
