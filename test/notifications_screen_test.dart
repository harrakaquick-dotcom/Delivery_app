import 'package:delivery/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('alerts show the stream', (tester) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: NotificationsScreen())),
    );
    expect(find.text('3 new'), findsOneWidget);
    expect(find.text('Peak surge in KL-02'), findsOneWidget);
    expect(find.text('Payout sent'), findsOneWidget);
  });
}
