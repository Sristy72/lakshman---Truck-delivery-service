import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class HighlightedTextBox extends StatelessWidget {
  final String text;

  final double fontSize;
  final FontWeight fontWeight;
  final double barHeight;
  final double barWidth;
  final double height;

  const HighlightedTextBox({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.barHeight = 54,
    this.barWidth = 4,
    this.height = 70,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Row(
        children: [
          Container(
            height: barHeight,
            width: barWidth,
            decoration: BoxDecoration(
              color: TColors.red,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: TColors.deliveryDetails,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
