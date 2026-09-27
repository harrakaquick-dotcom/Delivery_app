import 'package:delivery/app.dart';
import 'package:delivery/config/app_config.dart';
import 'package:delivery/config/env/dev.dart';
import 'package:delivery/config/env/prod.dart';
import 'package:delivery/config/env/staging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('each environment has its own name, url and logging', () {
    expect(devConfig.environment, Environment.dev);
    expect(stagingConfig.environment, Environment.staging);
    expect(prodConfig.environment, Environment.prod);

    final urls = {devConfig.baseUrl, stagingConfig.baseUrl, prodConfig.baseUrl};
    expect(urls.length, 3);
    expect(prodConfig.isProd, isTrue);
    expect(devConfig.isProd, isFalse);
    expect(prodConfig.enableLogging, isFalse);
  });

  testWidgets('only non-production builds show the ribbon', (tester) async {
    Future<void> pump(AppConfig config) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [appConfigProvider.overrideWithValue(config)],
          child: const HarrakaAgentApp(),
        ),
      );
    }

    await pump(stagingConfig);
    expect(find.byType(Banner), findsOneWidget);

    await pump(prodConfig);
    expect(find.byType(Banner), findsNothing);
  });
}
