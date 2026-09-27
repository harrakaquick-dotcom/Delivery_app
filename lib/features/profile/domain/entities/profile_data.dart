/// One 30-day performance metric drawn as a progress bar.
class PerformanceMetric {
  const PerformanceMetric({
    required this.label,
    required this.value,
    required this.fraction,
    this.highlight = false,
  });

  final String label;
  final String value;

  /// Bar fill, 0 to 1.
  final double fraction;

  /// Rating is drawn in brand red; the rest in green.
  final bool highlight;
}

/// Where an account row leads.
enum AccountTarget { documents, payout, shifts, language, help }

/// One row under "Account".
class AccountEntry {
  const AccountEntry(this.label, this.meta, this.target);

  final String label;
  final String meta;
  final AccountTarget target;
}
