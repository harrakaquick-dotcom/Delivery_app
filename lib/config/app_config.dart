import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'env/dev.dart';

/// The deployment environments the app is built for.
enum Environment {
  dev('Dev'),
  staging('Staging'),
  prod('Production');

  const Environment(this.label);

  final String label;
}

/// Per-environment settings, injected once at startup through [bootstrap].
class AppConfig {
  const AppConfig({
    required this.environment,
    required this.appName,
    required this.baseUrl,
    required this.enableLogging,
  });

  final Environment environment;

  /// Title shown in the task switcher.
  final String appName;

  /// API root. Unused while the app runs on dummy data.
  final String baseUrl;

  /// Verbose logging (network, state changes) is on outside production.
  final bool enableLogging;

  bool get isProd => environment == Environment.prod;
}

/// Active config. Defaults to dev so tests and `flutter run` work without setup.
final appConfigProvider = Provider<AppConfig>((ref) => devConfig);
