import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/features/accounts/controller/image_picker_controller.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/widgets/edit_personal_info.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_images.dart';
import '../../controller/account_controller.dart';
import 'accounts_screen.dart';

class PersonalEditScreen extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String email;
  final String mobile;
  final String address;
  final String dateOfBirth;
  final String nationality;

  const PersonalEditScreen({
    super.key,
    required this.name,
    required this.email,
    required this.mobile,
    required this.address,
    required this.dateOfBirth,
    required this.nationality,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final ImagePickerController imagePickerController = Get.put(ImagePickerController());
    final accountController = Get.find<AccountController>();

    // Controllers for all text fields
    late TextEditingController _nameController;
    late TextEditingController _emailController;
    late TextEditingController _mobileController;
    late TextEditingController _addressController;
    late TextEditingController _dobController;
    late TextEditingController _nationalityController;

    return AppScaffold(
      appBar: CustomAppBar(
        title: 'Personal details',
        titleCenter: true,
        doneButtonTitle: 'Done',
          doneButton: () async {
            try {
              await accountController.updatePersonalInfo(
                imagePickerController.selectedImage.value,
                _nameController.text,
                _emailController.text,
                _mobileController.text,
                _dobController.text,
                _addressController.text,
                _nationalityController.text,
              );
              // No need for Get.back() here; controller handles navigation
            } catch (e) {
              Get.snackbar('Error', 'Failed to update information');
            }
          },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.only(left: 107, right: 108, top: 35),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      Container(
                        color: Colors.white,
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Gallery'),
                              onTap: () {
                                imagePickerController.pickFromGallery();
                                Get.back();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Camera'),
                              onTap: () {
                                imagePickerController.pickFromCamera();
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 160,
                    width: 160,
                    child: Stack(
                      children: [
                        Obx(() {
                          final pickedImage = imagePickerController.selectedImage.value;
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: pickedImage != null
                                ? Image.file(pickedImage, fit: BoxFit.cover, height: 160, width: 160)
                                : (avatarUrl.isNotEmpty
                                ? Image.network(avatarUrl, fit: BoxFit.cover, height: 160, width: 160)
                                : Image.asset(AppImages.accountUser, fit: BoxFit.cover, height: 160, width: 160)),
                          );
                        }),
                        Obx(() {
                          if (imagePickerController.selectedImage.value != null) {
                            return const SizedBox.shrink();
                          }
                          return Positioned(
                            bottom: -80,
                            left: 0,
                            right: 0,
                            child: Container(
                              width: 100,
                              height: 158,
                              decoration: BoxDecoration(
                                color: TColors.white.withOpacity(.9),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.only(top: 20, left: 25, right: 20),
                                child: Text(
                                  'Upload Image',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: TColors.uploadImage,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),

            // 🔹 EditPersonalInfo widget
            EditPersonalInfo(
              name: name,
              email: email,
              mobile: mobile,
              address: address,
              dateOfBirth: dateOfBirth,
              nationality: nationality,
              onControllersReady: (nameC, emailC, mobileC, addressC, dobC, nationalityC) {
                _nameController = nameC;
                _emailController = emailC;
                _mobileController = mobileC;
                _addressController = addressC;
                _dobController = dobC;
                _nationalityController = nationalityC;
              },
            ),
          ],
        ),
      ),
    );
  }
}
