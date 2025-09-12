import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
class CheckButtonWithTextDisclaimers extends StatelessWidget {
  const CheckButtonWithTextDisclaimers({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, color: TColors.primary, size: 16),
        SizedBox(width: 7),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: TColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
