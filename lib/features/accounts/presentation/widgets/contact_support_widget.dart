// import 'package:flutter/material.dart';
// import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
// import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
// import 'package:flutter_lakshman1020/core/widgets/primary_button.dart';

// class ContactSupportWidget extends StatelessWidget {
//   final String title; // AppBar Title
//   final String heading; // Bold Heading
//   final String subText; // Subtitle
//   final String buttonText; // Button Text
//   final VoidCallback onPressed;

//   const ContactSupportWidget({
//     super.key,
//     required this.title,
//     required this.heading,
//     required this.subText,
//     required this.buttonText,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       appBar: AppBar(
//         title: Text(title),
//         backgroundColor: TColors.white1,
//         foregroundColor: TColors.deliveryDetails,
//         elevation: 0,
//         bottom: const PreferredSize(
//           preferredSize: Size.fromHeight(1.0),
//           child: Divider(height: 0, thickness: 1, color: TColors.borderButton),
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 heading,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w700,
//                   color: TColors.deliveryDetails,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 subText,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w400,
//                   color: TColors.deliveryDetails,
//                 ),
//               ),
//               const SizedBox(height: 24),

//               context.primaryButton(
//                 text: "Contact Support",
//                 width: double.infinity,
//                 height: 51,
//                 backgroundColor: TColors.primary,
//                 textColor: TColors.account,
//                 borderRadius: 8.0,
//                 onPressed: () {
//                   // if (_formKey.currentState?.validate() ?? false) {
//                   //   ScaffoldMessenger.of(context).showSnackBar(
//                   //     const SnackBar(
//                   //       content: Text('Password reset successful'),
//                   //     ),
//                   //   );
//                   // Get.back();
//                 },
//               ),
//               // SizedBox(
//               //   width: 180,
//               //   height: 44,

//               //   child: ElevatedButton(
//               //     onPressed: onPressed,
//               //     style: ElevatedButton.styleFrom(
//               //       backgroundColor: Colors.blue,
//               //       shape: RoundedRectangleBorder(
//               //         borderRadius: BorderRadius.circular(6),
//               //       ),
//               //     ),
//               //     child: Text(
//               //       buttonText,
//               //       style: const TextStyle(color: Colors.white, fontSize: 16),
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/core/widgets/primary_button.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';

class ContactSupportWidget extends StatelessWidget {
  final String title; // AppBar Title
  final String heading; // Bold Heading
  final String subText; // Subtitle
  final String buttonText; // Button Text
  final VoidCallback onPressed;

  const ContactSupportWidget({
    super.key,
    required this.title,
    required this.heading,
    required this.subText,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        title: title,
        titleCenter: true,

        onBack: () => Navigator.pop(context), // back button works
      ),

      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          const SizedBox(height: 20),

          Text(
            heading,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: TColors.deliveryDetails,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: TColors.deliveryDetails,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Container(
              width: 166,
              height: 35,
              child: context.primaryButton(
                text: buttonText,
                backgroundColor: TColors.primary,
                textColor: TColors.account,
                borderRadius: 4.0,
                onPressed: onPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
