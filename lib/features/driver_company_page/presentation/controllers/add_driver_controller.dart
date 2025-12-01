import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/network/api_client.dart';
import 'package:flutter_lakshman1020/core/network/services/multiple_form_data_manager.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/data/repository/company_repository_impl.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/domain/repository/company_repository.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';

class AddDriverController extends ChangeNotifier {
  final CompanyRepository _companyRepository = CompanyRepositoryImpl(apiClient: ApiClient());
  final MultiFormDataManager _formDataManager = MultiFormDataManager();
  
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
  
  Future<void> createDriver({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String company,
    File? avatar,
  }) async {
    setLoading(true);
    setError('');
    
    try {
      // Clear previous form data
      _formDataManager.clear();
      
      // Add text data
      _formDataManager.addTextData('name', name);
      _formDataManager.addTextData('email', email);
      _formDataManager.addTextData('password', password);
      _formDataManager.addTextData('phone', phone);
      _formDataManager.addTextData('company', company);
      
      // Add avatar if provided
      if (avatar != null) {
        _formDataManager.addImageFile(avatar, key: 'avatar');
      }
      
      // Convert to FormData - use async if avatar exists, sync otherwise
      final formData = avatar != null 
          ? await _formDataManager.toFormDataAsync()
          : _formDataManager.toFormData();
      
      // Make API call
      final result = await _companyRepository.createDriver(formData);
      
      result.fold(
        (failure) {
          setError(failure.message);
          DPrint.log('Create driver failed: ${failure.message}');
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
          DPrint.log('Create driver success: ${success.message}');
          setLoading(false);
          _formDataManager.clear();
          
          // Show success snackbar
          Get.snackbar(
            'Success',
            'Driver created successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          
          // Go back to driver list screen
          Get.back();
        },
      );
    } catch (e) {
      setError(e.toString());
      DPrint.log('Error creating driver: $e');
      setLoading(false);
      
      // Show error snackbar
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
    _formDataManager.clear();
    super.dispose();
  }
}
