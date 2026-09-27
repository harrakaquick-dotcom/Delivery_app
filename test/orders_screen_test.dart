import 'package:delivery/features/orders/presentation/screens/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('orders lists deliveries and marks the return', (tester) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: OrdersScreen())),
    );
    expect(find.text('13 today · 0 cancelled'), findsOneWidget);
    expect(find.text('#48213 · Riverside Dr'), findsOneWidget);
    expect(find.text('RETURNED'), findsOneWidget);
    expect(find.text('DELIVERED'), findsNWidgets(5));
  });
}
