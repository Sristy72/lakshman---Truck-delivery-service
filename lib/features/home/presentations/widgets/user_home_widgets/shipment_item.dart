import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/features/home/models/shipment_model.dart';
import 'package:get/get.dart';

import '../../../../delivery_details/data/services/geocoding_service.dart';
import '../../../../delivery_details/presentation/screens/delivery_details_screen.dart';
import '../../../domain/entities/load_entity.dart';

class ShipmentItem extends StatefulWidget {
  final Shipment? shipment;
  final LoadEntity? load;

  const ShipmentItem({super.key, this.shipment, this.load})
    : assert(
        shipment != null || load != null,
        'Either shipment or load must be provided',
      );

  @override
  State<ShipmentItem> createState() => _ShipmentItemState();
}

class _ShipmentItemState extends State<ShipmentItem> {
  late GeocodingService _geocodingService;
  String _pickupAddress = '';
  String _deliveryAddress = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _geocodingService = GeocodingService();
    _resolveAddresses();
  }

  Future<void> _resolveAddresses() async {
    try {
      final pickupLocation = widget.load?.pickupLocation ?? widget.shipment?.origin ?? '';
      final deliveryLocation = widget.load?.deliveryLocation ?? widget.shipment?.destination ?? '';

      debugPrint('🌍 Starting parallel address resolution...');
      debugPrint('   Pickup: $pickupLocation');
      debugPrint('   Delivery: $deliveryLocation');

      // Fetch ALL addresses in parallel
      // The service has built-in retries, so we wait for real results
      final results = await Future.wait(
        [
          _geocodingService.getAddressFromLatLng(pickupLocation),
          _geocodingService.getAddressFromLatLng(deliveryLocation),
        ],
        eagerError: false,
      );

      debugPrint('✅ All addresses resolved simultaneously');
      debugPrint('   Pickup: ${results[0].formattedAddress}');
      debugPrint('   Delivery: ${results[1].formattedAddress}');

      // Update UI with ALL addresses at once - only if we got REAL addresses
      if (mounted) {
        final pickupAddr = results[0].formattedAddress.trim();
        final deliveryAddr = results[1].formattedAddress.trim();
        
        // Check if addresses are valid (not empty and not just coordinates)
        final hasValidPickup = pickupAddr.isNotEmpty && !_isJustCoordinates(pickupAddr);
        final hasValidDelivery = deliveryAddr.isNotEmpty && !_isJustCoordinates(deliveryAddr);
        
        if (hasValidPickup && hasValidDelivery) {
          // Got real addresses - update UI
          setState(() {
            _pickupAddress = pickupAddr;
            _deliveryAddress = deliveryAddr;
            _isLoading = false;
          });
        } else {
          // Retry if we didn't get real addresses
          debugPrint('⚠️ Got incomplete addresses, retrying...');
          debugPrint('   Pickup valid: $hasValidPickup');
          debugPrint('   Delivery valid: $hasValidDelivery');
          await Future.delayed(const Duration(seconds: 1));
          return await _resolveAddresses();
        }
      }
    } catch (e) {
      debugPrint('❌ Error resolving addresses: $e');
      if (mounted) {
        // Retry on error
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          return await _resolveAddresses();
        }
      }
    }
  }

  /// Check if string is just raw coordinates (lat,lng format)
  bool _isJustCoordinates(String address) {
    final pattern = RegExp(r'^\-?\d+\.?\d*\s*,\s*\-?\d+\.?\d*$');
    return pattern.hasMatch(address);
  }

  Widget _buildSkeletonLoader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SkeletonLine(width: double.infinity, height: 10),
        const SizedBox(height: 6),
        _SkeletonLine(width: 100, height: 10),
        const SizedBox(height: 8),
        _SkeletonLine(width: double.infinity, height: 10),
        const SizedBox(height: 6),
        _SkeletonLine(width: 120, height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine which data to use
    final String title = widget.load?.title ?? widget.shipment?.title ?? '';
    final String description = widget.load?.description ?? widget.shipment?.description ?? '';

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
          final id = widget.load?.id ?? '';
          if (id.isNotEmpty) {
            Get.to(() => DeliveryDetailsScreen(), arguments: id);
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
              
              // Address section (2/4 = 50%)
              Expanded(
                flex: 2,
                child: _isLoading
                    ? _buildSkeletonLoader()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pickup address (max 2 lines)
                          Text(
                            'From: ${_pickupAddress.isEmpty ? "N/A" : _pickupAddress}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 4),
                          
                          // Delivery address (max 2 lines)
                          Text(
                            'To: ${_deliveryAddress.isEmpty ? "N/A" : _deliveryAddress}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
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

// Skeleton loader widget for shimmer effect
class _SkeletonLine extends StatefulWidget {
  final double width;
  final double height;

  const _SkeletonLine({required this.width, required this.height});

  @override
  State<_SkeletonLine> createState() => _SkeletonLineState();
}

class _SkeletonLineState extends State<_SkeletonLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(_animation.value),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }
}
