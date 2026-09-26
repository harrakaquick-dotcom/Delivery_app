import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_chip.dart';
import '../../../../core/widgets/section_label.dart';
import '../../data/sample_documents.dart';
import '../../domain/entities/agent_document.dart';

/// Onboarding step 3: document verification; a red chip blocks going online.
class DocsScreen extends StatelessWidget {
  const DocsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 22, 26, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _StepBar(filled: 2, total: 3),
              const SizedBox(height: 18),
              const SectionLabel('Onboarding · step 3 of 3'),
              const SizedBox(height: AppSpacing.sm),
              const Text('Verification', style: AppTextStyles.displayMedium),
              const SizedBox(height: 6),
              const Text(
                'One document still needs uploading before you can go online.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 22),
              for (final doc in sampleDocuments) ...[
                _DocRow(doc: doc),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionLabel('Assigned kit'),
                    SizedBox(height: 5),
                    Text(
                      'Insulated bag · Bike KDJ 442K · Agent ID HRK-2291',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              AppButton(
                label: 'Continue to duty →',
                onPressed: () => Navigator.of(context)
                    .pushNamedAndRemoveUntil(RouteNames.main, (_) => false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Segmented onboarding progress bar.
class _StepBar extends StatelessWidget {
  const _StepBar({required this.filled, required this.total});

  final int filled;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < total; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: i < filled ? AppColors.primary : AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// One document row: type tile, name and meta, status chip.
class _DocRow extends StatelessWidget {
  const _DocRow({required this.doc});

  final AgentDocument doc;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (doc.status) {
      DocumentStatus.verified => (AppColors.secondaryLight, AppColors.secondary, 'Verified'),
      DocumentStatus.inReview => (AppColors.warningLight, AppColors.warningText, 'In review'),
      DocumentStatus.required => (AppColors.primaryLight, AppColors.primaryDark, 'Required'),
    };
    return AppCard(
      radius: AppSpacing.radiusMedium,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: Text(
              doc.ext,
              style: AppTextStyles.chip.copyWith(
                fontSize: 11,
                color: fg,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc.name, style: AppTextStyles.title),
                const SizedBox(height: 2),
                Text(doc.meta, style: AppTextStyles.caption),
              ],
            ),
          ),
          PillChip(
            label,
            background: bg,
            foreground: fg,
            letterSpacing: 0.8,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          ),
        ],
      ),
    );
  }
}
