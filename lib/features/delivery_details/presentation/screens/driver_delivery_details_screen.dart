import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';

class DriverDeliveryDetailsScreen extends StatelessWidget {
  final String? loadId;

  const DriverDeliveryDetailsScreen({
    super.key,
    this.loadId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Delivery details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: const Text(
                'Medical Equipment for Students',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Customer Details Card
            _buildDetailRow('Customer Name', 'Daniel Shix'),
            Divider(color: Colors.grey.shade300),
            _buildDetailRow('Mobile', '+7893783679  0'),
            Divider(color: Colors.grey.shade300),
            _buildDetailRow('Pickup Address', 'J street, London'),
            Divider(color: Colors.grey.shade300),
            _buildDetailRow('Delivery Address', 'k street, London'),
            Divider(color: Colors.grey.shade300),
            _buildDetailRow('Delivered Date', '12.10.2025'),
            Divider(color: Colors.grey.shade300),
            _buildDetailRow('Delivered ID', '#ABC5674BG6'),

            const SizedBox(height: 24),

            // Product Details Section
            const Text(
              'Product details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Includes items such as stethoscopes, sphygmomanometers, anatomy kits, lab coats, training dummies, and portable diagnostic tools — typically used by medical, nursing, or paramedic students.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
