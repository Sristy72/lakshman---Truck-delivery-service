import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/core/widgets/primary_button.dart';
import 'package:get/get.dart';
import '../controllers/delivery_details_controller.dart';
import '../widgets/delivery_info_card.dart' show DeliveryInfoCard;
import '../widgets/delivery_triple_dot.dart';
import '../widgets/products_details_card.dart'; // Adjust import path as needed

class DeliveryDetailsApprovalScreen extends StatelessWidget {
  DeliveryDetailsApprovalScreen({super.key});

  final DeliveryDetailsController controller = Get.put(
    DeliveryDetailsController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Delivery Details"),
      body: Obx(() {
        if (controller.deliveryList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final selectedDelivery =
            controller.deliveryList[controller.selectedIndex.value];
        if (selectedDelivery == null) {}
        // Explicitly cast to Map<String, String> to match the expected type
        final deliveryDetails = Map<String, String>.from(selectedDelivery)
          ..remove('productDescription');

        return Column(
          children: [
            const SizedBox(height: 15),
            Divider(color: Color(0xffDCE4F5), thickness: 1),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TripleZeroIndicator(
                size: 32.0,
                color: Colors.blue,
                currentStep: 1,
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
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: context.secondaryButton(
                              onPressed: () {},
                              btnBG: Color(0xffFFF5F5),
                              text: "Reject",
                              btnTxtColor: Color(0xffE94949),
                              btnBorder: Colors.transparent,
                            ),
                          ),
                          const SizedBox(width: 16), // spacing between buttons
                          Expanded(
                            child: context.primaryButton(
                              onPressed: () {},
                              text: 'Accept',
                            ),
                          ),
                        ],
                      ),
                    ),
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
