import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/features/delivery_details/presentation/screens/delivery_details_screen.dart';
import 'package:flutter_lakshman1020/features/home/domain/entities/load_entity.dart';
import 'package:get/get.dart';

/// Optimized ShipmentItem for company running loads screen
/// - No automatic geocoding (shows lat/long directly)
/// - Faster rendering
/// - Optional lazy geocoding on demand
class OptimizedShipmentItem extends StatelessWidget {
  final LoadEntity load;
  final bool showRawCoordinates;

  const OptimizedShipmentItem({
    super.key,
    required this.load,
    this.showRawCoordinates = true,
  });

  /// Format coordinates to be more readable
  String _formatCoordinates(String latLng) {
    try {
      final parts = latLng.split(',').map((s) => s.trim()).toList();
      if (parts.length >= 2) {
        final lat = double.tryParse(parts[0]);
        final lng = double.tryParse(parts[1]);
        if (lat != null && lng != null) {
          // Format to 4 decimal places for readability
          return '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
        }
      }
    } catch (e) {
      debugPrint('Error formatting coordinates: $e');
    }
    return latLng;
  }

  @override
  Widget build(BuildContext context) {
    final String title = load.title;
    final String description = load.description;
    final String pickupLocation = load.pickupLocation;
    final String deliveryLocation = load.deliveryLocation;

    return Card(
      elevation: 0,
      color: TColors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: TColors.personalBackground, width: 2.0),
      ),
      child: InkWell(
        onTap: () {
          if (load.id.isNotEmpty) {
            Get.to(() => DeliveryDetailsScreen(), arguments: load.id);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leading icon
              SizedBox(
                width: 32,
                height: 32,
                child: Image.asset('assets/images/frame.png', fit: BoxFit.contain),
              ),
              const SizedBox(width: 12),
              
              // Details section (2/4 = 50%)
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title (max 2 lines)
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    
                    // Description (max 1 line to keep space)
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              
              // Location section (2/4 = 50%) - Shows coordinates directly
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pickup location (max 2 lines)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.trip_origin, size: 12, color: Colors.green),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _formatCoordinates(pickupLocation),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    
                    // Delivery location (max 2 lines)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on, size: 12, color: Colors.red),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _formatCoordinates(deliveryLocation),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
