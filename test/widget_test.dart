import 'package:delivery/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app boots to the splash screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: HarrakaAgentApp()));
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
