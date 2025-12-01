import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/widgets/skeleton_loader.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/user_home_widgets/shipment_filter_tabs.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/user_home_widgets/shipment_item.dart';
import 'package:get/get.dart';

import '../../../home/presentations/bindings/load_binding.dart';
import '../../../home/presentations/controllers/load_controller.dart';

class ShipmentScreen extends StatefulWidget {
  const ShipmentScreen({super.key});

  @override
  State<ShipmentScreen> createState() => _ShipmentScreenState();
}

class _ShipmentScreenState extends State<ShipmentScreen> {
  int currentPage = 1;
  final int itemsPerPage = 8;

  @override
  void initState() {
    super.initState();
    // Initialize bindings if not already initialized
    if (!Get.isRegistered<LoadController>()) {
      LoadBinding().dependencies();
    }
    
    // Fetch loads only if not already loaded (first time or empty)
    final LoadController loadController = Get.find<LoadController>();
    if (loadController.loads.isEmpty) {
      loadController.fetchLoads();
    }
  }

  @override
  Widget build(BuildContext context) {
    final LoadController loadController = Get.find<LoadController>();

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        surfaceTintColor: TColors.white,
        shadowColor: TColors.white1,
        title: const Text("Shipment"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => loadController.refreshLoads(),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const ShipmentFilterTabs(),
                const SizedBox(height: 12),

                // Shipment list with loading/error states
                Expanded(
                  child: Obx(() {
                    if (loadController.isLoading.value) {
                      return ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) => const SkeletonShipmentCard(),
                      );
                    }

                    if (loadController.errorMessage.value.isNotEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              loadController.errorMessage.value,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => loadController.fetchLoads(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (loadController.filteredLoads.isEmpty) {
                      return const Center(child: Text('No shipments found'));
                    }

                    // Calculate pagination
                    final totalItems = loadController.filteredLoads.length;
                    final totalPages = (totalItems / itemsPerPage).ceil();

                    // Ensure currentPage is valid
                    if (currentPage > totalPages && totalPages > 0) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() => currentPage = totalPages);
                      });
                    }

                    final startIndex = (currentPage - 1) * itemsPerPage;
                    final endIndex = (startIndex + itemsPerPage > totalItems)
                        ? totalItems
                        : startIndex + itemsPerPage;

                    final currentLoads = loadController.filteredLoads.sublist(
                      startIndex,
                      endIndex,
                    );

                    return Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: currentLoads
                                .map((load) => ShipmentItem(load: load))
                                .toList(),
                          ),
                        ),

                        // Pagination controls
                        if (totalPages > 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Image.asset(
                                    'assets/images/arrow_back.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  onPressed: currentPage > 1
                                      ? () => setState(() => currentPage--)
                                      : null,
                                ),

                                ...List.generate(totalPages, (index) {
                                  final page = index + 1;
                                  if (page == 1 ||
                                      page == totalPages ||
                                      (page >= currentPage - 1 &&
                                          page <= currentPage + 1)) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: page == currentPage
                                              ? TColors.white1
                                              : Colors.white,
                                          foregroundColor: page == currentPage
                                              ? Colors.black
                                              : Colors.black,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          minimumSize: const Size(24, 24),
                                        ),
                                        onPressed: () =>
                                            setState(() => currentPage = page),
                                        child: Text(page.toString()),
                                      ),
                                    );
                                  } else if (page == currentPage - 2 ||
                                      page == currentPage + 2) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: Text("..."),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }),
                                IconButton(
                                  icon: Image.asset(
                                    'assets/images/arrow_forward.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  onPressed: currentPage < totalPages
                                      ? () => setState(() => currentPage++)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
