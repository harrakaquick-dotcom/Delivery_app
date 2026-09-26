import '../app_config.dart';

/// Development: local work and demo builds.
const AppConfig devConfig = AppConfig(
  environment: Environment.dev,
  appName: 'Harraka Agent Dev',
  baseUrl: 'https://dev-api.harraka.example',
  enableLogging: true,
);
