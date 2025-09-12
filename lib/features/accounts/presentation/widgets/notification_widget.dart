import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';

class NotificationWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const NotificationWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + Subtitle
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: TColors.deliveryDetails,
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: TColors.grey2,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Toggle Switch (stateless, controlled externally)
              Transform.scale(
                scale: .6,
                child: Switch(
                  value: value,
                  onChanged: onChanged, // just forward callback
                  activeColor: TColors.primary, // knob color
                  activeTrackColor: TColors.personalBackground, // background when ON
                  inactiveThumbColor: TColors.white,
                  inactiveTrackColor: TColors.personalBackground,
                  trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
                  // knob color when OFF
                ),
              ),
            ],
          ),
        ),

        // Divider
        const Divider(height: 0.8, color: TColors.grey1, thickness: 1),
      ],
    );
  }
}
