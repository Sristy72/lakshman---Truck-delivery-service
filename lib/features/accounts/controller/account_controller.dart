import 'dart:developer' as DPrint;
import 'dart:io';

import 'package:flutter_lakshman1020/features/accounts/data/models/change_password_request_model.dart';
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

    if (image != null) _multiFormDataManager.addImageFile(image, key: "avatar");
    _multiFormDataManager.addTextData("name", name);
    _multiFormDataManager.addTextData("email", mail);
    _multiFormDataManager.addTextData("phone", mobile);
    _multiFormDataManager.addTextData("dob", dob);
    _multiFormDataManager.addTextData("address", address);
    _multiFormDataManager.addTextData("nationality", nationality);

    final formRequest = await _multiFormDataManager.toFormDataAsync();
    final result = await _accountRepository.updatePersonalInfo(formRequest);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log('Personal info update failed: ${fail.message}');
        setLoading(false);
      },
          (success) async {
        DPrint.log('Personal info updated: ${success.message}');
        await fetchProfile();

        // ✅ Go back one or two screens instead of removing all
        Get.close(2); // or Get.back(); if only one screen should close

        setError(success.message);
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
