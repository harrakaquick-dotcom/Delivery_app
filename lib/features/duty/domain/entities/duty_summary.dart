/// One figure in the "Today" grid.
class DutyStat {
  const DutyStat(this.label, this.value);

  final String label;
  final String value;
}

/// A shortcut card under "Shift tools".
class ShiftTool {
  const ShiftTool({required this.name, required this.meta, required this.target});

  final String name;
  final String meta;
  final ShiftToolTarget target;
}

/// Where a shift tool leads.
enum ShiftToolTarget { slots, incentives, cash, support }
