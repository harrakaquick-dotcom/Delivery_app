import 'package:delivery/features/delivery/presentation/screens/store_pickup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('confirm stays inert until all four lines are ticked', (tester) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    var confirmed = 0;
    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(home: StorePickupScreen(onConfirm: () => confirmed++)),
    ));

    expect(find.text('0 / 4 checked'), findsOneWidget);
    await tester.tap(find.text('Check every line to continue'));
    expect(confirmed, 0);

    for (final n in [
      'Brookside Fresh Milk 1L',
      'Tusker Malt 500ml',
      'Sukuma wiki bunch',
      'Weetabix 700g',
    ]) {
      await tester.tap(find.text(n));
      await tester.pump();
    }
    expect(find.text('4 / 4 checked'), findsOneWidget);
    await tester.tap(find.text('Confirm pickup & start ride →'));
    expect(confirmed, 1);
  });
}
