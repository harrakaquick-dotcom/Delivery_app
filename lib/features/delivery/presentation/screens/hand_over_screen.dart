import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/code_boxes.dart';
import '../../../../core/widgets/numeric_keypad.dart';
import '../../../../core/widgets/pill_chip.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../providers/delivery_providers.dart';

/// Step 3 of 3: the customer reads out a 4-digit code, with a photo fallback.
class HandOverScreen extends ConsumerWidget {
  const HandOverScreen({super.key, this.onVerified});

  final VoidCallback? onVerified;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(activeOrderProvider);
    final code = ref.watch(dropCodeProvider);
    final notifier = ref.read(dropCodeProvider.notifier);
    final ready = code.length == DropCodeNotifier.length;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(26, 20, 26, 26),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 46,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PillChip(
                      'Step 3 of 3 · hand over',
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Ask for the delivery code',
                      style: AppTextStyles.displayMedium.copyWith(
                        fontSize: 26,
                        height: 1.22,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${order.customerName} has a 4-digit code in the Harraka app.',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 22),
                    CodeBoxes(code: code, height: 64),
                    const Spacer(),
                    const SizedBox(height: 24),
                    NumericKeypad(
                      onDigit: notifier.add,
                      onBackspace: notifier.backspace,
                      keyHeight: 52,
                    ),
                    const SizedBox(height: 16),
                    const SecondaryButton(
                      label: 'Customer unreachable — take a photo',
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                      label: ready
                          ? 'Code verified — continue →'
                          : 'Enter 4 digits to continue',
                      onPressed: ready
                          ? (onVerified ??
                                () => Navigator.of(
                                  context,
                                ).pushReplacementNamed(RouteNames.cash))
                          : null,
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
