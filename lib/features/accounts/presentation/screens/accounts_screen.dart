import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/features/auth/users/presentation/controller/auth_controller.dart';
import 'package:flutx_core/core/theme/extensions/string_extension.dart';
import 'package:get/get.dart';
import 'package:flutter_lakshman1020/core/constants/app_images.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_text.dart';
import 'package:flutter_lakshman1020/features/accounts/controller/account_controller.dart';
import '../../../../core/constants/app_colors.dart';
import 'personal_details_screen.dart';
import 'settings_screen.dart';
import 'contact_support_screen.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountController controller = Get.find<AccountController>();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 500,
            width: double.infinity,
            color: TColors.primary,
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final user = controller.userInfo.value;
            if (user == null) {
              return const Center(child: Text("No user data available"));
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  CustomText(
                    'Account',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: TColors.account,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: user.avatar.url.isNotEmpty
                          ? NetworkImage(user.avatar.url)
                          : const AssetImage(AppImages.accountUser)
                                as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomText(
                    user.name.capitalizeFirstOfEach,
                    style: const TextStyle(
                      color: TColors.account,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CustomText(
                    user.email.replaceAll('@gmail.com', ''),
                    style: const TextStyle(color: TColors.white1, fontSize: 16),
                  ),
                  const SizedBox(height: 32),

                  // Menu List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(8),
                      shadowColor: Colors.black.withOpacity(0.15),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: TColors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            _buildMenuItem(AppImages.personal, 'Personal', () {
                              Get.to(
                                () => PersonalDetailsScreen(
                                  name: user.name,
                                  email: user.email,
                                  mobile: user.phone,
                                  address: user.address,
                                  dateOfBirth: user.dob,
                                  nationality: user.nationality,
                                  avatar: user.avatar,
                                ),
                              );
                            }),

                            Divider(color: TColors.grey2.withOpacity(.4)),
                            _buildMenuItem(
                              AppImages.paymentMethod,
                              'Payment Method',
                              () {},
                            ),

                            Divider(color: TColors.grey2.withOpacity(.4)),
                            _buildMenuItem(AppImages.settings, 'Settings', () {
                              Get.to(() => SettingsScreen());
                            }),

                            Divider(color: TColors.grey2.withOpacity(.4)),
                            _buildMenuItem(
                              AppImages.heloCenter,
                              'Help Center',
                              () {
                                Get.to(() => const ContactScreen());
                              },
                            ),

                            Divider(color: TColors.grey2.withOpacity(.4)),
                            _buildMenuItem(AppImages.logout, 'Logout', () {
                              Get.find<AuthController>().logout();
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String image, String title, VoidCallback onTap) {
    final bool isLogout = title == 'Logout';
    return Container(
      decoration: BoxDecoration(
        color: isLogout ? TColors.redLogout : null,
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListTile(
        leading: SizedBox(height: 20, width: 20, child: Image.asset(image)),
        title: Text(
          title,
          style: TextStyle(
            color: TColors.activityColor,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_lakshman1020/core/constants/app_images.dart';
// import 'package:flutter_lakshman1020/core/widgets/custom_text.dart';
// import 'package:flutter_lakshman1020/features/accounts/controller/account_controller.dart';
// import '../../../../core/constants/app_colors.dart';
// import 'personal_details_screen.dart';
// import 'settings_screen.dart';
// import 'contact_support_screen.dart';
//
// class AccountsScreen extends StatelessWidget {
//   const AccountsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final AccountController controller = Get.find<AccountController>();
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: 500,
//             width: double.infinity,
//             color: TColors.primary,
//           ),
//           Obx(() {
//             if (controller.isLoading.value) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             final user = controller.userInfo.value;
//             if (user == null) {
//               return const Center(child: Text("No user data available"));
//             }
//
//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   const SizedBox(height: 40),
//                   CustomText(
//                     'Account',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 24,
//                       color: TColors.account,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   Center(
//                     child: CircleAvatar(
//                       radius: 60,
//                       backgroundImage: user.avatar.url.isNotEmpty
//                           ? NetworkImage(user.avatar.url)
//                           : const AssetImage(AppImages.accountUser)
//                                 as ImageProvider,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   CustomText(
//                     user.name,
//                     style: const TextStyle(
//                       color: TColors.account,
//                       fontSize: 22,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   CustomText(
//                     user.email.replaceAll('@gmail.com', ''),
//                     style: const TextStyle(color: TColors.white1, fontSize: 16),
//                   ),
//                   const SizedBox(height: 32),
//
//                   // Menu List
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Material(
//                       elevation: 6,
//                       borderRadius: BorderRadius.circular(8),
//                       shadowColor: Colors.black.withOpacity(0.15),
//                       child: Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: TColors.white,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Column(
//                           children: [
//                             _buildMenuItem(AppImages.personal, 'Personal', () {
//                               Get.to(
//                                 () => PersonalDetailsScreen(
//                                   name: user.name,
//                                   email: user.email,
//                                   mobile: user.phone,
//                                   address: "${user.address.street}, ${user.address.city}, ${user.address.state}, ${user.address.zipCode}",
//                                   dateOfBirth: user.dob,
//                                   nationality: user.nationality, avatar: user.avatar,
//                                 ),
//                               );
//                             }),
//                             Divider(color: TColors.grey2.withOpacity(.4)),
//                             _buildMenuItem(
//                               AppImages.paymentMethod,
//                               'Payment Method',
//                               () {},
//                             ),
//                             Divider(color: TColors.grey2.withOpacity(.4)),
//                             _buildMenuItem(AppImages.settings, 'Settings', () {
//                               Get.to(() => SettingsScreen());
//                             }),
//                             Divider(color: TColors.grey2.withOpacity(.4)),
//                             _buildMenuItem(
//                               AppImages.heloCenter,
//                               'Help Center',
//                               () {
//                                 Get.to(() => const ContactScreen());
//                               },
//                             ),
//                             Divider(color: TColors.grey2.withOpacity(.4)),
//                             _buildMenuItem(AppImages.logout, 'Logout', () {
//                               // implement logout
//                             }),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMenuItem(String image, String title, VoidCallback onTap) {
//     final bool isLogout = title == 'Logout';
//     return Container(
//       decoration: BoxDecoration(
//         color: isLogout ? TColors.redLogout : null,
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: ListTile(
//         leading: SizedBox(height: 20, width: 20, child: Image.asset(image)),
//         title: Text(
//           title,
//           style: TextStyle(
//             color: TColors.activityColor,
//             fontWeight: FontWeight.w400,
//             fontSize: 16,
//           ),
//         ),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: onTap,
//       ),
//     );
//   }
// }
