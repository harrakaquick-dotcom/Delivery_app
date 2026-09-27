import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../core/widgets/section_label.dart';
import '../../data/sample_support.dart';
import '../../domain/entities/chat_message.dart';

/// Support: issue first, so the fleet desk opens with context.
class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key, this.orderId});

  /// Order the issue is about, e.g. `#HRK-48213`; omitted when opened from a tab.
  final String? orderId;

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _input = TextEditingController();
  final List<ChatMessage> _messages = [...sampleThread];

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _send() {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(
        ChatMessage(text: text, fromAgent: true, stamp: 'You · now'),
      );
      _input.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderId = widget.orderId;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel(
                    orderId == null ? 'Support' : 'Support · order $orderId',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'What went wrong?',
                    style: AppTextStyles.headingLarge.copyWith(
                      fontSize: 24,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final issue in sampleIssues)
                        _IssueChip(
                          label: issue,
                          onTap: () => setState(() => _input.text = issue),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                children: [for (final m in _messages) _Bubble(message: m)],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Composer(controller: _input, onSend: _send),
                  const SizedBox(height: 9),
                  SecondaryButton(
                    label: 'Back to the drop',
                    height: 46,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Outlined quick-pick pill.
class _IssueChip extends StatelessWidget {
  const _IssueChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      shape: const StadiumBorder(
        side: BorderSide(color: AppColors.borderStrong),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.titleSmall.copyWith(fontSize: 12, height: 1),
          ),
        ),
      ),
    );
  }
}

/// A chat bubble with its caption; the rider's are ink, the desk's are white.
class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final mine = message.fromAgent;
    final radius = mine
        ? const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(6),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(20),
          );
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: mine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * 0.8,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
              decoration: BoxDecoration(
                color: mine ? AppColors.ink : AppColors.card,
                borderRadius: radius,
                border: mine ? null : Border.all(color: AppColors.border),
              ),
              child: Text(
                message.text,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 13,
                  height: 1.55,
                  color: mine ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message.stamp.toUpperCase(),
            style: AppTextStyles.chip.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 0.8,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pill text field with a red Send button.
class _Composer extends StatelessWidget {
  const _Composer({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 6, 6, 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onSend(),
              cursorColor: AppColors.primary,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                hintText: 'Type a message…',
                hintStyle: TextStyle(color: AppColors.textTertiary),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 9),
          FilledButton(
            onPressed: onSend,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(0, 44),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: const StadiumBorder(),
              textStyle: AppTextStyles.chip.copyWith(
                fontSize: 12,
                letterSpacing: 0.6,
              ),
            ),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
