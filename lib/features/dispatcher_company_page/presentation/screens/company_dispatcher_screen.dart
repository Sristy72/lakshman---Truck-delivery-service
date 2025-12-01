import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/skeleton_loader.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/company_appbar.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/company_drawer.dart';
import 'package:get/get.dart';

import '../../../manage_users/presentation/add_dispatcher_screen.dart';
import '../bindings/dispatcher_binding.dart';
import '../controllers/dispatcher_controller.dart';
import '../widgets/dispatcheer_item.dart';

class CompanyDispatcherScreen extends StatefulWidget {
  const CompanyDispatcherScreen({super.key});

  @override
  State<CompanyDispatcherScreen> createState() =>
      _CompanyDispatcherScreenState();
}

class _CompanyDispatcherScreenState extends State<CompanyDispatcherScreen> {
  late DispatcherController _dispatcherController;

  @override
  void initState() {
    super.initState();
    // Register binding if not already registered
    if (!Get.isRegistered<DispatcherController>()) {
      DispatcherBinding().dependencies();
    }
    _dispatcherController = Get.find<DispatcherController>();
  }

  void _removeDispatcher(String dispatcherId) async {
    // Show confirmation dialog
    final confirmed = await _showRemoveConfirmationDialog();
    
    if (confirmed == true) {
      // Call API to remove dispatcher
      await _dispatcherController.removeDispatcher(dispatcherId);
      
      // Check if removal was successful by checking if error is empty
      if (_dispatcherController.errorMessage.isEmpty) {
        // Show success snackbar
        Get.snackbar(
          'Success',
          'Dispatcher removed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade900,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 2),
        );
      } else {
        // Show error snackbar
        Get.snackbar(
          'Error',
          _dispatcherController.errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  Future<bool?> _showRemoveConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Confirm removal\nof dispatcher?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF18191A),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEB5757),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Remove',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHomeContent() {
    return Obx(() {
      // Loading state
      if (_dispatcherController.isLoading.value) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 6,
          itemBuilder: (context, index) => const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: SkeletonListItem(
              hasLeading: true,
              hasTrailing: true,
              lines: 2,
            ),
          ),
        );
      }

      // Error state
      if (_dispatcherController.errorMessage.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _dispatcherController.errorMessage.value,
                style: const TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _dispatcherController.fetchDispatchers(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      // Empty state
      if (_dispatcherController.dispatchers.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.people_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'No dispatchers found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.to(() => const AddDispatcherScreen()),
                child: const Text('Add First Dispatcher'),
              ),
            ],
          ),
        );
      }

      // Success state with data
      return Column(
        children: [
          // Header with icon and title
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  height: 16,
                  width: 16,
                  child: Image.asset(
                    "assets/icons/company_icon2.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Dispatcher",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Table headers
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Expanded(
                  flex: 3,
                  child: Text(
                    "Name",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF18191A),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 3,
                  child: Text(
                    "Mobile",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF18191A),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const AddDispatcherScreen())?.then((_) {
                        // Refresh list after adding dispatcher
                        _dispatcherController.fetchDispatchers();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xffF5FFF9),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            "Add",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF219653),
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.add,
                            size: 16,
                            color: Color(0xFF219653),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Dispatcher list
          Expanded(
            child: ListView.separated(
              itemCount: _dispatcherController.dispatchers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final dispatcher = _dispatcherController.dispatchers[index];
                return DispatcherListItem(
                  name: dispatcher.name,
                  mobile: dispatcher.mobile,
                  onRemove: () => _removeDispatcher(dispatcher.id),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanyAppbar(),
      drawer: CompanyDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: _buildHomeContent(),
      ),
    );
  }
}
