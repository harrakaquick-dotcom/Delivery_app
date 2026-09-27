import '../domain/entities/duty_summary.dart';

/// Demo "Today" figures.
const List<DutyStat> sampleDutyStats = [
  DutyStat('Deliveries', '12'),
  DutyStat('Earned', 'KES 1,840'),
  DutyStat('Online', '5h 12m'),
  DutyStat('On-time', '96%'),
];

/// Demo shift tools.
const List<ShiftTool> sampleShiftTools = [
  ShiftTool(
    name: 'Slot booking',
    meta: 'Tomorrow 7am–3pm confirmed',
    target: ShiftToolTarget.slots,
  ),
  ShiftTool(
    name: 'Incentives',
    meta: '2 drops to a KES 300 bonus',
    target: ShiftToolTarget.incentives,
  ),
  ShiftTool(
    name: 'Cash in bag',
    meta: 'KES 3,610 · deposit by 8pm',
    target: ShiftToolTarget.cash,
  ),
  ShiftTool(
    name: 'Support',
    meta: 'Fleet desk replies in ~2 min',
    target: ShiftToolTarget.support,
  ),
];

/// Demo next payout.
const String sampleNextPayoutLabel = 'Next payout · Mon 22 Sep';
const String sampleNextPayoutAmount = 'KES 9,420';
