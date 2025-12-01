import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/features/dispatcher/presentation/controllers/driver_controller.dart';
import 'package:get/get.dart';
import 'driver_detail_screen.dart';

class AvailableDriverScreen extends StatelessWidget {
  const AvailableDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DriverController controller = Get.put(DriverController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Available driver",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Expanded(
                child: Obx(() => ListView.separated(
                  itemCount: controller.drivers.length,
                  separatorBuilder: (_, __) =>
                  const Divider(height: 8, color: Colors.transparent),
                  itemBuilder: (context, index) {
                    final driver = controller.drivers[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(driver["image"]!),
                          radius: 22,
                        ),
                        title: Text(
                          driver["name"]!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded,
                            color: Colors.grey),
                        onTap: () {
                          Get.to(() => DriverDetailScreen(driver: driver));
                        },
                      ),
                    );
                  },
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
