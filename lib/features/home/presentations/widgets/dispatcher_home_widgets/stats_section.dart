import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _StatCard(
          imagePath: "assets/images/pending_request.png",
          title: "Pending Request",
          value: "24",
          trend: "+15%",
          trendColor: Colors.green,
        ),
        SizedBox(height: 12),
        _StatCard(
          imagePath: "assets/images/ready_to_load.png",
          title: "Ready to Load",
          value: "19",
          trend: "+15%",
          trendColor: Colors.green,
        ),
        SizedBox(height: 12),
        _StatCard(
          imagePath: "assets/images/available_driver.png",
          title: "Available Driver",
          value: "12",
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String value;
  final String? trend;
  final Color? trendColor;

  const _StatCard({
    required this.imagePath,
    required this.title,
    required this.value,
    this.trend,
    this.trendColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: TColors.white1,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Using Image instead of Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 28,
                height: 28,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                if (trend != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    "${trend!} From last week",
                    style: TextStyle(
                      fontSize: 12,
                      color: trendColor ?? Colors.black54,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
