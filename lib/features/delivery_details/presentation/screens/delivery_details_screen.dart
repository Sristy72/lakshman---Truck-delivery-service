import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:get/get.dart';
import '../controllers/delivery_details_controller.dart';
import '../widgets/delivery_info_card.dart' show DeliveryInfoCard;
import '../widgets/delivery_triple_dot.dart';
import '../widgets/products_details_card.dart'; // Adjust import path as needed

class DeliveryDetailsScreen extends StatelessWidget {
  DeliveryDetailsScreen({super.key});

  static String? _resolveIdFromArgs() {
    final args = Get.arguments;
    if (args == null) return null;
    if (args is String) return args;
    if (args is Map && args['id'] != null) return args['id'].toString();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      DeliveryDetailsController(initialLoadId: _resolveIdFromArgs()),
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() => CustomAppBar(title: controller.currentTitle.value)),
      ),
      body: Obx(() {
        if (controller.deliveryList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final selectedDelivery =
            controller.deliveryList[controller.selectedIndex.value];
        // Explicitly cast to Map<String, String> to match the expected type
        final deliveryDetails = Map<String, String>.from(selectedDelivery)
          ..remove('productDescription');

        return Column(
          children: [
            const SizedBox(height: 15),
            // Divider(color: Color(0xffDCE4F5), thickness: 1),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Obx(
                () => TripleZeroIndicator(
                  size: 32.0,
                  color: Colors.blue,
                  orderStatus: controller.orderStatus.value,
                  // If user has accepted locally, advance the visual step by 1
                  currentStep:
                      controller.currentStep.value +
                      (controller.accepted.value ? 1 : 0),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DeliveryInfoCard(details: deliveryDetails),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Text(
                        "Product Description",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ProductDetailsCard(
                      description:
                          selectedDelivery['productDescription'] ??
                          'No description available',
                    ),
                    // Show action buttons only when backend orderStatus is 'asked'
                    if (controller.orderStatus.value.toLowerCase() == 'asked' &&
                        !controller.accepted.value) ...[
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.redAccent),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: controller.isActionLoading.value
                                      ? null
                                      : () {
                                          controller.sendPriceAction(
                                            'rejected',
                                          );
                                        },
                                  child: controller.isActionLoading.value
                                      ? const SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Reject',
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Obx(
                                () => ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: controller.isActionLoading.value
                                      ? null
                                      : () {
                                          controller.sendPriceAction(
                                            'accepted',
                                          );
                                        },
                                  child: controller.isActionLoading.value
                                      ? const SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation(
                                              Colors.white,
                                            ),
                                          ),
                                        )
                                      : const Text(
                                          'Accept',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // After accepting, show Contact Driver and Pay buttons
                    if (controller.accepted.value) ...[
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Color(0xffE5EDFF)),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  // TODO: contact driver
                                },
                                child: const Text(
                                  'Contact Driver',
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff1E66FF),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  // TODO: implement pay action
                                },
                                child: const Text(
                                  'Pay',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
