import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/core/widgets/primary_button.dart';
import 'package:flutter_lakshman1020/features/delivery_details/presentation/screens/delivery_details_screen.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_icons.dart';
import '../../models/app_text_styles.dart';

class RequestInformationScreen extends StatelessWidget {
  const RequestInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        title: "Request for a truck",
        onBack: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Book Your Trusted Truck",
                  style: TTextStyles.title,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  "Fast, safe, and insured shifting — from medicine to furniture",
                  style: TTextStyles.subtitle,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),

              // Product Title
              _buildTextField(
                label: "Product Title",
                hint: "Ex: Medical Equipment for student..",
              ),
              const SizedBox(height: 16),

              // Description
              _buildTextField(
                label: "Description",
                hint:
                    "Ex: 3 sealed cartons of medical supplies. Fragile and time-sensitive. Handle with care",
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Category
              _buildDropdown(
                label: "Category",
                items: ["Medicine", "Furniture"],
              ),
              const SizedBox(height: 16),

              // Company
              _buildDropdown(label: "Company", items: ["Default", "Company A"]),
              const SizedBox(height: 32),

              // Pickup Location
              _buildTextField(
                label: "Pickup Location",
                hint: "Green Road, Panthopath",
                suffixAsset: AppIcons.location,
              ),
              const SizedBox(height: 12),

              // Delivery Location
              _buildTextField(
                label: "Delivery Location",
                hint: "Sayednagar B block, Vatara",
                suffixAsset: AppIcons.location,
              ),
              const SizedBox(height: 16),

              // Add Stoppage as TextField
              _buildTextField(
                label: "Add Stoppage",
                hint: "Ex: Banani Road No. 11",
                suffixAsset: AppIcons.add,
              ),
              const SizedBox(height: 16),

              // Pickup Time & Date
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: "Pickup Date",
                      hint: "17 Dec 2025",
                      suffixAsset: AppIcons.calendar,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      label: "Pickup Time",
                      hint: "09:00 A.M",
                      suffixAsset: AppIcons.clock,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Special Note
              _buildTextField(
                label: "Special note",
                hint:
                    "This delivery contains fragile and time-sensitive medical supplies. Ensure temperature control if required, avoid…",
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Submit Button
              context.primaryButton(
                text: "Request for a Truck",
                onPressed: () {
                  Get.to(() => DeliveryDetailsScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    String? suffixAsset,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TTextStyles.label),
        const SizedBox(height: 6),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TTextStyles.hint,
            suffixIcon: suffixAsset != null
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(suffixAsset, width: 11, height: 19),
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({required String label, required List<String> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TTextStyles.label),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: items.first,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) {},
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
