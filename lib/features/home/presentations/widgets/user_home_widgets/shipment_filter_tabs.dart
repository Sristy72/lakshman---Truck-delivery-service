import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:get/get.dart';
import '../../controllers/load_controller.dart';

class ShipmentFilterTabs extends StatelessWidget {
  const ShipmentFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = ["All", "Pending", "Processing", "Delivered"];

    // Check if LoadController is registered
    if (!Get.isRegistered<LoadController>()) {
      // Fallback to stateless UI without filtering
      return Row(
        children: List.generate(filters.length, (index) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: index == 0 ? TColors.driverNavigation : TColors.white,
                  borderRadius: index == 0
                      ? BorderRadius.circular(20)
                      : BorderRadius.circular(4),
                  border: Border.all(
                    color: TColors.driverNavigation,
                    width: 2.0,
                  ),
                ),
                child: Text(
                  filters[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: TColors.activityColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }),
      );
    }

    return GetBuilder<LoadController>(
      builder: (controller) {
        return Row(
          children: List.generate(filters.length, (index) {
            final filterValue = filters[index];

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.filterLoads(filterValue);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Obx(() {
                    final isSelected =
                        controller.selectedFilter.value == filterValue;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? TColors.driverNavigation
                            : TColors.white,
                        borderRadius: isSelected
                            ? BorderRadius.circular(20)
                            : BorderRadius.circular(4),
                        border: Border.all(
                          color: TColors.driverNavigation,
                          width: 2.0,
                        ),
                      ),
                      child: Text(
                        filterValue,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: TColors.activityColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
