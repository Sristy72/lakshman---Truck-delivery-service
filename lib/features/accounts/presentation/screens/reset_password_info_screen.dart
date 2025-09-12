// import 'package:flutter/material.dart';
// import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
// import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
// import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';

// import 'package:flutter_lakshman1020/features/ResetPasswordInfo/widget/reset_info_widget.dart';

// class ResetPasswordInfoScreen extends StatelessWidget {
//   const ResetPasswordInfoScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       appBar: CustomAppBar(title: "Reset Password", titleCenter: true),

//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 32),

//           // Info Card
//           const ResetInfoWidget(
//             title: "How do I reset my password?",
//             description:
//                 "If you’ve forgotten your password or want to \n change it:",
//             steps: [
//               "Go to the Login screen.",
//               "Tap 'Forgot Password?'",
//               "Enter your registered phone number or \n email.",
//               "You’ll receive an OTP (One-Time Password) \n to verify your identity.",
//               "Enter the OTP and set a new password.",
//             ],

//             warningText:
//                 "Make sure your new password is at least 6 \n characters and easy for you to remember, \n but hard for others to guess",
//           ),

//           const SizedBox(height: 16),

//           // Bottom text
//           Row(
//             // mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 "Need more help? ",
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   color: TColors.deliveryDetails,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   // Navigate to support page
//                 },
//                 child: const Text(
//                   "Contact Support",
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: TColors.primary,
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/widgets/FAQ_Items.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/widgets/highlighted_text.dart';
import 'package:get/get.dart';

class ResetPasswordInfoScreen extends StatelessWidget {
  const ResetPasswordInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(title: "Reset Password", titleCenter: true, onBack: Get.back,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),

            // FAQItem replacing ResetInfoWidget
            FAQItem(
              question: "How do I reset my password?",
              description:
                  "If you’ve forgotten your password or want to \nchange it:",
              bulletPoints: const [
                "Go to the Login screen.",
                "Tap 'Forgot Password?'",
                "Enter your registered phone number or \nemail.",
                "You’ll receive an OTP (One-Time Password) \nto verify your identity.",
                "Enter the OTP and set a new password.",
              ],
              questionColor: TColors.deliveryDetails,
              descriptionColor: TColors.deliveryDetails,
              bulletColor: TColors.deliveryDetails,
            ),

            const SizedBox(height: 24),

            // Highlighted Warning Text
            const HighlightedTextBox(
              text:
                  "Make sure your new password is at least 6 characters and easy for you to remember, but hard for others to guess",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 80,
              barHeight: 60,
              barWidth: 4,
            ),

            const SizedBox(height: 24),

            // Bottom text with support
            Row(
              children: [
                const Text(
                  "Need more help? ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: TColors.deliveryDetails,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // TODO: Implement navigation to support page
                  },
                  child: const Text(
                    "Contact Support",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: TColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
