import 'package:flutter/material.dart';

import '../../features/auth/presentation/screens/docs_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/delivery/presentation/screens/collect_payment_screen.dart';
import '../../features/delivery/presentation/screens/hand_over_screen.dart';
import '../../features/delivery/presentation/screens/order_completed_screen.dart';
import '../../features/delivery/presentation/screens/order_request_screen.dart';
import '../../features/delivery/presentation/screens/ride_screen.dart';
import '../../features/delivery/presentation/screens/store_pickup_screen.dart';
import '../../features/support/presentation/screens/support_screen.dart';
import '../../features/shell/presentation/screens/main_shell.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'route_names.dart';

/// Central route table for `MaterialApp.onGenerateRoute`.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => _screenFor(settings),
    );
  }

  static Widget _screenFor(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return const LoginScreen();
      case RouteNames.otp:
        return OtpScreen(phone: settings.arguments as String? ?? '');
      case RouteNames.docs:
        return const DocsScreen();
      case RouteNames.main:
        return const MainShell();
      case RouteNames.request:
        return const OrderRequestScreen();
      case RouteNames.pickup:
        return const StorePickupScreen();
      case RouteNames.ride:
        return const RideScreen();
      case RouteNames.deliver:
        return const HandOverScreen();
      case RouteNames.cash:
        return const CollectPaymentScreen();
      case RouteNames.done:
        return const OrderCompletedScreen();
      case RouteNames.support:
        return SupportScreen(orderId: settings.arguments as String?);
      case RouteNames.splash:
      default:
        return const SplashScreen();
    }
  }
}
