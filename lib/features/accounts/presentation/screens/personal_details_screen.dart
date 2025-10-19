import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/features/accounts/data/models/fetch_profile_response_model.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_images.dart';
import '../../controller/account_controller.dart';
import '../widgets/personal details.dart';
import 'personal_edit_screen.dart';

class PersonalDetailsScreen extends StatelessWidget {
  const PersonalDetailsScreen({super.key, required String name, required String email, required String mobile, required String dateOfBirth, required String address, required String nationality, required Avatar avatar});

  @override
  Widget build(BuildContext context) {
    final accountController = Get.find<AccountController>();

    return Obx(() {
      final user = accountController.userInfo.value;

      if (user == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return AppScaffold(
        appBar: CustomAppBar(
          onBack: Get.back,
          title: 'Personal details',
          titleCenter: true,
          titleColor: TColors.deliveryDetails,
          buttonTitle: 'Edit',
            onActionPressed: () {
              final user = accountController.userInfo.value!;
              Get.to(
                    () => PersonalEditScreen(
                  name: user.name,
                  email: user.email,
                  mobile: user.phone,
                  address: user.address,
                  dateOfBirth: user.dob,
                  nationality: user.nationality,
                  avatarUrl: user.avatar.url ?? '',
                ),
              );
            },
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.only(left: 107, right: 108, top: 35),
                  child: Center(
                    child: SizedBox(
                      height: 160,
                      width: 160,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage: user.avatar.url.isNotEmpty == true
                            ? NetworkImage(user.avatar.url)
                            : AssetImage(AppImages.accountUser) as ImageProvider,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                UserDataList(
                  userValues: [
                    user.name,
                    user.email,
                    user.phone,
                    user.address,
                    user.dob,
                    user.nationality,
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
