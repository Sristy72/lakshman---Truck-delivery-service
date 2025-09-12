import 'package:flutter/material.dart';

class FAQItem extends StatelessWidget {
  final String question;
  final String description;
  final List<String> bulletPoints;
  final Color questionColor;
  final Color descriptionColor;
  final Color bulletColor;

  const FAQItem({
    super.key,
    required this.question,
    required this.description,
    required this.bulletPoints,
    required this.questionColor,
    required this.descriptionColor,
    required this.bulletColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question
        Text(
          question,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: questionColor,
          ),
        ),
        const SizedBox(height: 12),

        // Description
        Text(
          description,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: descriptionColor,
          ),
        ),
        const SizedBox(height: 12),

        // Bullet points
        ...bulletPoints.map((point) => _buildBulletPoint(point)).toList(),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• ",
            style: TextStyle(fontSize: 14, color: bulletColor),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: bulletColor),
            ),
          ),
        ],
      ),
    );
  }
}
