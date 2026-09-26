import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/numeric_keypad.dart';

/// OTP entry: four boxes driven by an on-screen keypad.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phone, this.onVerified});

  /// Local 9-digit number, e.g. `712480991`.
  final String phone;

  /// Called once all four digits are entered.
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
    if (_code.length == _length) widget.onVerified?.call();
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
              const Text('Enter the 4-digit code',
                  style: AppTextStyles.displayMedium),
              const SizedBox(height: 6),
              Text('Sent to $_formattedPhone', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 26),
              Row(
                children: [
                  for (var i = 0; i < _length; i++) ...[
                    if (i > 0) const SizedBox(width: 11),
                    Expanded(
                      child: _OtpBox(
                        char: i < _code.length ? _code[i] : '',
                        active: _code.length == i,
                      ),
                    ),
                  ],
                ],
              ),
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

/// One digit box; the next-to-fill box gets a red ring.
class _OtpBox extends StatelessWidget {
  const _OtpBox({required this.char, required this.active});

  final String char;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: active ? AppColors.primary : AppColors.borderStrong,
          width: 1.5,
        ),
        boxShadow: [
          active
              ? const BoxShadow(color: Color(0x1FEC3013), spreadRadius: 4)
              : const BoxShadow(
                  color: Color(0x0A1A1A1A),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
        ],
      ),
      child: Text(
        char,
        style: AppTextStyles.displayMedium.copyWith(fontSize: 26, letterSpacing: 0),
      ),
    );
  }
}
