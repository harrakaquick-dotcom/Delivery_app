import 'package:delivery/features/delivery/presentation/screens/ride_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ride shows the customer and fires arrived', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    var arrived = 0;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: RideScreen(onArrived: () => arrived++)),
      ),
    );
    expect(find.text('Wanjiru M.'), findsOneWidget);
    expect(find.text('Turn right onto Riverside Drive'), findsOneWidget);

    await tester.tap(find.text('I have arrived →'));
    expect(arrived, 1);
  });
}
