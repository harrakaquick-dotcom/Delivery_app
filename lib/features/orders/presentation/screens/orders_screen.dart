import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_label.dart';
import '../../data/sample_orders.dart';
import '../../domain/entities/order_history_item.dart';

/// Orders tab: time-chip list; returns read differently from deliveries.
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

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
              const SectionLabel('My orders'),
              const SizedBox(height: 8),
              Text(
                sampleOrdersSummary,
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
              for (var i = 0; i < sampleOrderHistory.length; i++) ...[
                if (i > 0) const SizedBox(height: 9),
                _OrderRow(item: sampleOrderHistory[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// One past order.
class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.item});

  final OrderHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final returned = item.outcome == OrderOutcome.returned;
    final chipBg = returned ? AppColors.primaryLight : AppColors.secondaryLight;
    final fg = returned ? AppColors.primaryDark : AppColors.secondary;
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: chipBg,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              item.time,
              style: AppTextStyles.chip.copyWith(
                fontSize: 11,
                color: fg,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.id} · ${item.drop}',
                  style: AppTextStyles.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  item.meta,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(item.pay, style: AppTextStyles.titleSmall),
              const SizedBox(height: 2),
              Text(
                (returned ? 'Returned' : 'Delivered').toUpperCase(),
                style: AppTextStyles.chip.copyWith(
                  color: fg,
                  letterSpacing: 0.6,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
