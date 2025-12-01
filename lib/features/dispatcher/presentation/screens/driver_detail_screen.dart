import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverDetailScreen extends StatelessWidget {
  final Map<String, String> driver;

  const DriverDetailScreen({super.key, required this.driver});

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 14)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Personal details",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(driver["image"]!),
              ),
              const SizedBox(height: 30),
              _buildRow("Name", driver["name"]!),
              const Divider(height: 2, color: Colors.grey,),
              const SizedBox(height: 20),
              _buildRow("Mail", driver["email"]!),
              const Divider(height: 1, color: Colors.grey,),
              const SizedBox(height: 20),
              _buildRow("Mobile", driver["phone"]!),
              const Divider(height: 1, color: Colors.grey,),
              const SizedBox(height: 20),
              _buildRow("Address", driver["address"]!),
              const Divider(height: 1, color: Colors.grey,),
              const SizedBox(height: 20),
              _buildRow("Date of Birth", driver["dob"]!),
              const Divider(height: 1, color: Colors.grey,),
              const SizedBox(height: 20),
              _buildRow("Nationality", driver["nationality"]!),
              const SizedBox(height: 100),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.snackbar(
                      "Assigned",
                      "${driver["name"]} has been assigned successfully.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.blue.shade50,
                      colorText: Color(0xFF004DF5),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF004DF5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    "Assign",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
