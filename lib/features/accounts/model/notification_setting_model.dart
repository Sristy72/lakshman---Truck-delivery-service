class NotificationSettingModel {
  final String title;
  final String subtitle;
  final bool isEnabled;

  NotificationSettingModel({
    required this.title,
    required this.subtitle,
    required this.isEnabled,
  });

  // 🔹 copyWith method
  NotificationSettingModel copyWith({
    String? title,
    String? subtitle,
    bool? isEnabled,
  }) {
    return NotificationSettingModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
