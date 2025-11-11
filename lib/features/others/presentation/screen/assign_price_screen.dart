import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/core/widgets/primary_button.dart';
import 'package:flutter_lakshman1020/features/home/models/shipment_model.dart';
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

  @override
  void initState() {
    super.initState();
  _loadRepository = Get.find<AskPriceRepository>();
  }

  @override
  Widget build(BuildContext context) {
    final shipment = widget.shipment;
    return Scaffold(
      appBar: CustomAppBar(title: "Assign Price"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  shipment.description,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),

              // Delivery Information Card
              _buildInfoRow("Customer Name", "Daniel Shix"),
              _buildInfoRow("Mobile", "+78937836790"),
              _buildInfoRow("Pickup Address", "J street, London"),
              _buildInfoRow("Delivery Address", "k street, London"),
              _buildInfoRow("Delivered Date", "12.10.2025"),
              _buildInfoRow("Delivered ID", "#ASC56787B06"),
              
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
                child: const Text(
                  "Includes items such as stethoscopes, sphygmomanometers, anatomy kits, lab coats, training dummies, and portable diagnostic tools — typically used by medical, nursing, or paramedic students.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff666666),
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Assign Price Button
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
                    _showAssignPriceDialog(context);
                  },
                  text: 'Assign Price',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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
            child: Text(
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

                          // Show success confirmation
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Price \$${amount.toStringAsFixed(2)} assigned successfully!\nLoad ID: ${widget.loadId}\nStatus: ${success.data.orderStatus}',
                              ),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 3),
                            ),
                          );
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
}
