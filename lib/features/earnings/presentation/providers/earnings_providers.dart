import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/earnings_summary.dart';

/// Selected earnings window.
final earningsRangeProvider = StateProvider<EarningsRange>(
  (ref) => EarningsRange.today,
);
