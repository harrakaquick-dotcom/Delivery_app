import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/app_config.dart';
import 'core/routing/app_router.dart';
import 'core/routing/route_names.dart';
import 'core/theme/app_theme.dart';

/// MaterialApp root: theme injection, routing and the environment ribbon.
class HarrakaAgentApp extends ConsumerWidget {
  const HarrakaAgentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    return MaterialApp(
      title: config.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
      // Non-production builds carry a corner ribbon so testers can tell them apart.
      builder: (context, child) => config.isProd
          ? child!
          : Banner(
              message: config.environment.label.toUpperCase(),
              location: BannerLocation.topEnd,
              color: config.environment == Environment.dev
                  ? const Color(0xFF157A41)
                  : const Color(0xFFF5A623),
              child: child,
            ),
    );
  }
}
