import 'package:delivery/features/delivery/presentation/screens/collect_payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('cash raises the bag balance', (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: CollectPaymentScreen())),
    );
    expect(find.text('KES 1,240'), findsOneWidget);
    expect(find.text('KES 3,610'), findsOneWidget);
    expect(
      find.text('Awaiting till confirmation'.toUpperCase()),
      findsOneWidget,
    );

    await tester.tap(find.text('Cash'));
    await tester.pump();
    expect(find.text('KES 4,850'), findsOneWidget);
  });
}
