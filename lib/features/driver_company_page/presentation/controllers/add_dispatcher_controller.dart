import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/network/api_client.dart';
import 'package:flutter_lakshman1020/core/network/constants/api_constants.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/data/repository/company_repository_impl.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/domain/repository/company_repository.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';

class AddDispatcherController extends ChangeNotifier {
  final CompanyRepository _companyRepository = CompanyRepositoryImpl(apiClient: ApiClient());
  
  bool _isLoading = false;
  String _errorMessage = '';
  
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
  
  Future<void> createDispatcher({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String company,
  }) async {
    setLoading(true);
    setError('');
    
    try {
      DPrint.log('========== CREATE DISPATCHER STARTED ==========');
      DPrint.log('Name: $name');
      DPrint.log('Email: $email');
      DPrint.log('Phone: $phone');
      DPrint.log('Company: $company');
      DPrint.log('Password length: ${password.length}');
      
      // Prepare JSON data instead of FormData
      final jsonData = {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'company': company,
      };
      
      DPrint.log('JSON Data: $jsonData');
      DPrint.log('Calling API endpoint: ${ApiConstants.company.createDispatcher}');
      
      // Make API call with JSON data
      final result = await _companyRepository.createDispatcherWithJson(jsonData);
      
      result.fold(
        (failure) {
          DPrint.log('========== CREATE DISPATCHER FAILED ==========');
          DPrint.log('Failure type: ${failure.runtimeType}');
          DPrint.log('Failure message: ${failure.message}');
          setError(failure.message);
          DPrint.log('Create dispatcher failed: ${failure.message}');
          setLoading(false);
          
          // Show error snackbar
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        },
        (success) {
          DPrint.log('========== CREATE DISPATCHER SUCCESS ==========');
          DPrint.log('Success message: ${success.message}');
          DPrint.log('Success status code: ${success.statusCode}');
          DPrint.log('Success data: ${success.data}');
          DPrint.log('Create dispatcher success: ${success.message}');
          setLoading(false);
          
          // Show success snackbar
          Get.snackbar(
            'Success',
            'Dispatcher created successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          
          // Go back to dispatcher list screen
          Get.back();
        },
      );
    } catch (e) {
      DPrint.log('========== CREATE DISPATCHER EXCEPTION ==========');
      DPrint.log('Exception type: ${e.runtimeType}');
      DPrint.log('Exception: $e');
      setError('An unexpected error occurred: $e');
      DPrint.log('Create dispatcher exception: $e');
      setLoading(false);
      
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
  
  @override
  void dispose() {
    super.dispose();
  }
}
