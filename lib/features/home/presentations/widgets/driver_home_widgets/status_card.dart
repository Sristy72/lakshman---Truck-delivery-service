import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 0,
      color: TColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Status info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Current Status",
                        style: TextStyle(
                          fontSize: 16,
                          color: TColors.activityColor,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: const [
                      Text(
                        "Available",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: TColors.activityColor,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "7 days",
                        style: TextStyle(color: TColors.activityColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            // Toggle switch
          ],
        ),
      ),
    );
  }
}
