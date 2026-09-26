import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/sample_ride.dart';
import '../providers/delivery_providers.dart';
import '../widgets/route_map_placeholder.dart';

/// Step 2 of 3: ride to the customer. The route is a placeholder for the map SDK.
class RideScreen extends ConsumerWidget {
  const RideScreen({super.key, this.onArrived, this.onMessage});

  final VoidCallback? onArrived;
  final VoidCallback? onMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(activeOrderProvider);
    const ride = sampleRide;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  const RouteMapPlaceholder(),
                  Positioned(
                    top: 14,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.ink,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3D1A1A1A),
                            blurRadius: 18,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Text(
                        ride.eta,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontSize: 12,
                          color: Colors.white,
                          height: 1,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 14,
                    right: 16,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x241A1A1A),
                            blurRadius: 14,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.my_location, size: 18),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 16,
                    child: _InstructionCard(ride: ride),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppCard(
                    radius: 22,
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            _initials(order.customerName),
                            style: AppTextStyles.titleSmall.copyWith(height: 1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.customerName,
                                style: AppTextStyles.title,
                              ),
                              Text(
                                '${order.dropAddress.split(',').first} · ${order.dropDetail}',
                                style: AppTextStyles.caption.copyWith(
                                  height: 1.45,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        _RoundAction(
                          icon: Icons.call,
                          background: AppColors.secondaryLight,
                          foreground: AppColors.secondary,
                          onTap: () {},
                        ),
                        const SizedBox(width: 8),
                        _RoundAction(
                          icon: Icons.chat_bubble_outline,
                          background: AppColors.surface,
                          foreground: AppColors.textPrimary,
                          onTap: onMessage ?? () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppButton(
                    label: 'I have arrived →',
                    onPressed:
                        onArrived ??
                        () {
                          ref.read(dropCodeProvider.notifier).reset();
                          Navigator.of(
                            context,
                          ).pushReplacementNamed(RouteNames.deliver);
                        },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _initials(String name) => name
      .split(' ')
      .where((p) => p.isNotEmpty)
      .take(2)
      .map((p) => p[0].toUpperCase())
      .join();
}

/// Bottom-of-map turn instruction.
class _InstructionCard extends StatelessWidget {
  const _InstructionCard({required this.ride});

  final RideInfo ride;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x241A1A1A),
            blurRadius: 28,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ride.stepLabel.toUpperCase(),
            style: AppTextStyles.chip.copyWith(height: 1.2),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.turn_right,
                  size: 20,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ride.instruction,
                      style: AppTextStyles.headingMedium.copyWith(
                        height: 1.3,
                        letterSpacing: 0,
                      ),
                    ),
                    Text(
                      ride.instructionDetail,
                      style: AppTextStyles.caption.copyWith(height: 1.45),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 44px circular call / message button.
class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 18, color: foreground),
        ),
      ),
    );
  }
}
