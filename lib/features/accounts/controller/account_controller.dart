import 'dart:developer' as DPrint;
import 'dart:io';

import 'package:flutter_lakshman1020/features/accounts/data/models/change_password_request_model.dart';
import 'package:flutter_lakshman1020/features/accounts/data/models/driver_profile_response_model.dart';
import 'package:flutter_lakshman1020/features/accounts/data/models/fetch_profile_response_model.dart';
import 'package:flutter_lakshman1020/features/accounts/domain/repo/account_repo.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/network/services/multiple_form_data_manager.dart';

class AccountController extends BaseController {
  final AccountRepository _accountRepository;
  var isSkipLoading = false.obs;
  var isContinueLoading = false.obs;
  final MultiFormDataManager _multiFormDataManager = MultiFormDataManager();


  AccountController(this._accountRepository);

  final Rxn<FetchProfileResponseModel> userInfo = Rxn<FetchProfileResponseModel>();
  final Rxn<DriverProfileResponseModel> driverProfile = Rxn<DriverProfileResponseModel>();
  @override
  void onInit() {
    super.onInit();
    fetchProfile();         //Fetch when controller is created
  }



  Future<void> fetchProfile() async {
    setLoading(true);
    setError("");

    final result = await _accountRepository.fetchProfile();

    result.fold((fail) {
      setError(fail.message);
      DPrint.log('❌ Profile fetch failed: ${fail.message}');
      setLoading(false);
    }, (success) {
      userInfo.value = success.data;
      DPrint.log('✅ Profile fetched successfully');
      DPrint.log('👤 User Name: ${success.data.name}');
      DPrint.log('📧 User Email: ${success.data.email}');
      DPrint.log('🎭 User Role: ${success.data.role}');
      DPrint.log('🖼️ Avatar URL: ${success.data.avatar.url}');
      setLoading(false);
    });
  }


  Future<void> updatePersonalInfo(
      File? image,
      String name,
      String mail,
      String mobile,
      String dob,
      String address,
      String nationality,
      ) async {
    setLoading(true);
    setError('');

    // Clear any previous form data
    _multiFormDataManager.clear();

    // Get user role to determine which fields to send
    final userRole = userInfo.value?.role ?? 'user';
    
    // Only add fields that have values (non-empty)
    if (image != null) {
      _multiFormDataManager.addImageFile(image, key: "avatar");
    }
    
    // For company: only send name, email, and avatar
    if (userRole.toLowerCase() == 'company') {
      if (name.isNotEmpty) _multiFormDataManager.addTextData("name", name);
      if (mail.isNotEmpty) _multiFormDataManager.addTextData("email", mail);
      DPrint.log('🏢 Updating company profile with: name, email, avatar');
    } else {
      // For user/driver/dispatcher: send all available fields
      if (name.isNotEmpty) _multiFormDataManager.addTextData("name", name);
      if (mail.isNotEmpty) _multiFormDataManager.addTextData("email", mail);
      if (mobile.isNotEmpty) _multiFormDataManager.addTextData("phone", mobile);
      if (dob.isNotEmpty) _multiFormDataManager.addTextData("dob", dob);
      if (address.isNotEmpty) _multiFormDataManager.addTextData("address", address);
      if (nationality.isNotEmpty) _multiFormDataManager.addTextData("nationality", nationality);
      DPrint.log('👤 Updating user profile with all fields');
    }

    final formRequest = await _multiFormDataManager.toFormDataAsync();
    
    // Log what we're sending
    DPrint.log('📤 Sending update with fields: ${_multiFormDataManager.textData.keys.toList()}');
    DPrint.log('📎 Image attached: ${image != null}');
    
    final result = await _accountRepository.updatePersonalInfo(formRequest);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log('❌ Personal info update failed: ${fail.message}');
        setLoading(false);
        
        // Show error snackbar
        Get.snackbar(
          'Error',
          fail.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      },
          (success) async {
        DPrint.log('✅ Personal info updated: ${success.message}');
        await fetchProfile();

        // Show success snackbar
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
        );

        // Go back one or two screens instead of removing all
        Get.close(2);

        setLoading(false);
      },
    );
  }




  Future<void> changePassword(String oldPassword, String newPassword) async{
    setLoading(true);
    setError('');


    final request = ChangePasswordRequestModel(oldPassword: oldPassword, newPassword: newPassword);
    final result = await _accountRepository.changePassword(request);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log("change pass success result : ${fail.message}");
        setLoading(false);
      },
          (success) {
        DPrint.log("change pass success result : ${success.message}");
        Get.back();
        setLoading(false);
      },
    );
  }
}
