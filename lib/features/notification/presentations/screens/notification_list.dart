import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_images.dart';
import 'package:flutter_lakshman1020/core/widgets/notification_tile.dart';
import 'package:flutter_lakshman1020/core/constants/app_icons.dart';

class NotificationListScreen extends StatelessWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // future action for setting
            },
            icon: Image.asset(
              AppIcons.notification, // 👉 right side icon from assets
              width: 22,
              height: 22,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        children: const [

          NotificationTile(
            avatar: AppImages.jhon,
            title: "Jhon Alphabet",
            subtitle: "Contact Customer as soon as possible",
            time: "8:45am",
          ),

          SizedBox(width: 16),

          NotificationTile(
            avatar: AppImages.jhon,
            title: "Admin",
            subtitle: "There's a technical error",
            time: "8:45am",
          ),

          SizedBox(width: 16),

          NotificationTile(
            avatar: AppImages.admin,
            title: "Admin",
            subtitle: "There's a technical error",
            time: "8:45am",
          ),

          SizedBox(width: 16),

          NotificationTile(
            avatar: AppImages.admin,
            title: "Admin",
            subtitle: "There's a technical error",
            time: "8:45am",
          ),

          SizedBox(width: 16),

          NotificationTile(
            avatar: AppImages.admin,
            title: "Admin",
            subtitle: "There's a technical error",
            time: "8:45am",
          ),

          SizedBox(width: 16),

          NotificationTile(
            avatar: AppImages.admin,
            title: "Admin",
            subtitle: "There's a technical error",
            time: "8:45am",
          ),
        ],
      ),
    );
  }
}
