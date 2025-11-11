import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/features/home/models/shipment_model.dart';
import 'package:get/get.dart';

import '../../../../delivery_details/data/models/geocoding_address_model.dart';
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
  static const Duration _timeout = Duration(seconds: 3);

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

      // Use timeout to prevent long waits (3 seconds max per address)
      final results = await Future.wait(
        [
          _geocodingService.getAddressFromLatLng(pickupLocation).timeout(
            _timeout,
            onTimeout: () => GeocodingAddressModel(formattedAddress: 'Loading address...'),
          ),
          _geocodingService.getAddressFromLatLng(deliveryLocation).timeout(
            _timeout,
            onTimeout: () => GeocodingAddressModel(formattedAddress: 'Loading address...'),
          ),
        ],
        eagerError: false,
      );

      if (mounted) {
        setState(() {
          _pickupAddress = results[0].formattedAddress;
          _deliveryAddress = results[1].formattedAddress;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error resolving addresses: $e');
      if (mounted) {
        setState(() {
          _pickupAddress = 'Address unavailable';
          _deliveryAddress = 'Address unavailable';
          _isLoading = false;
        });
      }
    }
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
                    ? const Center(
                        child: SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                      )
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
