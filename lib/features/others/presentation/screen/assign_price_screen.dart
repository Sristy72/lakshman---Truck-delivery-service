import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/core/widgets/primary_button.dart';
import 'package:flutter_lakshman1020/features/home/models/shipment_model.dart';

class AssignPriceScreen extends StatelessWidget {
  final Shipment shipment;

  const AssignPriceScreen({super.key, required this.shipment});

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 24),

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
                    // TODO: Implement assign price functionality
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
}
