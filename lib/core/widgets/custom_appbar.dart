import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.titleColor = TColors.deliveryDetails,
    this.titleSize = 16,
    this.titleWeight = FontWeight.w600,
    this.iconColor = TColors.grey,
    this.titleCenter = false,
    this.buttonTitle,
    this.onActionPressed, this.doneButtonTitle,
  });

  final String title;
  final String? buttonTitle;
  final String? doneButtonTitle;
  final VoidCallback? onBack;
  final VoidCallback? onActionPressed;
  final Color titleColor;
  final double titleSize;
  final FontWeight titleWeight;
  final Color iconColor;
  final bool titleCenter;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: TColors.white,
      centerTitle: titleCenter,
      leading: IconButton(
        onPressed: onBack,
        icon: Icon(Icons.arrow_back_ios, color: iconColor, size: 16),
      ),

      // only show trailing button if buttonTitle != null
      actions: buttonTitle != null
          ? [
              TextButton(
                onPressed: onActionPressed,
                child: Container(
                  decoration: BoxDecoration(
                    color: TColors.white,
                    border: Border.all(
                      color: TColors.personalBackground,
                      width: 1, // Border thickness
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: Text(
                    buttonTitle!,
                    style: const TextStyle(
                      color: TColors.grey1,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ]
          : (doneButtonTitle != null
                ? [
                    TextButton(
                      onPressed: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: TColors.primary,
                          border: Border.all(
                            color: TColors.personalBackground,
                            width: 1, // Border thickness
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: CustomText(doneButtonTitle!, style: TextStyle(color: TColors.account),),
                        ),
                      ),
                    ),
                  ]
                : null),

      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontWeight: titleWeight,
          fontSize: titleSize,
        ),
      ),

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.grey.shade300, // divider color
          height: 1.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
