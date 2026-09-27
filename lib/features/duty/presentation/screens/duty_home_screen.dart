import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/session_providers.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pulse_dot.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/two_column_grid.dart';
import '../../data/sample_duty.dart';
import '../../domain/entities/duty_summary.dart';

/// Duty home: ink card offline, red card online; the toggle dominates.
class DutyHomeScreen extends ConsumerWidget {
  const DutyHomeScreen({super.key, this.onSimulate, this.onOpenTool});

  /// Sends a demo order request (wired by the order flow).
  final VoidCallback? onSimulate;

  /// Opens a shift tool that lives outside the tab shell.
  final ValueChanged<ShiftToolTarget>? onOpenTool;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(onlineProvider);
    final agent = ref.watch(agentProvider);

    void openTool(ShiftToolTarget t) {
      if (t == ShiftToolTarget.slots) {
        ref.read(mainTabProvider.notifier).state = MainTab.alerts;
      } else {
        onOpenTool?.call(t);
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 22),
      children: [
        _DutyCard(
          online: online,
          firstName: agent.firstName,
          initials: agent.initials,
          store: agent.store,
          zone: agent.zone,
          onToggle: () => ref.read(onlineProvider.notifier).state = !online,
        ),
        if (online) ...[
          const SizedBox(height: 14),
          _ListeningCard(zone: agent.zone, onSimulate: onSimulate),
        ],
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.only(left: 6),
          child: SectionLabel('Today'),
        ),
        const SizedBox(height: 10),
        TwoColumnGrid(
          children: [for (final s in sampleDutyStats) _StatCard(stat: s)],
        ),
        const SizedBox(height: 14),
        _PayoutStrip(
          onDetails: () =>
              ref.read(mainTabProvider.notifier).state = MainTab.earnings,
        ),
        const SizedBox(height: 18),
        const Padding(
          padding: EdgeInsets.only(left: 6),
          child: SectionLabel('Shift tools'),
        ),
        const SizedBox(height: 10),
        TwoColumnGrid(
          children: [
            for (final t in sampleShiftTools)
              _ToolCard(tool: t, onTap: () => openTool(t.target)),
          ],
        ),
      ],
    );
  }
}

/// The big duty status card with the go-online toggle.
class _DutyCard extends StatelessWidget {
  const _DutyCard({
    required this.online,
    required this.firstName,
    required this.initials,
    required this.store,
    required this.zone,
    required this.onToggle,
  });

  final bool online;
  final String firstName;
  final String initials;
  final String store;
  final String zone;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final glass = Colors.white.withValues(alpha: 0.18);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: online ? AppColors.primary : AppColors.ink,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
        boxShadow: [
          BoxShadow(
            color: online ? AppColors.primaryShadow : const Color(0x2E1A1A1A),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: glass,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusPill,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          online
                              ? const PulseDot(
                                  color: Colors.white,
                                  period: Duration(milliseconds: 1600),
                                )
                              : Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                          const SizedBox(width: 7),
                          Text(
                            (online ? 'On duty · 5h 12m' : 'Off duty')
                                .toUpperCase(),
                            style: AppTextStyles.chip.copyWith(
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      online
                          ? '$firstName, you are online'
                          : 'Good morning, $firstName',
                      style: AppTextStyles.headingLarge.copyWith(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$store · zone $zone',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  initials,
                  style: AppTextStyles.title.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Material(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            child: InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              child: Container(
                height: 56,
                padding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      online ? 'Go offline' : 'Go online',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    _Toggle(on: online),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pill switch inside the duty card.
class _Toggle extends StatelessWidget {
  const _Toggle({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 60,
      height: 34,
      padding: const EdgeInsets.all(4),
      alignment: on ? Alignment.centerRight : Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Container(
        width: 26,
        height: 26,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// "Listening for orders" strip with the demo SIMULATE trigger.
class _ListeningCard extends StatelessWidget {
  const _ListeningCard({required this.zone, this.onSimulate});

  final String zone;
  final VoidCallback? onSimulate;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          const PulseDot(color: AppColors.primary, size: 11),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Listening for orders', style: AppTextStyles.title),
                Text(
                  '4 agents ahead of you in $zone',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onSimulate ?? () {},
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 40),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.borderStrong),
              shape: const StadiumBorder(),
              textStyle: AppTextStyles.chip.copyWith(
                fontSize: 11,
                letterSpacing: 0.8,
              ),
            ),
            child: const Text('SIMULATE'),
          ),
        ],
      ),
    );
  }
}

/// One figure in the Today grid.
class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final DutyStat stat;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stat.label.toUpperCase(),
            style: AppTextStyles.chip.copyWith(letterSpacing: 1),
          ),
          const SizedBox(height: 7),
          Text(
            stat.value,
            style: AppTextStyles.headingLarge.copyWith(fontSize: 22),
          ),
        ],
      ),
    );
  }
}

/// Next-payout strip with a DETAILS shortcut to earnings.
class _PayoutStrip extends StatelessWidget {
  const _PayoutStrip({required this.onDetails});

  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel(sampleNextPayoutLabel),
                const SizedBox(height: 6),
                Text(
                  sampleNextPayoutAmount,
                  style: AppTextStyles.headingLarge.copyWith(fontSize: 21),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: onDetails,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.ink,
              minimumSize: const Size(0, 44),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: const StadiumBorder(),
              textStyle: AppTextStyles.chip.copyWith(
                fontSize: 11,
                letterSpacing: 0.8,
              ),
            ),
            child: const Text('DETAILS'),
          ),
        ],
      ),
    );
  }
}

/// A shift-tool shortcut card.
class _ToolCard extends StatelessWidget {
  const _ToolCard({required this.tool, required this.onTap});

  final ShiftTool tool;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tool.name, style: AppTextStyles.title),
              const SizedBox(height: 5),
              Text(tool.meta, style: AppTextStyles.caption),
            ],
          ),
        ),
      ),
    );
  }
}
