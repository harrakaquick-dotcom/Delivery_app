import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/session_providers.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_chip.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../core/widgets/section_label.dart';
import '../../data/sample_completion.dart';
import '../providers/delivery_providers.dart';

/// Completed: per-order earning, streak nudge, back online.
class OrderCompletedScreen extends ConsumerWidget {
  const OrderCompletedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(activeOrderProvider);
    const done = sampleCompletion;

    void backToShell(int tab, {bool goOnline = false}) {
      if (goOnline) ref.read(onlineProvider.notifier).state = true;
      ref.read(mainTabProvider.notifier).state = tab;
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(RouteNames.main, (_) => false);
    }

    final rows = <(String, String, bool)>[
      ('Base fare', Formatters.kes(order.baseFare), false),
      (
        'Distance · ${Formatters.km(order.totalKm)}',
        Formatters.kes(order.distancePay),
        false,
      ),
      ('Customer tip', Formatters.kes(order.tip), false),
      ('Total', Formatters.kes(order.totalEarned), true),
    ];

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 22),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 28,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(order: order.id, done: done, km: order.totalKm),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: SectionLabel('This order earned'),
                    ),
                    const SizedBox(height: 10),
                    AppCard(
                      radius: 22,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: Column(
                        children: [
                          for (var i = 0; i < rows.length; i++)
                            _EarnRow(
                              label: rows[i].$1,
                              value: rows[i].$2,
                              highlight: rows[i].$3,
                              divider: i < rows.length - 1,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _StreakCard(done: done),
                    const Spacer(),
                    const SizedBox(height: 20),
                    AppButton(
                      label: 'Back online →',
                      onPressed: () =>
                          backToShell(MainTab.duty, goOnline: true),
                    ),
                    const SizedBox(height: 9),
                    SecondaryButton(
                      label: 'See all my orders',
                      onPressed: () => backToShell(MainTab.orders),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Ink header card with the delivered pill.
class _Header extends StatelessWidget {
  const _Header({required this.order, required this.done, required this.km});

  final String order;
  final CompletionSummary done;
  final double km;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2E1A1A1A),
            blurRadius: 28,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PillChip(
            '✓ Delivered · ${done.deliveredAt}',
            background: AppColors.mintOnInkBg,
            foreground: AppColors.mintOnInk,
            letterSpacing: 1,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          ),
          const SizedBox(height: 14),
          Text(
            '${done.doneToday} down today',
            style: AppTextStyles.headingLarge.copyWith(
              fontSize: 29,
              height: 1.15,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$order · ${done.doorToDoorMinutes} min door to door · ${Formatters.km(km)}',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 13,
              height: 1.55,
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

/// One line of the earnings receipt.
class _EarnRow extends StatelessWidget {
  const _EarnRow({
    required this.label,
    required this.value,
    required this.highlight,
    required this.divider,
  });

  final String label;
  final String value;
  final bool highlight;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final fg = highlight ? AppColors.primary : const Color(0xFF3A3A3A);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        border: divider
            ? const Border(bottom: BorderSide(color: Color(0xFFF2EFEE)))
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(color: fg, height: 1.4),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.title.copyWith(color: fg, height: 1.4),
          ),
        ],
      ),
    );
  }
}

/// Streak nudge with progress segments.
class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.done});

  final CompletionSummary done;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Streak', color: AppColors.primaryDark),
          const SizedBox(height: 6),
          Text(
            done.streakMessage,
            style: AppTextStyles.headingMedium.copyWith(
              height: 1.4,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (var i = 0; i < done.streakTotal; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: i < done.streakDone
                          ? AppColors.primary
                          : AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusPill,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
