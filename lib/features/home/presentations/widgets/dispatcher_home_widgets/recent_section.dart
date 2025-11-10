import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/features/home/presentations/screens/pending_request_screen.dart';
import 'package:flutter_lakshman1020/features/others/presentation/screen/pending_req_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class RecentSection extends StatelessWidget {
  const RecentSection();

  @override
  Widget build(BuildContext context) {
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

        // Recent cards list
        Column(
          children: const [
            _RecentCard(id: "#load_45982", subtitle: "Medical equipment..."),
            SizedBox(height: 8),
            _RecentCard(id: "#load_45982", subtitle: "Medical equipment..."),
            SizedBox(height: 8),
            _RecentCard(id: "#load_45982", subtitle: "Medical equipment..."),
          ],
        ),
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
