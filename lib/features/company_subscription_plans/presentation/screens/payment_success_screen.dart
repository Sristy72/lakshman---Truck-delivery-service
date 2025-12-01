import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/features/auth/users/presentation/controller/auth_controller.dart';
import 'package:flutter_lakshman1020/features/company_subscription_plans/data/models/confirm_payment_request_model.dart';
import 'package:flutter_lakshman1020/features/company_subscription_plans/domain/payment_repo.dart';
import 'package:flutter_lakshman1020/features/others/presentation/screen/dashboard_overview_scren.dart';
import 'package:get/get.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String paymentIntentId;

  const PaymentSuccessScreen({
    super.key,
    required this.paymentIntentId,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  final PaymentRepository _paymentRepository = Get.find<PaymentRepository>();
  bool _isConfirming = false;

  Future<void> _confirmPayment() async {
    if (_isConfirming) return;

    setState(() {
      _isConfirming = true;
    });

    try {
      print("🔐 Confirming payment with Payment Intent ID: ${widget.paymentIntentId}");

      final request = ConfirmPaymentRequestModel(
        paymentIntentId: widget.paymentIntentId,
      );

      await _paymentRepository.confirmPayment(request);
      
      print("✅ Payment confirmation API called");

      // Check if this is from signup flow
      try {
        final authController = Get.find<AuthController>();
        if (authController.isSignupFlow.value) {
          // Reset signup flag
          authController.isSignupFlow.value = false;
          print("🎯 Post-signup subscription completed - Redirecting to dashboard");
        }
      } catch (e) {
        print("ℹ️ AuthController not found, continuing to dashboard");
      }

      // Navigate to dashboard
      Get.offAll(DashboardScreen());
    } catch (e) {
      print("❌ Error confirming payment: $e");
      setState(() {
        _isConfirming = false;
      });
      
      // Still navigate to dashboard even if API fails
      Get.offAll(DashboardScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge Icon
            Center(
              child: Center(
                child: Center(
                  child: Image.asset(
                    'assets/icons/Group.png',
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Subscription Activated',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D1D1F),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.email,
                    color: Color(0xFF007AFF),
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  // Use Expanded so the text wraps into two lines within available space
                  const Expanded(
                    child: Text(
                      'Check your Stripe email for your unique code',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8E8E93),
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isConfirming ? null : _confirmPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isConfirming
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
