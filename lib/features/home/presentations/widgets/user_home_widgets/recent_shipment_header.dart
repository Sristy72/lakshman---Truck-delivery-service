import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/features/others/presentation/screen/shipment_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';

class RecentShipmentHeader extends StatelessWidget {
  const RecentShipmentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Recent Shipment",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Spacer(),
        TextButton(
          onPressed: () {
            Get.to(() => const ShipmentScreen());
          },
          child: const Text(
            "view more",
            style: TextStyle(color: TColors.primary),
          ),
        ),
      ],
    );
  }
}
