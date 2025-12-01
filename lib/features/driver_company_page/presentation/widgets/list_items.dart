import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/model/dariver_model.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/presentation/screens/company_driver_details_screen.dart';
import 'package:get/get.dart';

class DriverListItem extends StatelessWidget {
  final String name;
  final int deliveryCount;
  final double rating;
  final String imageUrl;
  final Driver? driver;

  const DriverListItem({
    super.key,
    required this.name,
    required this.deliveryCount,
    required this.rating,
    required this.imageUrl,
    this.driver,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: driver != null
          ? () {
              Get.to(
                () => CompanyDriverDetailsScreen(driver: driver!),
                transition: Transition.rightToLeft,
              );
            }
          : null,
      child: Container(
        height: 54,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
            color: Color(0xffF2F6FF),
            borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          children: [
            // Name column with profile icon
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  _buildAvatar(),
                  SizedBox(width: 8),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF18191A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    // Check if imageUrl is empty or null or is the default fallback image
    final isValidUrl = imageUrl.isNotEmpty && 
        !imageUrl.contains('assets/images/truck_home.png') &&
        (imageUrl.startsWith('http') || imageUrl.startsWith('https'));

    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFE8F1FF),
        border: Border.all(
          color: Color(0xFFD0E0FF),
          width: 1,
        ),
      ),
      child: isValidUrl
          ? ClipOval(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Color(0xFF219653)),
                      ),
                    ),
                  );
                },
              ),
            )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.person,
        color: Color(0xFF219653),
        size: 18,
      ),
    );
  }
}