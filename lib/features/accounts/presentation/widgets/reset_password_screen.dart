// import 'package:flutter/cupertino.dart';
// import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
// import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
//
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/widgets/custom_text.dart';
// import 'highlighted_text.dart';
//
// class ResetPasswordScreen extends StatelessWidget {
//   const ResetPasswordScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       appBar: CustomAppBar(title: 'Reset Password', titleCenter: true),
//       body: SafeArea(
//         child: Column(
//           children: [
//             SizedBox(height: 48),
//             Container(
//               height: 330,
//               decoration: BoxDecoration(
//                 color: TColors.white1,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 12),
//                     Text(
//                       'How do I reset my password?',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: TColors.deliveryDetails,
//                       ),
//                     ),
//
//                     SizedBox(height: 12),
//
//                     Text(
//                       'If you\'ve forgotten your password or want to change it:', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: TColors.grey),
//                     ),
//                     SizedBox(height: 12),
//
//                     _buildBulletPoint('Go to the Login screen.'),
//                     _buildBulletPoint('Tap "Forgot Password?"'),
//                     _buildBulletPoint(
//                       'Enter your registered phone number or email.',
//                     ),
//                     _buildBulletPoint(
//                       'You\'ll receive an OTP (One-Time Password) to verify your identity.',
//                     ),
//                     _buildBulletPoint('Enter the OTP and set a new password.'),
//
//                     // HighlightedTextBox(text: 'Driven by technology. Powered by people. Focused on trust.',height: 70,)
//                     // Container(
//                     //   height: 70,
//                     //   child: Row(
//                     //     children: [
//                     //       Container(
//                     //         height: 54,
//                     //         width: 4,
//                     //         decoration: BoxDecoration(
//                     //           color:
//                     //           borderRadius: BorderRadius.circular(2),
//                     //         ),
//                     //       ),
//                     //       SizedBox(width: 8),
//                     //       Expanded(
//                     //         child: CustomText(
//                     //           'Driven by technology. Powered by people. Focused on trust.',
//                     //           style: TextStyle(
//                     //             fontSize: 16,
//                     //             fontWeight: FontWeight.bold,
//                     //             color: TColors.deliveryDetails,
//                     //           ),
//                     //         ),
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBulletPoint(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(width: 6),
//           const Text('• ', style: TextStyle(fontSize: 16)),
//           Expanded(child: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: TColors.grey1))),
//         ],
//       ),
//     );
//   }
// }
