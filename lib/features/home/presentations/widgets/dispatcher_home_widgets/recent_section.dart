import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/widgets/skeleton_loader.dart';
import 'package:flutter_lakshman1020/features/home/presentations/screens/pending_request_screen.dart';
import 'package:get/get.dart';

import '../../controllers/load_controller.dart';

class RecentSection extends StatelessWidget {
  const RecentSection();

  @override
  Widget build(BuildContext context) {

    final LoadController loadController = Get.find<LoadController>();
    return Column(
      children: [
        // Header row
        Row(
          children: [
            const Text(
              "Recent",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Get.to(()=> PendingReqScreen1());
              },
              child: const Text(
                "View all",
                style: TextStyle(color: TColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        Obx(() {
          if (loadController.isLoading.value) {
            return Column(
              children: List.generate(
                3,
                (index) => const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: SkeletonListItem(hasLeading: false, lines: 2),
                ),
              ),
            );
          }

          if (loadController.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                loadController.errorMessage.value,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final recentLoads = loadController.loads.take(3).toList();

          if (recentLoads.isEmpty) {
            return const Center(
              child: Text(
                "No recent loads available",
                style: TextStyle(color: Colors.black54),
              ),
            );
          }

          return Column(
            children: recentLoads.map((load) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _RecentCard(
                  id: "#${load.id.substring(load.id.length - 5)}",
                  subtitle: load.description,
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}
class _RecentCard extends StatelessWidget {
  final String id;
  final String subtitle;

  const _RecentCard({required this.id, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: TColors.white1,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFFEAF4FF),
            child: Icon(Icons.local_shipping, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  id,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.assignment_turned_in_outlined,
              size: 16,
              color: Colors.blue,
            ),
            label: const Text("Assign", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
