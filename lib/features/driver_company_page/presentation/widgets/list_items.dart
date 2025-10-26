import 'package:flutter/material.dart';

class DriverListItem extends StatelessWidget {
  final String name;
  final int deliveryCount;
  final double rating;
  final String imageUrl;

  const DriverListItem({
    super.key,
    required this.name,
    required this.deliveryCount,
    required this.rating,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
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

          // Delivery count column
          Expanded(
            flex: 1,
            child: Text(
              deliveryCount.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF18191A),
              ),
            ),
          ),

          // Rating column
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Text(
                  rating.toString(),
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
    );
  }
}