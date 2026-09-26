import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/section_label.dart';
import '../../data/sample_notifications.dart';
import '../../domain/entities/agent_notification.dart';

/// Alerts tab: surge, verification, slots and payouts in one stream.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 22),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionLabel('Notifications'),
              const SizedBox(height: 8),
              Text(
                sampleNotificationsHeadline,
                style: AppTextStyles.headingLarge.copyWith(
                  fontSize: 26,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
          child: Column(
            children: [
              for (var i = 0; i < sampleNotifications.length; i++) ...[
                if (i > 0) const SizedBox(height: 9),
                _NotificationTile(item: sampleNotifications[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Icon tile colours by kind: urgent red, positive green, otherwise neutral.
({IconData icon, Color bg, Color fg}) _iconStyle(NotificationKind kind) {
  switch (kind) {
    case NotificationKind.surge:
      return (
        icon: Icons.arrow_upward,
        bg: AppColors.primaryLight,
        fg: AppColors.primaryDark,
      );
    case NotificationKind.verification:
      return (
        icon: Icons.priority_high,
        bg: AppColors.primaryLight,
        fg: AppColors.primaryDark,
      );
    case NotificationKind.slot:
      return (
        icon: Icons.check,
        bg: AppColors.secondaryLight,
        fg: AppColors.secondary,
      );
    case NotificationKind.payout:
      return (
        icon: Icons.payments_outlined,
        bg: AppColors.surface,
        fg: AppColors.textSecondary,
      );
    case NotificationKind.rule:
      return (
        icon: Icons.flag_outlined,
        bg: AppColors.surface,
        fg: AppColors.textSecondary,
      );
  }
}

/// One alert; unread ones carry a warm tint.
class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item});

  final AgentNotification item;

  @override
  Widget build(BuildContext context) {
    final style = _iconStyle(item.kind);
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: item.isNew ? AppColors.primaryTint : AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: item.isNew ? AppColors.primarySoft : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: style.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(style.icon, size: 16, color: style.fg),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.titleSmall.copyWith(height: 1.35),
                ),
                const SizedBox(height: 3),
                Text(
                  item.body,
                  style: AppTextStyles.caption.copyWith(height: 1.55),
                ),
                const SizedBox(height: 7),
                Text(
                  item.time.toUpperCase(),
                  style: AppTextStyles.chip.copyWith(
                    color: AppColors.textTertiary,
                    letterSpacing: 0.7,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
