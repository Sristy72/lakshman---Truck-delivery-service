import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavItemData> items;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(color: Color(0xFFFB2CAFF)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            items.length,
            (index) => _buildNavItem(
              index: index,
              item: items[index],
              isSelected: currentIndex == index,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required NavItemData item,
    required bool isSelected,
  }) {
    final icon = isSelected && item.selectedIcon != null
        ? item.selectedIcon
        : item.icon;

    if (isSelected) {
      return GestureDetector(
        onTap: () {
          onTap(index);
          item.onPressed?.call();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFCFDFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xFF004DF5), size: 20),
              if (item.label != null) ...[
                const SizedBox(width: 6),
                Text(
                  item.label!,
                  style: const TextStyle(
                    color: Color(0xFF004DF5),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        onTap(index);
        item.onPressed?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: const Color(0xFF2F80ED), size: 24),
      ),
    );
  }
}

class NavItemData {
  final IconData icon;
  final IconData? selectedIcon;
  final String? label;
  final VoidCallback? onPressed;

  // final Widget Function(BuildContext)? route;

  NavItemData({
    required this.icon,
    this.selectedIcon,
    this.label,
    this.onPressed,
    // this.route,
  });
}
