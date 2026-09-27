import '../app_config.dart';

/// Staging: production-like build for QA and testers.
const AppConfig stagingConfig = AppConfig(
  environment: Environment.staging,
  appName: 'Harraka Agent Staging',
  baseUrl: 'https://staging-api.harraka.example',
  enableLogging: true,
);
