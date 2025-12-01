import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:get/get.dart';

import '../../../home/presentations/controllers/load_controller.dart';

class PendingRequestFilter extends StatefulWidget {
  const PendingRequestFilter({super.key});

  @override
  State<PendingRequestFilter> createState() => _PendingRequestFilterState();
}

class _PendingRequestFilterState extends State<PendingRequestFilter> {
  final controller = Get.find<LoadController>();
  int selectedIndex = 0;
  final filters = ["All", "Assign price", "Assign driver"];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(filters.length, (index) {
        final isSelected = index == selectedIndex;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
         
              controller.filterLoads(filters[index]);
            },

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? TColors.driverNavigation : TColors.white,
                  borderRadius: isSelected
                      ? BorderRadius.circular(4)
                      : BorderRadius.circular(4),
                  border: Border.all(
                    color: TColors.driverNavigation,
                    width: 2.0,
                  ),
                ),
                child: Text(
                  filters[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected
                        ? TColors.activityColor
                        : TColors.activityColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
