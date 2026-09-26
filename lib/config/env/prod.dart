import '../app_config.dart';

/// Production: the build agents install from the store.
const AppConfig prodConfig = AppConfig(
  environment: Environment.prod,
  appName: 'Harraka Agent',
  baseUrl: 'https://api.harraka.example',
  enableLogging: false,
);
