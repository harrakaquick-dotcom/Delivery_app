import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_chip.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../domain/entities/delivery_order.dart';
import '../providers/delivery_providers.dart';

/// Step 1 of 3: tick every line before confirming the pickup.
class StorePickupScreen extends ConsumerWidget {
  const StorePickupScreen({super.key, this.onNavigate, this.onConfirm});

  final VoidCallback? onNavigate;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(activeOrderProvider);
    final checked = ref.watch(pickupChecklistProvider);
    final allChecked = checked.length == order.lines.length;
    void toRide() =>
        Navigator.of(context).pushReplacementNamed(RouteNames.ride);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 6, 14, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StoreCard(order: order, onNavigate: onNavigate ?? toRide),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 20, 6, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'VERIFY ${order.lines.length} LINES · ${order.itemCount} UNITS',
                        style: AppTextStyles.label,
                      ),
                    ),
                    Text(
                      '${checked.length} / ${order.lines.length} checked',
                      style: AppTextStyles.label.copyWith(
                        letterSpacing: 0.66,
                        color: allChecked
                            ? AppColors.secondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              for (var i = 0; i < order.lines.length; i++) ...[
                if (i > 0) const SizedBox(height: 9),
                _LineTile(
                  line: order.lines[i],
                  on: checked.contains(i),
                  onTap: () =>
                      ref.read(pickupChecklistProvider.notifier).toggle(i),
                ),
              ],
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Order value', style: AppTextStyles.titleSmall),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '${Formatters.kes(order.orderValue)} · cash',
                        textAlign: TextAlign.right,
                        style: AppTextStyles.titleSmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const SecondaryButton(label: 'Report a missing item'),
              const SizedBox(height: 10),
              AppButton(
                label: allChecked
                    ? 'Confirm pickup & start ride →'
                    : 'Check every line to continue',
                onPressed: allChecked ? (onConfirm ?? toRide) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Store name, address and quick actions.
class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.order, this.onNavigate});

  final DeliveryOrder order;
  final VoidCallback? onNavigate;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: 24,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(child: PillChip('Step 1 of 3 · Pick up')),
              const SizedBox(width: 8),
              Text(order.id, style: AppTextStyles.chip.copyWith(fontSize: 11)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            order.storeName,
            style: AppTextStyles.headingLarge.copyWith(
              fontSize: 21,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${order.storeAddress} · ${Formatters.km(order.pickupKm)} · ${order.pickupRideMinutes} min ride',
            style: AppTextStyles.bodyMedium.copyWith(fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: SecondaryButton(
                  label: 'Call store',
                  height: 46,
                  radius: 14,
                  centered: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SecondaryButton(
                  label: 'Navigate',
                  height: 46,
                  radius: 14,
                  centered: true,
                  onPressed: onNavigate,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A tickable order line.
class _LineTile extends StatelessWidget {
  const _LineTile({required this.line, required this.on, required this.onTap});

  final OrderLine line;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final border = on ? AppColors.primary : AppColors.borderStrong;
    return Material(
      color: on ? AppColors.primaryTint : AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          constraints: const BoxConstraints(minHeight: 70),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: on ? AppColors.primary : AppColors.card,
                  shape: BoxShape.circle,
                  border: Border.all(color: border, width: 1.5),
                ),
                child: Icon(
                  Icons.check,
                  size: 14,
                  color: on ? Colors.white : Colors.transparent,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(line.name, style: AppTextStyles.title),
                    Text(
                      line.meta,
                      style: AppTextStyles.caption.copyWith(height: 1.45),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Text(
                  '×${line.qty}',
                  style: AppTextStyles.title.copyWith(
                    height: 1,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
