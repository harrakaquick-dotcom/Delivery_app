import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/routing/route_names.dart';
import '../providers/delivery_providers.dart';

/// The one full-red screen: countdown, payout and both legs of the trip.
class OrderRequestScreen extends ConsumerStatefulWidget {
  const OrderRequestScreen({
    super.key,
    this.acceptSeconds = 30,
    this.onAccept,
    this.onDecline,
  });

  final int acceptSeconds;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  @override
  ConsumerState<OrderRequestScreen> createState() => _OrderRequestScreenState();
}

class _OrderRequestScreenState extends ConsumerState<OrderRequestScreen> {
  late int _secs = widget.acceptSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secs <= 0) return;
      setState(() => _secs--);
    });
  }

  void _accept() {
    ref.read(pickupChecklistProvider.notifier).reset();
    Navigator.of(context).pushReplacementNamed(RouteNames.pickup);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = ref.watch(activeOrderProvider);
    final onPrimary = Colors.white.withValues(alpha: 0.85);
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 40,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusPill,
                            ),
                          ),
                          child: Text(
                            'NEW ORDER',
                            style: AppTextStyles.chip.copyWith(
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        Text(
                          order.id,
                          style: AppTextStyles.chip.copyWith(
                            fontSize: 11,
                            color: onPrimary,
                            letterSpacing: 0.66,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _secs.toString().padLeft(2, '0'),
                          style: AppTextStyles.displayLarge.copyWith(
                            fontSize: 74,
                            height: 0.92,
                            letterSpacing: -0.05 * 74,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            'seconds\nto accept',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 13,
                              height: 1.4,
                              color: onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _CountdownBar(fraction: _secs / widget.acceptSeconds),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _StatBox('Payout', Formatters.kes(order.payout)),
                        const SizedBox(width: 10),
                        _StatBox('Distance', Formatters.km(order.totalKm)),
                        const SizedBox(width: 10),
                        _StatBox('Items', '${order.itemCount}'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLarge,
                        ),
                      ),
                      child: Column(
                        children: [
                          _Leg(
                            km: '${order.pickupKm}',
                            tileBg: AppColors.primaryLight,
                            tileFg: AppColors.primaryDark,
                            kicker:
                                'Pick up · ${Formatters.km(order.pickupKm)}',
                            title: order.storeName,
                            subtitle:
                                '${order.storeAddress} · packed and waiting',
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            indent: 14,
                            endIndent: 14,
                            color: AppColors.border,
                          ),
                          _Leg(
                            km: '${order.dropKm}',
                            tileBg: AppColors.secondaryLight,
                            tileFg: AppColors.secondary,
                            kicker: 'Drop · ${Formatters.km(order.dropKm)}',
                            title: order.dropAddress,
                            subtitle:
                                '${order.customerName} · cash on delivery ${Formatters.kes(order.orderValue)}',
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(height: 18),
                    _AcceptButton(onTap: widget.onAccept ?? _accept),
                    const SizedBox(height: 9),
                    _DeclineButton(
                      onTap:
                          widget.onDecline ??
                          () => Navigator.of(context).maybePop(),
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

/// White track with a shrinking fill.
class _CountdownBar extends StatelessWidget {
  const _CountdownBar({required this.fraction});

  final double fraction;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: FractionallySizedBox(
        widthFactor: fraction.clamp(0, 1),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          ),
        ),
      ),
    );
  }
}

/// Translucent stat tile on the red background.
class _StatBox extends StatelessWidget {
  const _StatBox(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: AppTextStyles.chip.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: AppTextStyles.headingLarge.copyWith(
                fontSize: 21,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One leg of the trip inside the white card.
class _Leg extends StatelessWidget {
  const _Leg({
    required this.km,
    required this.tileBg,
    required this.tileFg,
    required this.kicker,
    required this.title,
    required this.subtitle,
  });

  final String km;
  final Color tileBg;
  final Color tileFg;
  final String kicker;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tileBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              km,
              style: AppTextStyles.chip.copyWith(
                fontSize: 11,
                color: tileFg,
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
                  kicker.toUpperCase(),
                  style: AppTextStyles.chip.copyWith(height: 1.2),
                ),
                const SizedBox(height: 3),
                Text(
                  title,
                  style: AppTextStyles.headingMedium.copyWith(
                    fontSize: 15,
                    height: 1.35,
                    letterSpacing: 0,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AcceptButton extends StatelessWidget {
  const _AcceptButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2E000000),
            blurRadius: 26,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap ?? () {},
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 60,
            width: double.infinity,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              'Accept order →',
              style: AppTextStyles.button.copyWith(
                fontSize: 17,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DeclineButton extends StatelessWidget {
  const _DeclineButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.55)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: AppTextStyles.titleSmall.copyWith(letterSpacing: 0.8),
      ),
      child: const Text('Decline'),
    );
  }
}
