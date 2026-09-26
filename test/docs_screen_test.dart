import 'package:delivery/app.dart';
import 'package:delivery/core/routing/route_names.dart';
import 'package:delivery/features/auth/presentation/screens/docs_screen.dart';
import 'package:delivery/features/shell/presentation/screens/main_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('verification lists documents and continues to the shell', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const ProviderScope(child: HarrakaAgentApp()));
    final nav = tester.state<NavigatorState>(find.byType(Navigator));
    nav.pushReplacementNamed(RouteNames.docs);
    await tester.pumpAndSettle();

    expect(find.byType(DocsScreen), findsOneWidget);
    expect(find.text('Good conduct certificate'), findsOneWidget);
    expect(find.text('REQUIRED'), findsOneWidget);

    await tester.tap(find.text('Continue to duty →'));
    await tester.pumpAndSettle();
    expect(find.byType(MainShell), findsOneWidget);
  });
}
