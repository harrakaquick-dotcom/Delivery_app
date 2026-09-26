import 'package:delivery/core/providers/session_providers.dart';
import 'package:delivery/features/delivery/presentation/screens/order_completed_screen.dart';
import 'package:delivery/features/shell/presentation/screens/main_shell.dart';
import 'package:delivery/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('back online returns to the shell with duty on', (tester) async {
    tester.view.physicalSize = const Size(390, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: const OrderCompletedScreen(),
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );
    expect(find.text('13 down today'), findsOneWidget);
    expect(find.text('KES 230'), findsOneWidget);

    await tester.tap(find.text('Back online →'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(container.read(onlineProvider), isTrue);
    expect(find.byType(MainShell), findsOneWidget);
  });
}
