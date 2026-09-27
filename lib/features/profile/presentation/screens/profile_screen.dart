import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/agent_profile.dart';
import '../../../../core/providers/session_providers.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_chip.dart';
import '../../../../core/widgets/section_label.dart';
import '../../data/sample_profile.dart';
import '../../domain/entities/profile_data.dart';

/// Profile tab: the four numbers that set an agent's standing, plus account.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, this.onOpenHelp});

  /// Opens help & safety (the support screen), which lives outside the shell.
  final VoidCallback? onOpenHelp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agent = ref.watch(agentProvider);

    void open(AccountTarget target) {
      switch (target) {
        case AccountTarget.documents:
          Navigator.of(context).pushNamed(RouteNames.docs);
        case AccountTarget.payout:
          ref.read(mainTabProvider.notifier).state = MainTab.earnings;
        case AccountTarget.shifts:
          ref.read(mainTabProvider.notifier).state = MainTab.alerts;
        case AccountTarget.help:
          onOpenHelp?.call();
        case AccountTarget.language:
          break;
      }
    }

    void signOut() {
      ref.read(onlineProvider.notifier).state = false;
      ref.read(mainTabProvider.notifier).state = MainTab.duty;
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(RouteNames.login, (_) => false);
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 22),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: _Header(agent: agent),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 22, 14, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 6),
                child: SectionLabel('Last 30 days'),
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
                    for (var i = 0; i < samplePerformance.length; i++)
                      _MetricRow(
                        metric: samplePerformance[i],
                        divider: i < samplePerformance.length - 1,
                      ),
                  ],
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
                child: SectionLabel('Account'),
              ),
              const SizedBox(height: 10),
              AppCard(
                radius: 22,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  children: [
                    for (final e in sampleAccountEntries)
                      _AccountRow(entry: e, onTap: () => open(e.target)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Material(
                color: AppColors.card,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.primaryBorder),
                ),
                child: InkWell(
                  onTap: signOut,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      'Sign out',
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Avatar, name, identifiers and rating pill.
class _Header extends StatelessWidget {
  const _Header({required this.agent});

  final AgentProfile agent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 66,
          height: 66,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            agent.initials,
            style: AppTextStyles.headingLarge.copyWith(
              fontSize: 20,
              height: 1,
              letterSpacing: 0,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                agent.name,
                style: AppTextStyles.headingLarge.copyWith(height: 1.2),
              ),
              const SizedBox(height: 3),
              Text(
                '${agent.agentId} · Bike ${agent.bike} · ${agent.zone}',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 9),
              PillChip(
                '★ ${agent.rating} rating',
                background: AppColors.secondaryLight,
                foreground: AppColors.secondary,
                letterSpacing: 0.66,
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Label, value and a thin progress bar.
class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.metric, required this.divider});

  final PerformanceMetric metric;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: divider
            ? const Border(bottom: BorderSide(color: Color(0xFFF2EFEE)))
            : null,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(metric.label, style: AppTextStyles.titleSmall),
              Text(metric.value, style: AppTextStyles.titleSmall),
            ],
          ),
          const SizedBox(height: 9),
          Container(
            height: 7,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEED),
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            ),
            child: FractionallySizedBox(
              widthFactor: metric.fraction,
              child: Container(
                decoration: BoxDecoration(
                  color: metric.highlight
                      ? AppColors.primary
                      : AppColors.secondary,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One tappable account row.
class _AccountRow extends StatelessWidget {
  const _AccountRow({required this.entry, required this.onTap});

  final AccountEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: const BoxConstraints(minHeight: 54),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(entry.label, style: AppTextStyles.titleSmall)),
            const SizedBox(width: 8),
            Text('${entry.meta} ›', style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
