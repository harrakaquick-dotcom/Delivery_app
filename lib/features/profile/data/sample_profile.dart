import '../domain/entities/profile_data.dart';

/// Demo 30-day performance numbers.
const List<PerformanceMetric> samplePerformance = [
  PerformanceMetric(label: 'On-time rate', value: '96%', fraction: 0.96),
  PerformanceMetric(label: 'Acceptance rate', value: '91%', fraction: 0.91),
  PerformanceMetric(label: 'Order accuracy', value: '99%', fraction: 0.99),
  PerformanceMetric(
    label: 'Customer rating',
    value: '4.9 / 5',
    fraction: 0.98,
    highlight: true,
  ),
];

/// Demo account rows.
const List<AccountEntry> sampleAccountEntries = [
  AccountEntry('Documents', '1 pending', AccountTarget.documents),
  AccountEntry('Bank & M-Pesa details', '•••• 0991', AccountTarget.payout),
  AccountEntry('Shift preferences', 'Morning', AccountTarget.shifts),
  AccountEntry('Language', 'English', AccountTarget.language),
  AccountEntry('Help & safety', 'SOS, insurance', AccountTarget.help),
];
