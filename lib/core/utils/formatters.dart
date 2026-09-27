import 'package:intl/intl.dart';

/// Currency, distance and other display formatters.
class Formatters {
  Formatters._();

  static final NumberFormat _grouped = NumberFormat.decimalPattern('en');

  /// `1240` -> `KES 1,240`.
  static String kes(num amount) => 'KES ${_grouped.format(amount)}';

  /// `2.5` -> `2.5 km`.
  static String km(num distance) => '$distance km';
}
