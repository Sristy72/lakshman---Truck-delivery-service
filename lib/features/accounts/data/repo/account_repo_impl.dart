import 'package:dio/dio.dart';
import 'package:flutter_lakshman1020/features/accounts/data/models/fetch_profile_response_model.dart';
import 'package:flutter_lakshman1020/features/accounts/domain/repo/account_repo.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../models/change_password_request_model.dart';
import '../models/update_profile_response_model.dart';


class AccountRepositoryImpl implements AccountRepository {
  final ApiClient _apiClient;

  AccountRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  NetworkResult<FetchProfileResponseModel> fetchProfile() {
    return _apiClient.get(
        ApiConstants.getProfile.fetchProfile,
        fromJsonT: (json) =>
            FetchProfileResponseModel.fromJson(json as Map<String, dynamic>));
  }

  @override
  NetworkResult<UpdateProfileResponseModel> updatePersonalInfo(FormData request){
    return _apiClient.patch(
        ApiConstants.getProfile.updateProfile,
        formData: request,
        fromJsonT: (json) => UpdateProfileResponseModel.fromJson(json),
    );
  }



  @override
  NetworkResult<void> changePassword(ChangePasswordRequestModel request) {
    return _apiClient.post(
      ApiConstants.auth.changePass,
      data: request.toJson(),
      fromJsonT: (json) => [],
    );
  }

  // @override
  // NetworkResult<UserResponse> uploadPhoto(FormData request) {
  //   return _apiClient.patch(
  //       ApiConstants.user.updateProfile,
  //       formData: request,
  //       fromJsonT: (json) => UserResponse.fromJson(json),
  //       isFormData: true
  //   );
  // }
  //
  // @override
  // NetworkResult<UserResponse> tradingInfo(FormData request) {
  //   return _apiClient.patch(
  //       ApiConstants.user.updateProfile,
  //       formData: request,
  //       fromJsonT: (json) => UserResponse.fromJson(json),
  //       isFormData: true
  //   );
  // }
}