import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/widgets/personal%20details.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/screens/personal_edit_screen.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_images.dart';

class PersonalDetailsScreen extends StatelessWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        onBack: Get.back,
        title: 'Personal details',
        titleCenter: true,
        titleColor: TColors.deliveryDetails,
        buttonTitle: 'Edit',
        onActionPressed: (){Get.to(PersonalEditScreen());},
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.only(left: 107, right: 108, top: 35),
                child: Center(
                  child: SizedBox(
                    height: 160,
                    width: 160,
                    child: Image.asset(Images.accountUser),
                  ),
                ),
              ),
          
              SizedBox(height: 32,),
              UserDataList(userValues: ['Daniel Gabrel', 'daniel001@gmail.com'],)
            ],
          ),
        ),
      ),
    );
  }
}
