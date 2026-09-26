import 'package:flutter/material.dart';

import 'core/constants/app_strings.dart';
import 'core/routing/app_router.dart';
import 'core/routing/route_names.dart';
import 'core/theme/app_theme.dart';

/// MaterialApp root: theme injection and routing.
class HarrakaAgentApp extends StatelessWidget {
  const HarrakaAgentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
