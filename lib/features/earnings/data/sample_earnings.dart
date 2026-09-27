import '../domain/entities/earnings_summary.dart';

/// Demo earnings per range.
const Map<EarningsRange, EarningsSummary> sampleEarnings = {
  EarningsRange.today: EarningsSummary(
    total: 'KES 1,840',
    meta: '12 deliveries · 5h 12m online',
    lines: [
      EarningLine('Base fares', '12 orders', 'KES 960'),
      EarningLine('Distance pay', '22 km', 'KES 640'),
      EarningLine('Tips', 'Paid with the weekly cycle', 'KES 240'),
      EarningLine('Incentives', 'Streaks and peak-hour bonuses', 'KES 0'),
    ],
  ),
  EarningsRange.week: EarningsSummary(
    total: 'KES 9,420',
    meta: '78 deliveries · 41h 20m online',
    lines: [
      EarningLine('Base fares', '78 orders', 'KES 6,240'),
      EarningLine('Distance pay', '164 km', 'KES 2,180'),
      EarningLine('Tips', 'Paid with the weekly cycle', 'KES 760'),
      EarningLine('Incentives', 'Streaks and peak-hour bonuses', 'KES 240'),
    ],
  ),
  EarningsRange.month: EarningsSummary(
    total: 'KES 38,260',
    meta: '213 deliveries · 4 payouts',
    lines: [
      EarningLine('Base fares', '213 orders', 'KES 25,560'),
      EarningLine('Distance pay', '486 km', 'KES 9,120'),
      EarningLine('Tips', 'Paid with the weekly cycle', 'KES 3,180'),
      EarningLine('Incentives', 'Streaks and peak-hour bonuses', 'KES 400'),
    ],
  ),
};

const List<HoursBar> sampleHoursWorked = [
  HoursBar('M', 62),
  HoursBar('T', 78),
  HoursBar('W', 45),
  HoursBar('T', 88),
  HoursBar('F', 96),
  HoursBar('S', 70),
  HoursBar('S', 34),
];

const String sampleNextPayout = 'KES 9,420 · Mon 22 Sep';
