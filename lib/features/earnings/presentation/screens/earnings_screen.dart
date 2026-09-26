import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/session_providers.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_tabs.dart';
import '../../../../core/widgets/section_label.dart';
import '../../data/sample_earnings.dart';
import '../../domain/entities/earnings_summary.dart';
import '../providers/earnings_providers.dart';

/// Earnings tab: today / week / month with peak days in red.
class EarningsScreen extends ConsumerWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(earningsRangeProvider);
    final summary = sampleEarnings[range]!;
    final agent = ref.watch(agentProvider);

    return ListView(
      padding: const EdgeInsets.only(bottom: 22),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionLabel('Earnings'),
              const SizedBox(height: 12),
              PillTabs(
                options: [for (final r in EarningsRange.values) r.label],
                selected: range.label,
                height: 42,
                onChanged: (label) =>
                    ref
                        .read(earningsRangeProvider.notifier)
                        .state = EarningsRange.values.firstWhere(
                      (r) => r.label == label,
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                summary.total,
                style: AppTextStyles.displayLarge.copyWith(
                  height: 1.05,
                  letterSpacing: -0.035 * 44,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                summary.meta,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 6),
                child: SectionLabel('Breakdown'),
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
                    for (var i = 0; i < summary.lines.length; i++)
                      _BreakdownRow(
                        line: summary.lines[i],
                        divider: i < summary.lines.length - 1,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: _HoursChart(bars: sampleHoursWorked),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
          child: _PayoutCard(mpesa: agent.mpesa),
        ),
      ],
    );
  }
}

/// One breakdown line: label and meta on the left, value on the right.
class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({required this.line, required this.divider});

  final EarningLine line;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        border: divider
            ? const Border(bottom: BorderSide(color: Color(0xFFF2EFEE)))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(line.label, style: AppTextStyles.titleSmall),
                Text(
                  line.meta,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(line.value, style: AppTextStyles.title.copyWith(height: 1)),
        ],
      ),
    );
  }
}

/// Seven pill bars for hours worked; peak days in red.
class _HoursChart extends StatelessWidget {
  const _HoursChart({required this.bars});

  final List<HoursBar> bars;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Hours worked'),
        const SizedBox(height: 14),
        SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < bars.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(
                  child: FractionallySizedBox(
                    heightFactor: bars[i].percent / 100,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        color: bars[i].isPeak
                            ? AppColors.primary
                            : const Color(0xFFE4E0DE),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusPill,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var i = 0; i < bars.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(
                child: Text(
                  bars[i].day,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.chip.copyWith(letterSpacing: 0),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

/// Upcoming payout with a statement download.
class _PayoutCard extends StatelessWidget {
  const _PayoutCard({required this.mpesa});

  final String mpesa;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel('Payout to M-Pesa $mpesa'),
          const SizedBox(height: 7),
          Text(
            sampleNextPayout,
            style: AppTextStyles.headingLarge.copyWith(
              fontSize: 20,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 46,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: const Text(
                  'Download statement',
                  style: AppTextStyles.titleSmall,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
