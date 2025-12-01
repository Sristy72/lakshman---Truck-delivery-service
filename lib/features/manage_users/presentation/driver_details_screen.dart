import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart' show Get;

import '../../../core/widgets/custom_appbar.dart';

class DriverDetailsScreen extends StatelessWidget {
  const DriverDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: "Driver details", titleCenter: true),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 48),
            Center(
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/person_profile.jpg'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 56),
            _driverInformation('Name', 'Michael Ken'),
            const SizedBox(height: 8),
            Divider(color: Color(0xFFDCE4F5), thickness: 1),
            const SizedBox(height: 16),
            _driverInformation('Mail', 'mken001@gmail.com'),
            const SizedBox(height: 8),
            Divider(color: Color(0xFFDCE4F5), thickness: 1),
            const SizedBox(height: 16),
            _driverInformation('Mobile', '+780927384756'),
            const SizedBox(height: 8),
            Divider(color: Color(0xFFDCE4F5), thickness: 1),
            const SizedBox(height: 16),
            _driverInformation('Address', 'K Street, London'),
            const SizedBox(height: 8),
            Divider(color: Color(0xFFDCE4F5), thickness: 1),
            const SizedBox(height: 16),
            _driverInformation('Date of Birth', '18.10.1990'),
            const SizedBox(height: 8),
            Divider(color: Color(0xFFDCE4F5), thickness: 1),
            const SizedBox(height: 16),
            _driverInformation('Nationality', 'British'),
            const SizedBox(height: 64),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size.fromWidth(double.maxFinite),
                backgroundColor: const Color(0xFFCE3131),
                foregroundColor: const Color(0xFFFFFFFF),
                padding: EdgeInsets.symmetric(vertical: 12.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Get.defaultDialog(
                  backgroundColor: Color(0xFFE9EDF5),
                  titlePadding: EdgeInsets.only(top: 16, left: 16, right: 16),
                  title: 'Confirm removal of driver?',
                  titleStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  contentPadding: EdgeInsets.only(
                    top: 4,
                    left: 16,
                    right: 16,
                    bottom: 24,
                  ),
                  middleText: 'This action cannot be undone.',
                  middleTextStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B7280),
                  ),

                  actions: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromWidth(double.maxFinite),
                        backgroundColor: const Color(0xFFCE3131),
                        foregroundColor: const Color(0xFFFFFFFF),
                        padding: EdgeInsets.symmetric(vertical: 12.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Remove', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                    ),
                  ],
                );
              },
              child: Text(
                'Remove',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 33),
          ],
        ),
      ),
    );
  }

  Widget _driverInformation(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Spacer(),
          Text(
            content,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
