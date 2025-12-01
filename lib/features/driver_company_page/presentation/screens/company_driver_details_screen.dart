import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/network/api_client.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/data/datasources/driver_remote_datasource.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/data/models/driver_details_response_model.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/data/repositories/driver_repository_impl.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/model/dariver_model.dart';
import 'package:flutter_lakshman1020/features/others/presentation/screen/dashboard_overview_scren.dart';
import 'package:get/get.dart';

class CompanyDriverDetailsScreen extends StatefulWidget {
  final Driver driver;

  const CompanyDriverDetailsScreen({super.key, required this.driver});

  @override
  State<CompanyDriverDetailsScreen> createState() => _CompanyDriverDetailsScreenState();
}

class _CompanyDriverDetailsScreenState extends State<CompanyDriverDetailsScreen> {
  late DriverRepositoryImpl _driverRepository;
  DriverDetailsResponseModel? _driverDetails;
  bool _isLoading = true;
  bool _isRemoving = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _driverRepository = DriverRepositoryImpl(
      remoteDataSource: DriverRemoteDataSourceImpl(apiClient: ApiClient()),
    );
    _fetchDriverDetails();
  }

  Future<void> _fetchDriverDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      debugPrint('📡 Fetching driver details for ID: ${widget.driver.id}');
      
      final result = await _driverRepository.getDriverDetails(widget.driver.id);

      result.fold(
        (failure) {
          debugPrint('❌ Failed to fetch driver details: ${failure.message}');
          setState(() {
            _errorMessage = failure.message;
            _isLoading = false;
          });
          Get.snackbar(
            'Error',
            'Failed to load driver details: ${failure.message}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade50,
            colorText: Colors.red.shade900,
            margin: const EdgeInsets.all(12),
          );
        },
        (success) {
          debugPrint('✅ Driver details fetched successfully');
          setState(() {
            _driverDetails = success.data;
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      debugPrint('❌ Exception: $e');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _handleRemoveDriver() async {
    setState(() => _isRemoving = true);

    try {
      debugPrint('🗑️ Removing driver ${widget.driver.name} (${widget.driver.id})');

      final result = await _driverRepository.removeDriver(widget.driver.id);

      setState(() => _isRemoving = false);

      result.fold(
        (failure) {
          // API call failed
          debugPrint('❌ Remove driver API failed: ${failure.message}');
          Get.snackbar(
            'Error',
            'Failed to remove driver: ${failure.message}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade50,
            colorText: Colors.red.shade900,
            margin: const EdgeInsets.all(12),
            duration: const Duration(seconds: 3),
          );
        },
        (success) {
          // API call success
          debugPrint('✅ Driver removed successfully!');

          Get.snackbar(
            'Success',
            '${widget.driver.name} removed successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade50,
            colorText: Colors.green.shade900,
            margin: const EdgeInsets.all(12),
            duration: const Duration(seconds: 2),
          );

          // Navigate to Dashboard after delay
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) {
              debugPrint('🔙 Navigating to Company Dashboard...');
              Get.offAll(
                () => const DashboardScreen(),
                transition: Transition.leftToRight,
              );
            }
          });
        },
      );
    } catch (e) {
      setState(() => _isRemoving = false);
      debugPrint('❌ Unexpected error: $e');
      Get.snackbar(
        'Error',
        'Unexpected error: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(12),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          'Driver details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        'Error: $_errorMessage',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchDriverDetails,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _driverDetails == null
                  ? Center(
                      child: Text('No driver data available'),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Driver Avatar
                          Center(
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                              ),
                              child: ClipOval(
                                child: _driverDetails!.user.avatar?.url != null && 
                                    _driverDetails!.user.avatar!.url!.isNotEmpty
                                    ? Image.network(
                                        _driverDetails!.user.avatar!.url!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/profile_d.png',
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        'assets/images/profile_d.png',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Driver Details Rows
                          _buildRow('Name', _driverDetails!.user.name),
                          const SizedBox(height: 16),
                          _buildRow('Mail', _driverDetails!.user.email),
                          const SizedBox(height: 16),
                          _buildRow('Mobile', _driverDetails!.user.phone),
                          const SizedBox(height: 16),
                          _buildRow('Address', _driverDetails!.company.name),
                          const SizedBox(height: 16),
                          _buildRow('Date of Birth', 'N/A'),
                          const SizedBox(height: 16),
                          _buildRow('Nationality', 'N/A'),
                          const SizedBox(height: 32),

                          // Remove Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isRemoving ? null : () => _showRemoveConfirmationDialog(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFEB5757),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: _isRemoving
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Text(
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
                    ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF18191A),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool?> _showRemoveConfirmationDialog(BuildContext context) {
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
                'Confirm removal\nof driver?',
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
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    _handleRemoveDriver();
                  },
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
}
