/// Time window shown on the earnings screen.
enum EarningsRange {
  today('Today'),
  week('This week'),
  month('Month');

  const EarningsRange(this.label);

  final String label;
}

/// One line of the earnings breakdown.
class EarningLine {
  const EarningLine(this.label, this.meta, this.value);

  final String label;
  final String meta;
  final String value;
}

/// Totals and breakdown for one [EarningsRange].
class EarningsSummary {
  const EarningsSummary({
    required this.total,
    required this.meta,
    required this.lines,
  });

  final String total;
  final String meta;
  final List<EarningLine> lines;
}

/// One day in the hours-worked chart.
class HoursBar {
  const HoursBar(this.day, this.percent);

  final String day;
  final int percent;

  /// Peak days are drawn in red.
  bool get isPeak => percent > 85;
}
