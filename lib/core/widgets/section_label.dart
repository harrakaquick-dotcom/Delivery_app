import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';

/// 11px uppercase tracked label used above sections.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: color == null
          ? AppTextStyles.label
          : AppTextStyles.label.copyWith(color: color),
    );
  }
}
