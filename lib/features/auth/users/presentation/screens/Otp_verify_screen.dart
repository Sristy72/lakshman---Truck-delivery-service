import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/widgets/primary_button.dart';
import 'package:flutter_lakshman1020/features/auth/users/presentation/controller/auth_controller.dart';
import 'package:get/get.dart';

import 'package:pin_code_fields/pin_code_fields.dart'; // For OTP input field

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, required this.email});
  final String email;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final _authController = Get.find<AuthController>();

  void _submitOtp() {
    FocusScope.of(context).unfocus();
    _authController.verifyOTP(widget.email, _otpController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // AppLogo(images: AppImages.appLogoLandscape, width: 160, height: 160),
                const SizedBox(height: 60),

                Text(
                  "Enter OTP",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Enter the 6-digit code sent to your email",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 30),

                /// Error message (if any)
                // Obx(() {
                //   final error = _authController.errorMessage.value;
                //   if (error.isNotEmpty) {
                //     return FormErrorMessage(message: error);
                //   }
                //   return const SizedBox.shrink();
                // }),
                const SizedBox(height: 20),

                /// OTP INPUT FIELD
                PinCodeTextField(
                  appContext: context,
                  controller: _otpController,
                  length: 6,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  autoDismissKeyboard: true,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 45,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.grey.shade200,
                    selectedFillColor: Colors.white,
                    inactiveColor: Colors.grey,
                    selectedColor: Colors.green,
                    activeColor: Colors.green,
                  ),

                  textStyle: TextStyle(
                    color: TColors.titleColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  cursorColor: Colors.green,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: false,
                  onCompleted: (value) {
                    // You can trigger submit automatically when user finishes typing
                    _submitOtp();
                  },
                ),

                const SizedBox(height: 30),

                /// VERIFY BUTTON
                Obx(
                  () => context.primaryButton(
                    onPressed: _submitOtp,
                    isLoading: _authController.isLoading.value,
                    text: 'Verify Now',
                  ),
                ),

                const SizedBox(height: 20),

                /// RESEND OTP TEXT
                // GestureDetector(
                //   onTap: () => _authController.resend
                //   OTP(widget.email),
                //   child: Text(
                //     "Resend OTP",
                //     style: TextStyle(
                //       fontSize: 12,
                //       fontWeight: FontWeight.w500,
                //       color: AppColors.primaryGreen,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
