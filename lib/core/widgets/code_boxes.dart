import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// Row of four digit boxes; the next-to-fill box gets a red ring.
class CodeBoxes extends StatelessWidget {
  const CodeBoxes({super.key, required this.code, this.length = 4, this.height = 66});

  final String code;
  final int length;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < length; i++) ...[
          if (i > 0) const SizedBox(width: 11),
          Expanded(
            child: _Box(
              char: i < code.length ? code[i] : '',
              active: code.length == i,
              height: height,
            ),
          ),
        ],
      ],
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({required this.char, required this.active, required this.height});

  final String char;
  final bool active;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
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
