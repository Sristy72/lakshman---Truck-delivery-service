import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/features/home/presentations/bindings/load_binding.dart';
import 'package:flutter_lakshman1020/features/home/presentations/controllers/load_controller.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/user_home_widgets/shipment_item.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/company_appbar.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/company_drawer.dart';
import 'package:get/get.dart';

class RunningLoadScreen extends StatefulWidget {
  const RunningLoadScreen({super.key});

  @override
  State<RunningLoadScreen> createState() => _RunningLoadScreenState();
}

class _RunningLoadScreenState extends State<RunningLoadScreen> {
  late LoadController _loadController;

  @override
  void initState() {
    super.initState();
    
    // Register LoadController if not already registered
    if (!Get.isRegistered<LoadController>()) {
      LoadBinding().dependencies();
    }
    
    _loadController = Get.find<LoadController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanyAppbar(),
      drawer: CompanyDrawer(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 16,
                  width: 16,
                  child: Image.asset(
                    'assets/images/running_load_icon.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 8),
                Text("Running load"),
              ],
            ),
            SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                if (_loadController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (_loadController.errorMessage.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _loadController.errorMessage.value,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _loadController.fetchLoads(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final loads = _loadController.loads;

                if (loads.isEmpty) {
                  return const Center(
                    child: Text("No running loads available"),
                  );
                }

                return ListView.builder(
                  itemCount: loads.length,
                  itemBuilder: (context, index) {
                    final load = loads[index];
                    return ShipmentItem(
                      load: load,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
