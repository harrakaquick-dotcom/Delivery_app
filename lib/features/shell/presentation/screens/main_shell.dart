import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/session_providers.dart';
import '../../../../core/routing/route_names.dart';
import '../../../duty/domain/entities/duty_summary.dart';
import '../../../duty/presentation/screens/duty_home_screen.dart';
import '../../../earnings/presentation/screens/earnings_screen.dart';
import '../../../orders/presentation/screens/orders_screen.dart';

/// Tab shell holding the five main screens behind the bottom bar.
class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const List<_TabSpec> _tabs = [
    _TabSpec('DUTY', Icons.two_wheeler_outlined),
    _TabSpec('ORDERS', Icons.assignment_outlined),
    _TabSpec('EARN', Icons.account_balance_wallet_outlined),
    _TabSpec('ALERTS', Icons.notifications_none),
    _TabSpec('ME', Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(mainTabProvider);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: index,
          children: [
            DutyHomeScreen(
              onOpenTool: (target) {
                switch (target) {
                  case ShiftToolTarget.cash:
                    Navigator.of(context).pushNamed(RouteNames.cash);
                  case ShiftToolTarget.incentives:
                    Navigator.of(context).pushNamed(RouteNames.done);
                  case ShiftToolTarget.slots:
                  case ShiftToolTarget.support:
                    break;
                }
              },
              onSimulate: () =>
                  Navigator.of(context).pushNamed(RouteNames.request),
            ),
            const OrdersScreen(),
            const EarningsScreen(),
            for (final t in _tabs.skip(3)) Center(child: Text(t.label)),
          ],
        ),
      ),
      bottomNavigationBar: _BottomBar(
        index: index,
        onSelect: (i) => ref.read(mainTabProvider.notifier).state = i,
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// White bottom bar with a tinted pill behind the active tab.
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.index, required this.onSelect});

  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
          child: Row(
            children: [
              for (var i = 0; i < MainShell._tabs.length; i++)
                Expanded(child: _tab(i)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tab(int i) {
    final spec = MainShell._tabs[i];
    final on = i == index;
    final fg = on ? AppColors.primaryDark : AppColors.textSecondary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Material(
        color: on ? AppColors.primaryLight : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          onTap: () => onSelect(i),
          child: SizedBox(
            height: 56,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(spec.icon, size: 21, color: fg),
                const SizedBox(height: 5),
                Text(
                  spec.label,
                  style: AppTextStyles.chip.copyWith(
                    color: fg,
                    letterSpacing: 0.5,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
