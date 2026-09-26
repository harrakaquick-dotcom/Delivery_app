import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/code_boxes.dart';
import '../../../../core/widgets/numeric_keypad.dart';

/// OTP entry: four boxes driven by an on-screen keypad.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phone, this.onVerified});

  /// Local 9-digit number, e.g. `712480991`.
  final String phone;

  /// Called once all four digits are entered. Defaults to opening verification.
  final VoidCallback? onVerified;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const int _length = 4;
  String _code = '';

  String get _formattedPhone {
    final p = widget.phone;
    if (p.length != 9) return '+254 $p';
    return '+254 ${p.substring(0, 3)} ${p.substring(3, 6)} ${p.substring(6)}';
  }

  void _add(String d) {
    if (_code.length >= _length) return;
    setState(() => _code += d);
    if (_code.length == _length) {
      final done = widget.onVerified;
      if (done != null) {
        done();
      } else {
        Navigator.of(context).pushReplacementNamed(RouteNames.docs);
      }
    }
  }

  void _back() {
    if (_code.isEmpty) return;
    setState(() => _code = _code.substring(0, _code.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 22, 26, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BackButton(onTap: () => Navigator.of(context).maybePop()),
              const SizedBox(height: 22),
              const Text(
                'Enter the 4-digit code',
                style: AppTextStyles.displayMedium,
              ),
              const SizedBox(height: 6),
              Text('Sent to $_formattedPhone', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 26),
              CodeBoxes(code: _code),
              const SizedBox(height: AppSpacing.md),
              const Text('Resend code in 0:24', style: AppTextStyles.caption),
              const Spacer(),
              NumericKeypad(onDigit: _add, onBackspace: _back),
            ],
          ),
        ),
      ),
    );
  }
}

/// Square back button used at the top of onboarding screens.
class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        side: const BorderSide(color: AppColors.borderStrong),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        child: const SizedBox(
          width: 40,
          height: 40,
          child: Center(child: Text('←', style: TextStyle(fontSize: 15))),
        ),
      ),
    );
  }
}
