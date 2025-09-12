import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/features/accounts/presentation/widgets/edit_personal_info.dart';

import '../../../../core/constants/app_images.dart';

class PersonalEditScreen extends StatelessWidget {
  const PersonalEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        title: 'Personal details',
        titleCenter: true,
        titleColor: TColors.deliveryDetails,
        doneButtonTitle: 'Done',
      ),
      body: Column(
        children: [
          SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.only(left: 107, right: 108, top: 35),
            child: Center(
              child: SizedBox(
                height: 160,
                width: 160,
                child: Stack(
                  children: [
                    Image.asset(Images.accountUser),
                    Positioned(
                      bottom: -80,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: 100,
                        height: 158,
                        decoration: BoxDecoration(
                          color: TColors.white.withOpacity(.9),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, left:25, right: 20),
                          child: Text('Upload Image', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: TColors.uploadImage),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 48,),
          EditPersonalInfo()
        ],
      ),
    );
  }
}
