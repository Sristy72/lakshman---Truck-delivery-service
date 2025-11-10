import 'package:flutter/material.dart';

class SubscriptionFeatureItem extends StatelessWidget {
  final String title;
  final dynamic value;

  const SubscriptionFeatureItem({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    Widget valueWidget;

    if (value is bool) {
      // Show check icon for true, no icon for false (just empty space)
      valueWidget = value
          ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 20,
            )
          : const SizedBox(width: 20);
    } else if (value is int || value is double) {
      // Show numeric value
      valueWidget = Text(
        value.toString(),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      );
    } else {
      // Show text value (like "Unlimited")
      valueWidget = Text(
        value.toString(),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          valueWidget,
        ],
      ),
    );
  }
}