import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_images.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_text.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/widgets/text_field.dart';

import '../../../../core/constants/app_colors.dart';

class EditPersonalInfo extends StatelessWidget {
  const EditPersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameTEController = TextEditingController();
    final TextEditingController __emailTEController = TextEditingController();
    final TextEditingController _dateOfBirthTEController =
        TextEditingController();
    final TextEditingController _mobileTEController = TextEditingController();
    final TextEditingController _addressTEController = TextEditingController();
    final TextEditingController _nationalityTEController =
        TextEditingController();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          CustomText(
            'Name',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: TColors.grey,
            ),
          ),
          SizedBox(height: 8),
          CustomTextField(label: 'Name', controller: _nameTEController),
          SizedBox(height: 16),

          // Email
          CustomText(
            'Email',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: TColors.grey,
            ),
          ),
          SizedBox(height: 8),
          CustomTextField(label: 'Email', controller: __emailTEController),
          SizedBox(height: 16),

          // Mobile & Date of Birth
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Mobile',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: TColors.grey,
                      ),
                    ),

                    SizedBox(height: 8),

                    CustomTextField(
                      label: 'Mobile',
                      controller: __emailTEController,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: TColors.textfieldPrefixIconBackground,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              Images.flag,
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 16,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Date of birth',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: TColors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    CustomTextField(
                      label: 'Date of birth',
                      controller: __emailTEController,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: TColors.textfieldPrefixIconBackground,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              Images.calendar,
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Address & Nationality
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Address',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: TColors.grey,
                      ),
                    ),

                    SizedBox(height: 8),

                    CustomTextField(
                      label: 'Address',
                      controller: __emailTEController,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: TColors.textfieldPrefixIconBackground,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              Images.location,
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 16,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Nationality',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: TColors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    CustomTextField(
                      label: 'Nationality',
                      controller: __emailTEController,
                    ),
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
