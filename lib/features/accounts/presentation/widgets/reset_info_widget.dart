import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';

class ResetInfoWidget extends StatelessWidget {
  final String title;
  final String description;
  final List<String> steps;
  final String? warningText;

  const ResetInfoWidget({
    super.key,
    required this.title,
    required this.description,
    required this.steps,
    this.warningText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 343,
      width: double.infinity, // takes full width
      constraints: const BoxConstraints(maxWidth: 427), // but max = 427
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColors.grey,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: TColors.borderButton),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: TColors.deliveryDetails,
            ),
          ),
          const SizedBox(height: 32),

          // Description
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: TColors.deliveryDetails,
            ),
          ),
          const SizedBox(height: 32),

          // Steps (scrollable if needed)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: steps
                .map(
                  (step) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      "• $step",
                      style: const TextStyle(
                        fontSize: 14,
                        color: TColors.deliveryDetails,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          // Warning (optional)
          if (warningText != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TColors.white1,
                borderRadius: BorderRadius.circular(6),
                border: const Border(
                  left: BorderSide(color: Colors.red, width: 3),
                ),
              ),
              child: Text(
                warningText!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: TColors.deliveryDetails,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
