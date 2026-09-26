import 'package:flutter/material.dart';

import '../../features/splash/presentation/screens/splash_screen.dart';
import 'route_names.dart';

/// Central route table for `MaterialApp.onGenerateRoute`.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );
    }
  }
}
