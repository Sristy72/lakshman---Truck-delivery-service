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
      valueWidget = SizedBox(
        width: 20,
        child: value
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              )
            : const SizedBox(width: 20),
      );
    } else if (value is int || value is double) {
      // Show numeric value
      valueWidget = Text(
        value.toString(),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        overflow: TextOverflow.ellipsis,
      );
    } else {
      // Show text value (like "Unlimited")
      valueWidget = Flexible(
        child: Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8), // Add spacing between title and value
          valueWidget,
        ],
      ),
    );
  }
}