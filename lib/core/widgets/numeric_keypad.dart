import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// Big-key 3x4 keypad (1-9, blank, 0, backspace) for gloves and cracked screens.
class NumericKeypad extends StatelessWidget {
  const NumericKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.keyHeight = 56,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final double keyHeight;

  static const String _backspace = '⌫';
  static const List<List<String>> _rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['', '0', _backspace],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var r = 0; r < _rows.length; r++) ...[
          if (r > 0) const SizedBox(height: 10),
          Row(
            children: [
              for (var c = 0; c < 3; c++) ...[
                if (c > 0) const SizedBox(width: 10),
                Expanded(child: _key(_rows[r][c])),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _key(String k) {
    if (k.isEmpty) return SizedBox(height: keyHeight);
    final radius = BorderRadius.circular(AppSpacing.radiusSmall + 2);
    return Material(
      color: AppColors.surface,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        splashColor: AppColors.primaryLight,
        highlightColor: AppColors.primaryLight,
        onTap: () => k == _backspace ? onBackspace() : onDigit(k),
        child: SizedBox(
          height: keyHeight,
          child: Center(
            child: Text(
              k,
              style: AppTextStyles.headingLarge.copyWith(
                fontSize: 20,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
