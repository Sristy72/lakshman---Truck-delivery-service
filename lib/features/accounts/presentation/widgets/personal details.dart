import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';

class UserDataList extends StatelessWidget {
  const UserDataList({super.key, required this.userValues});

  final List<String> userValues; // dynamic values for each row

  @override
  Widget build(BuildContext context) {
    // constant first column
    final List<String> firstColumn = ['Name', 'Mail', 'Mobile', 'Address', 'Date of Birth', 'Nationality'];

    return Column(
      children: List.generate(firstColumn.length, (index) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 8, left: 8, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(firstColumn[index], style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: TColors.deliveryDetails),), // constant name
                  Text(index < userValues.length ? userValues[index] : '', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: TColors.grey)), // dynamic value
                ],
              ),
            ),
            Divider(color: TColors.grey2.withOpacity(.4)),
          ],
        );
      }),
    );
  }
}
