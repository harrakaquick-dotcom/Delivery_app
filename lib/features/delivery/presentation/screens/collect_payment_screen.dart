import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_tabs.dart';
import '../../../../core/widgets/section_label.dart';
import '../../domain/entities/delivery_order.dart';
import '../providers/delivery_providers.dart';

/// Collect payment: M-Pesa till or cash; cash raises the bag balance.
class CollectPaymentScreen extends ConsumerWidget {
  const CollectPaymentScreen({super.key, this.onComplete});

  final VoidCallback? onComplete;

  static const String _mpesa = 'M-Pesa';
  static const String _cash = 'Cash';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(activeOrderProvider);
    final mode = ref.watch(paymentModeProvider);
    final bag = ref.watch(cashInBagProvider);
    final isCash = mode == PaymentMode.cash;
    final bagAfter = bag + (isCash ? order.orderValue : 0);

    void complete() {
      if (isCash) {
        ref.read(cashInBagProvider.notifier).state = bagAfter;
      }
      final custom = onComplete;
      if (custom != null) {
        custom();
      } else {
        Navigator.of(context).pushReplacementNamed(RouteNames.done);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 44,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionLabel('Collect payment'),
                    const SizedBox(height: 10),
                    Text(
                      Formatters.kes(order.orderValue),
                      style: AppTextStyles.displayLarge.copyWith(
                        height: 1.05,
                        letterSpacing: -0.035 * 44,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Order ${order.id} · unpaid at checkout',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 26),
                    const SectionLabel('How was it paid?'),
                    const SizedBox(height: 10),
                    PillTabs(
                      options: const [_mpesa, _cash],
                      selected: isCash ? _cash : _mpesa,
                      onChanged: (v) =>
                          ref.read(paymentModeProvider.notifier).state =
                              v == _cash ? PaymentMode.cash : PaymentMode.mpesa,
                    ),
                    const SizedBox(height: 14),
                    AppCard(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionLabel(
                            isCash
                                ? 'Count the notes before you ride off'
                                : 'Awaiting till confirmation',
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isCash
                                ? 'Take ${Formatters.kes(order.orderValue)} and give change from your float. This amount is added to your cash-in-bag balance and deducted from your payout.'
                                : 'Ask the customer to pay Harraka till 4009221, ref ${order.reference}. The app confirms automatically within 20 seconds.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              height: 1.65,
                              color: const Color(0xFF3A3A3A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMedium,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'Cash in bag after this run',
                              style: AppTextStyles.titleSmall,
                            ),
                          ),
                          Text(
                            Formatters.kes(bagAfter),
                            style: AppTextStyles.titleSmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                      label: 'Mark collected & complete →',
                      onPressed: complete,
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
