import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:get/get.dart';

import '../../data/models/subscription_model.dart';
import '../../data/services/stripe_service.dart';
import '../widgets/payment_method_card.dart';
import '../widgets/plan_selection_card.dart';
import 'payment_success_screen.dart';

class PaymentDetailsScreen extends StatefulWidget {
  final SubscriptionPlan plan;
  final String clientSecret;

  const PaymentDetailsScreen({
    super.key,
    required this.plan,
    required this.clientSecret,
  });

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  String selectedPaymentMethod = 'Stripe';
  final StripeServices _stripeServices = StripeServices();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: "Payment details",
          titleCenter: true,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // Plan Selection Card
                  PlanSelectionCard(
                    plan: widget.plan,
                    isSelected: true,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Payment Method Section
                  const Text(
                    "Payment method",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D1D1F),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Payment Method Options
                  PaymentMethodCard(
                    method: 'Stripe',
                    icon: Icons.credit_card,
                    iconColor: const Color(0xFF635BFF),
                    selectedMethod: selectedPaymentMethod,
                    onMethodChanged: (method) {
                      setState(() {
                        selectedPaymentMethod = method;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Renewal Notice
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "We'll notify you a week before your subscription ends so you have a lot of time to renew",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8E8E93),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Section with Price and Subscribe Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Color(0xFFE5E5EA),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "\$ ${widget.plan.price}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D1D1F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isProcessing 
                            ? const Color(0xFF007AFF).withOpacity(0.6)
                            : const Color(0xFF007AFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              "Subscribe now",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processPayment() async {
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
    });

    // Show loading dialog
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

    try {
      print("🎯 Starting payment process - Plan: ${widget.plan.name}");
      print("🔑 Using client secret from backend API");
      
      // Initiate Stripe payment with client secret from backend
      final paymentIntentId = await _stripeServices.makePaymentWithClientSecret(
        clientSecret: widget.clientSecret,
      );
      
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      if (paymentIntentId != null && paymentIntentId.isNotEmpty) {
        print("✅ Payment completed successfully");
        print("🎫 Final Payment Intent ID from Stripe: $paymentIntentId");
        
        // Navigate to payment success screen with paymentIntentId
        if (mounted) {
          Get.offAll(() => PaymentSuccessScreen(paymentIntentId: paymentIntentId));
        }
      } else {
        // Show error if paymentIntentId is null
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Payment Error"),
              content: const Text("Could not retrieve payment intent ID."),
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
      print("❌ Payment failed with error: $e");
      
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();
      
      // Show error dialog
      if (mounted) {
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
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}
