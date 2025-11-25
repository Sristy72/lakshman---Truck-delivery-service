import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/core/network/api_client.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/core/widgets/primary_button.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;

import '../../../../core/constants/app_icons.dart';
import '../../data/datasources/load_remote_datasource.dart';
import '../../data/repositories/load_repository_impl.dart';
import '../../models/app_text_styles.dart';
import '../controllers/load_controller.dart';
import 'location_picker_screen.dart';

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
  String _companySelected = 'Default';

  // LocationPicker theke asha coords (latlong2)
  ll.LatLng? _pickupLatLng;
  ll.LatLng? _deliveryLatLng;

  // Google Map state
  gmap.GoogleMapController? _mapController;
  Set<gmap.Marker> _markers = {};
  Set<gmap.Polyline> _polylines = {};

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
  void initState() {
    super.initState();
    // Initialize controller using the binding setup to ensure proper DI
    if (!Get.isRegistered<LoadController>()) {
      final remoteDataSource = LoadRemoteDataSourceImpl(apiClient: ApiClient());
      final repository = LoadRepositoryImpl(
        remoteDataSource: remoteDataSource,
        apiClient: ApiClient(),
      );
      Get.put(LoadController(repository: repository));
    }
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
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
                const SizedBox(height: 32),

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

                // Category
                _buildDropdown(
                  label: "Category",
                  items: const ["Medicine", "Furniture"],
                  value: _categorySelected,
                  onChanged: (v) {
                    if (v != null) setState(() => _categorySelected = v);
                  },
                ),
                const SizedBox(height: 16),

                // Company
                _buildDropdown(
                  label: "Company",
                  items: const ["Default", "Company A"],
                  value: _companySelected,
                  onChanged: (v) {
                    if (v != null) setState(() => _companySelected = v);
                  },
                ),
                const SizedBox(height: 24),

                // Pickup Location
                _buildTextField(
                  label: "Pickup Location",
                  hint: "Green Road, Panthopath",
                  suffixAsset: AppIcons.location,
                  controller: _pickupController,
                  openMapOnSuffixTap: true,
                  onTap: () => _openMapAndSetController(
                    _pickupController,
                    isPickup: true,
                  ),
                ),
                const SizedBox(height: 12),

                // Delivery Location
                _buildTextField(
                  label: "Delivery Location",
                  hint: "Sayednagar B block, Vatara",
                  suffixAsset: AppIcons.location,
                  controller: _deliveryController,
                  openMapOnSuffixTap: true,
                  onTap: () => _openMapAndSetController(
                    _deliveryController,
                    isPickup: false,
                  ),
                ),
                const SizedBox(height: 16),

                // ⭐ Route Preview Map
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 220,
                    child: (_pickupLatLng != null && _deliveryLatLng != null)
                        ? gmap.GoogleMap(
                            initialCameraPosition: gmap.CameraPosition(
                              target: gmap.LatLng(
                                _pickupLatLng!.latitude,
                                _pickupLatLng!.longitude,
                              ),
                              zoom: 12,
                            ),
                            onMapCreated: (controller) {
                              _mapController = controller;
                              _updateRouteOnMap();
                            },
                            markers: _markers,
                            polylines: _polylines,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                          )
                        : Container(
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: Text(
                              'Select pickup & delivery to preview route',
                              style: TTextStyles.subtitle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Add Stoppage
                _buildTextField(
                  label: "Add Stoppage",
                  hint: "Ex: Banani Road No. 11",
                  suffixAsset: AppIcons.addstopies,
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
                            selectedTime ??
                            const TimeOfDay(hour: 12, minute: 0);
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
                            '68e9cee3c24ab343ad8335b1', // placeholder
                        'loadBy': '68f3387fa6174ce77995a604', // placeholder
                        'orderStatus': 'pending',
                        if (pickupDateIso != null) 'pickupDate': pickupDateIso,
                        'note': _noteController.text.trim(),
                      };

                      try {
                        await loadController.createLoad(payload);

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Load created successfully '),
                          ),
                        );

                        // Reset form fields to default state
                        setState(() {
                          _titleController.clear();
                          _descriptionController.clear();
                          _pickupController.clear();
                          _deliveryController.clear();
                          _noteController.clear();
                          _dateController.clear();
                          _timeController.clear();

                          // Reset dropdown selections
                          _categorySelected = 'Medicine';
                          _companySelected = 'Default';

                          // Reset stored LatLngs and date/time
                          _pickupLatLng = null;
                          _deliveryLatLng = null;
                          selectedDate = null;
                          selectedTime = null;

                          // clear map
                          _markers = {};
                          _polylines = {};
                        });

                        // Hide keyboard if open
                        FocusScope.of(context).unfocus();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to create load: $e')),
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
      ),
    );
  }

  // ---------- UI helpers ----------

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

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    String? value,
    ValueChanged<String?>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TTextStyles.label),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value ?? items.first,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged ?? (v) {},
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

  // ---------- Map & Location logic ----------

  Future<void> _openMapAndSetController(
    TextEditingController controller, {
    required bool isPickup,
  }) async {
    // Parse existing coordinates if available
    ll.LatLng? initial;
    if (controller.text.isNotEmpty && controller.text.contains(',')) {
      final parts = controller.text.split(',');
      final lat = double.tryParse(parts[0].trim());
      final lng = double.tryParse(parts[1].trim());
      if (lat != null && lng != null) {
        initial = ll.LatLng(lat, lng);
      }
    }

    // Wait for result from LocationPickerScreen
    final result = await Navigator.of(context).push<ll.LatLng?>(
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

      // Update map route
      _updateRouteOnMap();

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

  void _updateRouteOnMap() {
    if (_pickupLatLng == null || _deliveryLatLng == null) return;

    final pickup = gmap.LatLng(
      _pickupLatLng!.latitude,
      _pickupLatLng!.longitude,
    );
    final delivery = gmap.LatLng(
      _deliveryLatLng!.latitude,
      _deliveryLatLng!.longitude,
    );

    setState(() {
      _markers = {
        gmap.Marker(
          markerId: const gmap.MarkerId('pickup'),
          position: pickup,
          infoWindow: const gmap.InfoWindow(title: 'Pickup'),
        ),
        gmap.Marker(
          markerId: const gmap.MarkerId('delivery'),
          position: delivery,
          infoWindow: const gmap.InfoWindow(title: 'Delivery'),
        ),
      };

      _polylines = {
        gmap.Polyline(
          polylineId: const gmap.PolylineId('route'),
          points: [pickup, delivery],
          width: 5,
          color: Colors.blue,
        ),
      };
    });

    _fitMapToRoute(pickup, delivery);
  }

  Future<void> _fitMapToRoute(gmap.LatLng pickup, gmap.LatLng delivery) async {
    if (_mapController == null) return;

    final southWest = gmap.LatLng(
      math.min(pickup.latitude, delivery.latitude),
      math.min(pickup.longitude, delivery.longitude),
    );
    final northEast = gmap.LatLng(
      math.max(pickup.latitude, delivery.latitude),
      math.max(pickup.longitude, delivery.longitude),
    );

    final bounds = gmap.LatLngBounds(
      southwest: southWest,
      northeast: northEast,
    );

    await _mapController!.animateCamera(
      gmap.CameraUpdate.newLatLngBounds(bounds, 60),
    );
  }
}
