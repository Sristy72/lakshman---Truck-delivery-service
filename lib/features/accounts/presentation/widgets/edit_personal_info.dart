import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_text.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/widgets/text_field.dart';

import '../../../../core/constants/app_images.dart';

class EditPersonalInfo extends StatefulWidget {
  final String name;
  final String email;
  final String mobile;
  final String address;
  final String dateOfBirth;
  final String nationality;

  // Add a callback to provide controllers if needed
  final void Function(TextEditingController nameController,
      TextEditingController emailController,
      TextEditingController mobileController,
      TextEditingController addressController,
      TextEditingController dobController,
      TextEditingController nationalityController)? onControllersReady;

  const EditPersonalInfo({
    super.key,
    required this.name,
    required this.email,
    required this.mobile,
    required this.address,
    required this.dateOfBirth,
    required this.nationality,
    this.onControllersReady,
  });

  @override
  State<EditPersonalInfo> createState() => _EditPersonalInfoState();
}

class _EditPersonalInfoState extends State<EditPersonalInfo> {
  late TextEditingController _nameTEController;
  late TextEditingController _emailTEController;
  late TextEditingController _mobileTEController;
  late TextEditingController _addressTEController;
  late TextEditingController _dateOfBirthTEController;
  late TextEditingController _nationalityTEController;

  @override
  void initState() {
    super.initState();
    _nameTEController = TextEditingController(text: widget.name);
    _emailTEController = TextEditingController(text: widget.email);
    _mobileTEController = TextEditingController(text: widget.mobile);
    _addressTEController = TextEditingController(text: widget.address);
    _dateOfBirthTEController = TextEditingController(text: widget.dateOfBirth);
    _nationalityTEController = TextEditingController(text: widget.nationality);

    // Send controllers to parent if callback exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onControllersReady != null) {
        widget.onControllersReady!(
          _nameTEController,
          _emailTEController,
          _mobileTEController,
          _addressTEController,
          _dateOfBirthTEController,
          _nationalityTEController,
        );
      }
    });
  }

  @override
  void dispose() {
    _nameTEController.dispose();
    _emailTEController.dispose();
    _mobileTEController.dispose();
    _addressTEController.dispose();
    _dateOfBirthTEController.dispose();
    _nationalityTEController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          CustomText('Name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: TColors.grey)),
          const SizedBox(height: 8),
          CustomTextField(label: 'Name', controller: _nameTEController),
          const SizedBox(height: 16),

          // Email
          CustomText('Email', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: TColors.grey)),
          const SizedBox(height: 8),
          CustomTextField(label: 'Email', controller: _emailTEController),
          const SizedBox(height: 16),

          // Mobile & Date of Birth
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText('Mobile', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: TColors.grey)),
                    const SizedBox(height: 8),
                    CustomTextField(
                      label: 'Mobile',
                      controller: _mobileTEController,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: TColors.textfieldPrefixIconBackground,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(AppImages.flag, height: 20, width: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText('Date of birth', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: TColors.grey)),
                    const SizedBox(height: 8),
                    CustomTextField(
                      label: 'Date of birth',
                      controller: _dateOfBirthTEController,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: TColors.textfieldPrefixIconBackground,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(AppImages.calendar, height: 20, width: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Address & Nationality
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText('Address', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: TColors.grey)),
                    const SizedBox(height: 8),
                    CustomTextField(
                      label: 'Address',
                      controller: _addressTEController,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: TColors.textfieldPrefixIconBackground,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(AppImages.location, height: 20, width: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText('Nationality', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: TColors.grey)),
                    const SizedBox(height: 8),
                    CustomTextField(label: 'Nationality', controller: _nationalityTEController),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
