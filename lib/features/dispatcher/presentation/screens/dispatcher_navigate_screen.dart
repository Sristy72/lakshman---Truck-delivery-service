import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:get/get.dart';

class DispatcherNavigateScreen extends StatelessWidget {
  const DispatcherNavigateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data matching the image
    final loads = [
      {
        'id': '#load_45982',
        'description': 'Medical equipment.',
        'pickup': 'Chicago, IL',
        'delivery': 'Indianapolis, IN',
      },
      {
        'id': '#load_45982',
        'description': 'Medical equipment.',
        'pickup': 'Chicago, IL',
        'delivery': 'Indianapolis, IN',
      },
      {
        'id': '#load_45982',
        'description': 'Medical equipment.',
        'pickup': 'Chicago, IL',
        'delivery': 'Indianapolis, IN',
      },
      {
        'id': '#load_45982',
        'description': 'Medical equipment.',
        'pickup': 'Chicago, IL',
        'delivery': 'Indianapolis, IN',
      },
      {
        'id': '#load_45982',
        'description': 'Medical equipment.',
        'pickup': 'Chicago, IL',
        'delivery': 'Indianapolis, IN',
      },
      {
        'id': '#load_45982',
        'description': 'Medical equipment.',
        'pickup': 'Chicago, IL',
        'delivery': 'Indianapolis, IN',
      },
      {
        'id': '#load_45982',
        'description': 'Medical equipment.',
        'pickup': 'Chicago, IL',
        'delivery': 'Indianapolis, IN',
      },
      {
        'id': '#load_45982',
        'description': 'Medical equipment.',
        'pickup': 'Chicago, IL',
        'delivery': 'Indianapolis, IN',
      },
      {
        'id': '#load_45982',
        'description': 'Medical equipment.',
        'pickup': 'Chicago, IL',
        'delivery': 'Indianapolis, IN',
      },
      {
        'id': '#load_45982',
        'description': 'Medical equipment.',
        'pickup': 'Chicago, IL',
        'delivery': 'Indianapolis, IN',
      },
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'Navigate',
          onBack: () => Get.back(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: loads.length,
        itemBuilder: (context, index) {
          final load = loads[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFF0F0F0),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Load Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_shipping,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Load details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        load['id']!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        load['description']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                
                // Addresses
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          load['pickup']!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          load['delivery']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
