import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/network/api_client.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/core/widgets/primary_button.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/constants/app_icons.dart';
import '../../data/datasources/category_remote_datasource.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../models/app_text_styles.dart';
import '../bindings/company_binding.dart';
import '../controllers/category_controller.dart';
import '../controllers/company_controller.dart';
import '../controllers/load_controller.dart';
import 'location_picker_screen.dart';
import 'user_home_screen.dart';

class RequestInformationScreen extends StatefulWidget {
  const RequestInformationScreen({super.key});

  @override
  State<RequestInformationScreen> createState() =>
      _RequestInformationScreenState();
}

class _RequestInformationScreenState extends State<RequestInformationScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Text controllers for date & time fields
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _deliveryController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _categorySelected = 'Medicine';
  String? _selectedCategoryId;
  String _companySelected = 'Default';
  String? _selectedCompanyId;
  LatLng? _pickupLatLng;
  LatLng? _deliveryLatLng;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: TColors.primary, // header & confirm color
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text =
            "${picked.day.toString().padLeft(2, '0')} ${_monthName(picked.month)} ${picked.year}";
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final loadController = Get.find<LoadController>();
    return AppScaffold(
      appBar: CustomAppBar(
        title: "Request for a truck",
        onBack: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
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
                controller: _titleController,
              ),
              const SizedBox(height: 16),

              // Description
              _buildTextField(
                label: "Description",
                hint:
                    "Ex: 3 sealed cartons of medical supplies. Fragile and time-sensitive. Handle with care",
                maxLines: 3,
                controller: _descriptionController,
              ),
              const SizedBox(height: 16),

              // Category - Dynamic from API
              _buildCategoryDropdown(),
              const SizedBox(height: 16),

              // Company - Dynamic from API
              _buildCompanyDropdown(),
              const SizedBox(height: 32),

              // Pickup Location
              _buildTextField(
                label: "Pickup Location",
                hint: "Green Road, Panthopath",
                suffixAsset: AppIcons.location,
                controller: _pickupController,
                // readOnly: true,
                openMapOnSuffixTap: true,
                // also open map when tapping the field itself
                onTap: () =>
                    _openMapAndSetController(_pickupController, isPickup: true),
              ),
              const SizedBox(height: 12),

              // Delivery Location
              _buildTextField(
                label: "Delivery Location",
                hint: "Sayednagar B block, Vatara",
                suffixAsset: AppIcons.location,
                // readOnly: true,
                controller: _deliveryController,
                openMapOnSuffixTap: true,
                onTap: () => _openMapAndSetController(
                  _deliveryController,
                  isPickup: false,
                ),
              ),
              const SizedBox(height: 16),

              // Add Stoppage
              _buildTextField(
                label: "Add Stoppage",
                hint: "Ex: Banani Road No. 11",
              ),
              const SizedBox(height: 16),

              // Pickup Date & Time with Pickers
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: "Pickup Date",
                      hint: "Select date",
                      controller: _dateController,
                      prefixAsset: AppIcons.calendar,
                      readOnly: true,
                      onTap: () => _pickDate(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      label: "Pickup Time",
                      hint: "Select time",
                      controller: _timeController,
                      prefixAsset: AppIcons.clock,
                      readOnly: true,
                      onTap: () => _pickTime(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Special Note
              _buildTextField(
                label: "Special note",
                hint:
                    "This delivery contains fragile and time-sensitive medical supplies. Ensure temperature control if required, avoid…",
                maxLines: 3,
                controller: _noteController,
              ),
              const SizedBox(height: 20),

              // Submit Button
              Obx(() {
                return context.primaryButton(
                  text: "Request for a Truck",
                  isLoading: loadController.isLoading.value,
                  onPressed: () async {
                    final title = _titleController.text.trim();
                    final pickup = _pickupController.text.trim();
                    final delivery = _deliveryController.text.trim();

                    if (title.isEmpty || pickup.isEmpty || delivery.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter title, pickup and delivery locations',
                          ),
                        ),
                      );
                      return;
                    }

                    // Build pickupDate ISO if user picked date/time
                    String? pickupDateIso;
                    if (selectedDate != null) {
                      final date = selectedDate!;
                      final time =
                          selectedTime ?? const TimeOfDay(hour: 12, minute: 0);
                      final dt = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                      pickupDateIso = dt.toUtc().toIso8601String();
                    }

                    final payload = {
                      'title': title,
                      'description': _descriptionController.text.trim(),
                      'category': _categorySelected.toLowerCase(),
                      'pickupLocation': _pickupLatLng != null
                          ? '${_pickupLatLng!.latitude}, ${_pickupLatLng!.longitude}'
                          : pickup,
                      'deliveryLocation': _deliveryLatLng != null
                          ? '${_deliveryLatLng!.latitude}, ${_deliveryLatLng!.longitude}'
                          : delivery,
                      'companyToken':
                          _selectedCompanyId ??
                          '68e9cee3c24ab343ad8335b1', // Use selected company ID or fallback
                      'loadBy': '68f3387fa6174ce77995a604', // placeholder
                      'orderStatus': 'pending',
                      if (pickupDateIso != null) 'pickupDate': pickupDateIso,
                      'note': _noteController.text.trim(),
                    };

                    try {
                      final result = await loadController.createLoad(payload);

                      // Check if load was created successfully
                      if (result != null) {
                        // Hide keyboard if open
                        FocusScope.of(context).unfocus();

                        // Clear any error messages
                        loadController.errorMessage.value = '';

                        // Navigate to home screen and clear navigation stack
                        Get.offAll(() => const UserHomeScreen());

                        // Show success snackbar after navigation
                        Get.snackbar(
                          'Success',
                          'Your truck request has been submitted successfully!',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          icon: const Icon(Icons.check_circle, color: Colors.white),
                          duration: const Duration(seconds: 3),
                          margin: const EdgeInsets.all(16),
                          borderRadius: 8,
                        );
                      } else {
                        // Show error from controller
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(loadController.errorMessage.value.isNotEmpty
                                ? loadController.errorMessage.value
                                : 'Failed to create load. Please try again.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to create load: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                );
              }),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // LoadController is now registered globally in service locator
    
    // Initialize company controller and binding if not already done
    if (!Get.isRegistered<CompanyController>()) {
      CompanyBinding().dependencies();
    }
    
    // Initialize category controller if not already done
    if (!Get.isRegistered<CategoryController>()) {
      // Set up dependencies manually for immediate availability
      final apiClient = Get.find<ApiClient>();
      final categoryDataSource = CategoryRemoteDataSourceImpl(apiClient: apiClient);
      final categoryRepository = CategoryRepositoryImpl(remoteDataSource: categoryDataSource);
      final categoryController = CategoryController(repository: categoryRepository);
      Get.put(categoryController, permanent: true);
    }
    
    // Always fetch fresh data when screen opens (even if controllers already exist)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CompanyController>().fetchCompanies();
      Get.find<CategoryController>().fetchCategories();
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _pickupController.dispose();
    _deliveryController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    String? suffixAsset,
    String? prefixAsset,
    int maxLines = 1,
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onTap,
    bool openMapOnSuffixTap = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TTextStyles.label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TTextStyles.hint,

            prefixIcon: prefixAsset != null
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(prefixAsset, width: 18, height: 18),
                  )
                : null,

            // Suffix Icon Part
            suffixIcon: suffixAsset != null
                ? Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: openMapOnSuffixTap
                          ? () async {
                              if (controller != null) {
                                final isPickup =
                                    controller == _pickupController;
                                await _openMapAndSetController(
                                  controller,
                                  isPickup: isPickup,
                                );
                              }
                            }
                          : null,
                      child: Image.asset(suffixAsset, width: 22, height: 22),
                    ),
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

  Future<void> _openMapAndSetController(
    TextEditingController controller, {
    required bool isPickup,
  }) async {
    // Parse existing coordinates if available
    LatLng? initial;
    if (controller.text.isNotEmpty && controller.text.contains(',')) {
      final parts = controller.text.split(',');
      final lat = double.tryParse(parts[0].trim());
      final lng = double.tryParse(parts[1].trim());
      if (lat != null && lng != null) {
        initial = LatLng(lat, lng);
      }
    }

    // Wait for result from LocationPickerScreen
    final result = await Navigator.of(context).push<LatLng?>(
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(initialLocation: initial),
      ),
    );

    if (result != null) {
      // Save the result
      setState(() {
        if (isPickup) {
          _pickupLatLng = result;
        } else {
          _deliveryLatLng = result;
        }
      });

      // Update controller text
      try {
        final placemarks = await placemarkFromCoordinates(
          result.latitude,
          result.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          setState(() {
            controller.text =
                '${p.name ?? ''}, ${p.locality ?? ''}, ${p.country ?? ''}';
          });
        } else {
          setState(() {
            controller.text =
                '${result.latitude.toStringAsFixed(5)}, ${result.longitude.toStringAsFixed(5)}';
          });
        }

        FocusScope.of(context).unfocus();
      } catch (_) {
        setState(() {
          controller.text =
              '${result.latitude.toStringAsFixed(5)}, ${result.longitude.toStringAsFixed(5)}';
        });
        FocusScope.of(context).unfocus();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isPickup
                ? 'Pickup location updated '
                : 'Delivery location updated ',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }



  Widget _buildCompanyDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Company", style: TTextStyles.label),
        const SizedBox(height: 6),
        Obx(() {
          final companyController = Get.find<CompanyController>();
          if (companyController.isLoading.value) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text("Loading companies...", style: TTextStyles.hint),
                ],
              ),
            );
          }

          if (companyController.companies.isEmpty) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("No companies available", style: TTextStyles.hint),
            );
          }

          final companyItems = companyController.companyDisplayItems;

          // If we have companies but no selection, select the first one or default
          if ((_companySelected == 'Default' || _selectedCompanyId == null) &&
              companyItems.isNotEmpty) {
            final defaultCompany = companyController.getDefaultCompany();
            if (defaultCompany != null) {
              _companySelected = defaultCompany.name;
              _selectedCompanyId = defaultCompany.id;
            } else {
              _companySelected = companyItems.first['name']!;
              _selectedCompanyId = companyItems.first['id']!;
            }
          }

          // Find current selection display value
          String? currentDisplayValue;
          if (_selectedCompanyId != null) {
            try {
              final currentItem = companyItems
                  .where((item) => item['id'] == _selectedCompanyId)
                  .first;
              currentDisplayValue = currentItem['display'];
            } catch (e) {
              // If not found, will use fallback
              currentDisplayValue = null;
            }
          }

            return DropdownButtonFormField<String>(
              value: currentDisplayValue ?? (companyItems.isNotEmpty ? companyItems.first['display'] : null),
            items: companyItems
                .map(
                  (item) => DropdownMenuItem(
                    value: item['display'],
                    child: Text(item['display']!),
                  ),
                )
                .toList(),
            onChanged: (selectedDisplay) {
              if (selectedDisplay != null) {
                // Find the item by display name
                try {
                  final selectedItem = companyItems
                      .where((item) => item['display'] == selectedDisplay)
                      .first;
                  setState(() {
                    _companySelected = selectedItem['name']!;
                    _selectedCompanyId = selectedItem['id']!;
                  });
                } catch (e) {
                  // Handle case where item is not found
                    debugPrint('Company item not found for display: $selectedDisplay');
                }
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Category", style: TTextStyles.label),
        const SizedBox(height: 6),
        Obx(() {
          try {
            final categoryController = Get.find<CategoryController>();
            
            if (categoryController.isLoading.value) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text("Loading categories...", style: TTextStyles.hint),
                  ],
                ),
              );
            }

            if (categoryController.categories.isEmpty) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text("No categories available", style: TTextStyles.hint),
              );
            }

            final categoryItems = categoryController.categoryDisplayItems;

            // If we have categories but no selection, select the first one
            if ((_categorySelected == 'Medicine' || _selectedCategoryId == null) &&
                categoryItems.isNotEmpty) {
              _categorySelected = categoryItems.first['name']!;
              _selectedCategoryId = categoryItems.first['id']!;
            }

            // Find current selection display value
            String? currentDisplayValue;
            if (_selectedCategoryId != null) {
              try {
                final currentItem = categoryItems
                    .where((item) => item['id'] == _selectedCategoryId)
                    .first;
                currentDisplayValue = currentItem['display'];
              } catch (e) {
                // If not found, will use fallback
                currentDisplayValue = null;
              }
            }

            return DropdownButtonFormField<String>(
              value: currentDisplayValue ?? (categoryItems.isNotEmpty ? categoryItems.first['display'] : null),
              items: categoryItems
                  .map(
                    (item) => DropdownMenuItem(
                      value: item['display'],
                      child: Text(item['display']!),
                    ),
                  )
                  .toList(),
              onChanged: (selectedDisplay) {
                if (selectedDisplay != null) {
                  // Find the item by display name
                  try {
                    final selectedItem = categoryItems
                        .where((item) => item['display'] == selectedDisplay)
                        .first;
                    setState(() {
                      _categorySelected = selectedItem['name']!;
                      _selectedCategoryId = selectedItem['id']!;
                    });
                  } catch (e) {
                    // Handle case where item is not found
                    debugPrint('Category item not found for display: $selectedDisplay');
                  }
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            );
          } catch (e) {
            // Fallback if CategoryController is not found
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("Initializing categories...", style: TTextStyles.hint),
            );
          }
        }),
      ],
    );
  }
}
