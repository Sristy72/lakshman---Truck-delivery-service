import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_images.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_text.dart';
import 'package:flutter_lakshman1020/core/widgets/skeleton_loader.dart';
import 'package:flutter_lakshman1020/features/accounts/controller/account_controller.dart';
import 'package:flutter_lakshman1020/features/auth/users/presentation/controller/auth_controller.dart';
import 'package:flutx_core/core/theme/extensions/string_extension.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import 'contact_support_screen.dart';
import 'personal_details_screen.dart';
import 'settings_screen.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  late AccountController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AccountController>();
    
    // Ensure profile is fetched when screen is opened
    if (controller.userInfo.value == null) {
      controller.fetchProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            height: 500,
            width: double.infinity,
            color: TColors.primary,
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SkeletonProfileHeader(),
                ),
              );
            }

            final user = controller.userInfo.value;

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
                      backgroundImage: (user?.avatar.url.isNotEmpty ?? false)
                          ? NetworkImage(user!.avatar.url)
                          : const AssetImage(AppImages.accountUser)
                                as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomText(
                    user?.name.capitalizeFirstOfEach ?? 'User',
                    style: const TextStyle(
                      color: TColors.account,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CustomText(
                    user?.email.replaceAll('@gmail.com', '') ?? 'No email',
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
                              if (user != null) {
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
                              } else {
                                Get.snackbar(
                                  "No Data",
                                  "Please wait for profile data to load",
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            }),

                            // Show Payment Method only for company users
                            if (user?.role == 'company') ...[
                              Divider(color: TColors.grey2.withOpacity(.4)),
                              _buildMenuItem(
                                AppImages.paymentMethod,
                                'Payment Method',
                                () {},
                              ),
                            ],

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
