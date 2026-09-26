import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

/// Sign-in screen: fleet-registered phone number only, no password.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const int _phoneLength = 9;

  final TextEditingController _phone = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final valid = _phone.text.length == _phoneLength;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(26, 56, 26, 30),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 86),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/images/harraka_logo.svg',
                      width: 196,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _AgentChip(),
                    const SizedBox(height: 34),
                    const Text('Sign in to your shift',
                        style: AppTextStyles.displayMedium),
                    const SizedBox(height: AppSpacing.sm),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 290),
                      child: Text(
                        'Use the phone number registered with the Harraka fleet office.',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text('PHONE NUMBER', style: AppTextStyles.label),
                    const SizedBox(height: 9),
                    _PhoneField(
                      controller: _phone,
                      maxLength: _phoneLength,
                      onChanged: (_) => setState(() {}),
                    ),
                    const Spacer(),
                    // Navigation to the OTP screen is wired when that screen lands.
                    AppButton(label: 'Send code →', onPressed: valid ? () {} : null),
                    const SizedBox(height: AppSpacing.md),
                    const Text(
                      'Trouble signing in? Call the fleet desk on 0800 22 4455.',
                      style: AppTextStyles.caption,
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

/// "AGENT APP" pill under the logo.
class _AgentChip extends StatelessWidget {
  const _AgentChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Text(
        'AGENT APP',
        style: AppTextStyles.label.copyWith(
          color: AppColors.primaryDark,
          letterSpacing: 0.12 * 11,
          height: 1,
        ),
      ),
    );
  }
}

/// +254 prefix plus a digits-only local number input.
class _PhoneField extends StatelessWidget {
  const _PhoneField({
    required this.controller,
    required this.maxLength,
    required this.onChanged,
  });

  final TextEditingController controller;
  final int maxLength;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 58),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.borderStrong),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0A1A1A1A), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              '+254',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const VerticalDivider(
            width: 1,
            thickness: 1,
            indent: 12,
            endIndent: 12,
            color: AppColors.border,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(maxLength),
              ],
              cursorColor: AppColors.primary,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 18,
                letterSpacing: 0.9,
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                hintText: '712345678',
                hintStyle: TextStyle(color: AppColors.textDisabled),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
