import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/core/widgets/skeleton_loader.dart';
import 'package:flutter_lakshman1020/features/company_subscription_plans/data/services/stripe_service.dart';
import 'package:get/get.dart';

import '../controllers/delivery_details_controller.dart';
import '../widgets/delivery_info_card.dart' show DeliveryInfoCard;
import '../widgets/delivery_triple_dot.dart';
import '../widgets/products_details_card.dart'; // Adjust import path as needed

class DeliveryDetailsScreen extends StatelessWidget {
  DeliveryDetailsScreen({super.key});

  final _stripeServices = StripeServices();

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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    3,
                    (index) => const SkeletonCircle(size: 32),
                  ),
                ),
                const SizedBox(height: 24),
                ...List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SkeletonLoader(
                      width: double.infinity,
                      height: 120,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          );
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
                    // Show Accept/Reject buttons when orderStatus is 'ask_pending'
                    if (controller.orderStatus.value.toLowerCase() == 'asked') ...[
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
                    // After orderStatus becomes 'asked', show Contact Driver and Pay buttons
                    if (controller.orderStatus.value.toLowerCase() == 'driver_assigned') ...[
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Color(0xffE5EDFF)),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: controller.isCreatingChat.value
                                      ? null
                                      : () => controller.contactDriver(),
                                  child: controller.isCreatingChat.value
                                      ? const SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Contact Driver',
                                          style: TextStyle(color: Colors.black87),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Obx(
                                () => ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff1E66FF),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: controller.isPaymentLoading.value
                                      ? null
                                      : () => _handlePayment(context, controller),
                                  child: controller.isPaymentLoading.value
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
                                          'Pay',
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
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Handle payment flow for the order
  Future<void> _handlePayment(
    BuildContext context,
    DeliveryDetailsController controller,
  ) async {
    try {
      print('🎯 Starting order payment process');

      // Validate that price is available from API
      if (controller.price.value <= 0) {
        print('❌ Price not available from API');
        Get.snackbar(
          'Error',
          'Price information not available. Please try again or contact support.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
        return;
      }

      print('💰 Using price from API: ${controller.price.value}');

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text("Creating payment for \$${controller.price.value.toStringAsFixed(2)}..."),
            ],
          ),
        ),
      );

      // Step 1: Create payment and get client secret
      final clientSecret = await controller.createOrderPayment();

      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();

      if (clientSecret == null || clientSecret.isEmpty) {
        print('❌ Failed to create payment');
        return;
      }

      print('✅ Client secret received: ${clientSecret.substring(0, 20)}...');

      // Show Stripe payment dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Processing payment..."),
            ],
          ),
        ),
      );

      // Step 2: Process payment with Stripe
      final paymentIntentId = await _stripeServices.makePaymentWithClientSecret(
        clientSecret: clientSecret,
      );

      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();

      if (paymentIntentId != null && paymentIntentId.isNotEmpty) {
        print('✅ Payment completed successfully');
        print('🎫 Payment Intent ID: $paymentIntentId');

        // Step 3: Confirm payment with backend
        await controller.confirmPayment(paymentIntentId);

        // Show success message
        Get.snackbar(
          'Payment Successful',
          'Payment of \$${controller.price.value.toStringAsFixed(2)} completed successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
          duration: const Duration(seconds: 4),
        );

        // Refresh load details to get updated status
        if (controller.initialLoadId != null && controller.initialLoadId!.isNotEmpty) {
          await controller.fetchLoadDetailById(controller.initialLoadId!);
        }
      } else {
        print('❌ Payment Intent ID is null');
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Payment Error"),
              content: const Text("Could not retrieve payment information. Please try again."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Payment failed with error: $e');

      // Close any open dialogs
      if (context.mounted) {
        // Try to pop dialogs safely
        try {
          Navigator.of(context).pop();
        } catch (_) {}
      }

      // Show error dialog
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Payment Failed"),
            content: Text(
              "Failed to process payment: ${e.toString()}",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Try Again"),
              ),
            ],
          ),
        );
      }
    }
  }
}
