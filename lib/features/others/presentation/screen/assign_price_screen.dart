import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/network/api_client.dart';
import 'package:flutter_lakshman1020/core/network/constants/api_constants.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/core/widgets/primary_button.dart';
import 'package:flutter_lakshman1020/core/widgets/skeleton_loader.dart';
import 'package:flutter_lakshman1020/features/delivery_details/data/services/geocoding_service.dart';
import 'package:flutter_lakshman1020/features/dispatcher/presentation/screens/assign_driver_screen.dart';
import 'package:flutter_lakshman1020/features/home/data/models/load_model.dart';
import 'package:flutter_lakshman1020/features/home/models/shipment_model.dart';
import 'package:flutter_lakshman1020/features/home/presentations/controllers/load_controller.dart';
import 'package:flutter_lakshman1020/features/others/data/models/ask_price_request_model.dart';
import 'package:flutter_lakshman1020/features/others/domain/load_repo.dart';
import 'package:get/get.dart';

class AssignPriceScreen extends StatefulWidget {
  final Shipment shipment;
  final String loadId;

  const AssignPriceScreen({super.key, required this.shipment, required this.loadId});

  @override
  State<AssignPriceScreen> createState() => _AssignPriceScreenState();
}

class _AssignPriceScreenState extends State<AssignPriceScreen> {
  late final AskPriceRepository _loadRepository;
  LoadModel? _loadData;
  bool _isLoadingData = true;
  String? _loadError;
  String? _pickupAddress;
  String? _deliveryAddress;
  bool _isLoadingAddresses = true;

  @override
  void initState() {
    super.initState();
    _loadRepository = Get.find<AskPriceRepository>();
    _fetchLoadDataAndAddresses();
  }

  /// Fetch load data and geocode addresses in parallel for better performance
  Future<void> _fetchLoadDataAndAddresses() async {
    try {
      final apiClient = ApiClient();
      final endpoint = ApiConstants.load.getById(widget.loadId);

      final response = await apiClient.get<Map<String, dynamic>>(
        endpoint,
        fromJsonT: (json) => json as Map<String, dynamic>,
      );

      await response.fold(
        (failure) async {
          setState(() {
            _isLoadingData = false;
            _isLoadingAddresses = false;
            _loadError = 'Failed to load data: ${failure.message}';
          });
          debugPrint('❌ Failed to fetch load data: ${failure.message}');
        },
        (success) async {
          final data = success.data;
          final load = LoadModel.fromJson(data);
          
          // Update load data immediately
          setState(() {
            _loadData = load;
            _isLoadingData = false;
          });
          
          debugPrint('✅ Load data fetched successfully: ${load.title}');
          
          // Fetch addresses in parallel
          await _geocodeAddresses(load);
        },
      );
    } catch (e) {
      setState(() {
        _isLoadingData = false;
        _isLoadingAddresses = false;
        _loadError = 'Error: $e';
      });
      debugPrint('❌ Exception fetching load data: $e');
    }
  }

  Future<void> _geocodeAddresses(LoadModel load) async {
    try {
      final geocodingService = GeocodingService();
      
      debugPrint('🔄 Starting parallel address geocoding with retries...');
      final startTime = DateTime.now();
      
      // Geocode both addresses in parallel
      final results = await Future.wait([
        geocodingService.getAddressFromLatLng(load.pickupLocation),
        geocodingService.getAddressFromLatLng(load.deliveryLocation),
      ]);
      
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      
      final pickupAddr = results[0].formattedAddress.trim();
      final deliveryAddr = results[1].formattedAddress.trim();
      
      // Check if we got valid addresses (not empty and not just coordinates)
      final hasValidPickupAddr = pickupAddr.isNotEmpty && !_isJustCoordinates(pickupAddr);
      final hasValidDeliveryAddr = deliveryAddr.isNotEmpty && !_isJustCoordinates(deliveryAddr);
      
      if (!hasValidPickupAddr || !hasValidDeliveryAddr) {
        // If either address failed, retry after a short delay
        debugPrint('⚠️ Got incomplete addresses, retrying in 1 second...');
        debugPrint('   Pickup: ${hasValidPickupAddr ? pickupAddr : "PENDING"}');
        debugPrint('   Delivery: ${hasValidDeliveryAddr ? deliveryAddr : "PENDING"}');
        await Future.delayed(const Duration(seconds: 1));
        return await _geocodeAddresses(load); // Retry recursively
      }
      
      setState(() {
        _pickupAddress = pickupAddr;
        _deliveryAddress = deliveryAddr;
        _isLoadingAddresses = false;
      });
      
      debugPrint('✅ Addresses geocoded in ${duration.inMilliseconds}ms');
      debugPrint('✅ Pickup Address: $_pickupAddress');
      debugPrint('✅ Delivery Address: $_deliveryAddress');
    } catch (e) {
      setState(() {
        _isLoadingAddresses = false;
      });
      debugPrint('⚠️ Error geocoding addresses: $e');
    }
  }

  /// Check if string is just raw coordinates (lat,lng format)
  bool _isJustCoordinates(String address) {
    final pattern = RegExp(r'^\-?\d+\.?\d*\s*,\s*\-?\d+\.?\d*$');
    return pattern.hasMatch(address);
  }

  @override
  Widget build(BuildContext context) {
    final shipment = widget.shipment;
    final isAccepted = _loadData?.orderStatus.toLowerCase() == 'accepted';
    final buttonTitle = isAccepted ? "Assign Driver" : "Assign Price";
    final screenTitle = isAccepted ? "Assign Driver" : "Assign Price";
    
    return Scaffold(
      appBar: CustomAppBar(title: screenTitle),
      body: _isLoadingData
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLoader(
                    width: double.infinity,
                    height: 200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  const SizedBox(height: 24),
                  const SkeletonText(width: 150, height: 20),
                  const SizedBox(height: 16),
                  ...List.generate(
                    6,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          SkeletonText(width: 100, height: 14),
                          SkeletonText(width: 150, height: 14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : _loadError != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_loadError!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoadingData = true;
                            _isLoadingAddresses = true;
                            _loadError = null;
                          });
                          _fetchLoadDataAndAddresses();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Center(
                          child: Text(
                            _loadData?.title ?? shipment.description,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Customer Name
                        _buildInfoRow("Customer Name", _loadData?.loadBy.name ?? "N/A"),
                        
                        // Phone
                        if (_loadData?.loadBy != null && (_loadData!.loadBy.phone.isNotEmpty))
                          _buildInfoRow("Mobile", _loadData!.loadBy.phone),

                        // Pickup Address (with skeleton loader while geocoding)
                        _buildInfoRow(
                          "Pickup Address",
                          _pickupAddress ?? _loadData?.pickupLocation ?? "",
                          isLoading: _isLoadingAddresses,
                        ),

                        // Delivery Address (with skeleton loader while geocoding)
                        _buildInfoRow(
                          "Delivery Address",
                          _deliveryAddress ?? _loadData?.deliveryLocation ?? "",
                          isLoading: _isLoadingAddresses,
                        ),

                        // Delivery Date
                        if (_loadData?.pickupDate != null)
                          _buildInfoRow(
                            "Delivered Date",
                            _formatDate(_loadData!.pickupDate),
                          ),

                        // Delivered ID
                        _buildInfoRow("Delivered ID", "#${widget.loadId.toUpperCase().substring(widget.loadId.length > 8 ? widget.loadId.length - 8 : 0)}"),
                        
                        // Load Category
                        _buildInfoRow("Load Category", _loadData?.category ?? "N/A"),

                        // Order Status
                        _buildInfoRow("Order Status", _loadData?.orderStatus.toUpperCase() ?? "N/A"),
                        
                        const SizedBox(height: 24),

                        // Product details section
                        const Text(
                          "Product details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Product description card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xffF5F8FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _loadData?.description ?? shipment.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xff666666),
                              height: 1.5,
                            ),
                          ),
                        ),

                        if (_loadData?.note != null && _loadData!.note.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text(
                            "Additional Notes",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xffF9F9F9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Text(
                              _loadData!.note,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xff666666),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 32),

                        // Dynamic Button based on order status
                        SizedBox(
                          width: double.infinity,
                          child: context.primaryButton(
                            onPressed: () {
                              final loadId = widget.loadId;
                              if (loadId.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Load ID is missing')),
                                );
                                return;
                              }
                              
                              if (isAccepted) {
                                // Show Assign Driver dialog/screen
                                _showAssignDriverDialog(context);
                              } else {
                                // Show Assign Price dialog
                                _showAssignPriceDialog(context);
                              }
                            },
                            text: buttonTitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isLoading = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff666666),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Align(
                    alignment: Alignment.centerRight,
                    child: SkeletonText(width: 200, height: 14),
                  )
                : Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff000000),
                    ),
                    textAlign: TextAlign.right,
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}";
  }

  void _showAssignPriceDialog(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    bool _isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Assign Price'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controller,
                    enabled: !_isLoading,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      hintText: 'Enter amount',
                      prefixText: '\$ ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.of(dialogCtx).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B5DCB),
                  ),
                  onPressed: _isLoading ? null : () async {
                    final text = _controller.text.trim();
                    if (text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter an amount')),
                      );
                      return;
                    }
                    final normalized = text.replaceAll(',', '');
                    final amount = double.tryParse(normalized);
                    if (amount == null || amount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a valid amount')),
                      );
                      return;
                    }

                    // Show loading
                    setState(() => _isLoading = true);

                    try {
                      // Call API
                      final request = AskPriceRequestModel(askPrice: amount);
                      final result = await _loadRepository.askPrice(widget.loadId, request);

                      setState(() => _isLoading = false);

                      result.fold(
                        (failure) {
                          // API call failed
                          debugPrint('❌ Ask price API failed: ${failure.message}');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${failure.message}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                        (success) {
                          // API call success
                          debugPrint('✅ Ask price API success: ${success.data.orderStatus}');
                          Navigator.of(dialogCtx).pop();

                          // Refresh the load data by fetching loads again
                          try {
                            final loadController = Get.find<LoadController>();
                            debugPrint('🔄 Refreshing load data...');
                            // Refresh all loads
                            loadController.fetchLoads();
                          } catch (e) {
                            debugPrint('⚠️ Could not refresh LoadController: $e');
                          }

                          // Show success confirmation
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Price \$${amount.toStringAsFixed(2)} assigned successfully!\nLoad ID: ${widget.loadId}\nStatus: ${success.data.orderStatus}',
                              ),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );

                          // Auto-redirect to pending requests screen after delay
                          Future.delayed(const Duration(seconds: 2), () {
                            if (mounted) {
                              debugPrint('🔙 Redirecting to pending requests screen...');
                              Get.back();
                            }
                          });
                        },
                      );
                    } catch (e) {
                      setState(() => _isLoading = false);
                      debugPrint('❌ Unexpected error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Unexpected error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Assign Price', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAssignDriverDialog(BuildContext context) {
    Get.to(() => AssignDriverScreen(loadId: widget.loadId));
  }
}
