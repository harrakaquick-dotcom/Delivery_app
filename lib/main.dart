import 'bootstrap.dart';
import 'config/env/dev.dart';

/// Default entry point (plain `flutter run`) runs the dev environment.
/// Use `main_staging.dart` / `main_prod.dart` for the other environments.
void main() => bootstrap(devConfig);
