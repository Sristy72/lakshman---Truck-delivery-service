import 'package:flutter/material.dart';
import '../../features/home/models/app_text_styles.dart';


class NotificationTile extends StatelessWidget {
  final String avatar;
  final String title;
  final String subtitle;
  final String time;

  const NotificationTile({
    super.key,
    required this.avatar,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundImage: AssetImage(avatar),
      ),
      title: Text(title, style: TTextStyles.label),
      subtitle: Text(subtitle, style: TTextStyles.hint),
      trailing: Text(time, style: TTextStyles.hint.copyWith(fontSize: 12)),
    );
  }
}
