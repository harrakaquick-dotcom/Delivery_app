import 'package:delivery/features/delivery/presentation/screens/order_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('countdown ticks down and accept fires', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    var accepted = 0;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: OrderRequestScreen(onAccept: () => accepted++),
        ),
      ),
    );
    expect(find.text('30'), findsOneWidget);
    expect(find.text('KES 180'), findsOneWidget);
    expect(find.text('#HRK-48213'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('27'), findsOneWidget);

    await tester.tap(find.text('Accept order →'));
    expect(accepted, 1);
  });
}
