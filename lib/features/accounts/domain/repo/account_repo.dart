import 'package:dio/dio.dart';
import 'package:flutter_lakshman1020/features/accounts/data/models/change_password_request_model.dart';
import 'package:flutter_lakshman1020/features/accounts/data/models/fetch_profile_response_model.dart';
import 'package:flutter_lakshman1020/features/accounts/data/models/update_profile_response_model.dart';

import '../../../../core/network/network_result.dart';



abstract class AccountRepository {
  NetworkResult<FetchProfileResponseModel> fetchProfile();

  //profile update
  NetworkResult<UpdateProfileResponseModel> updatePersonalInfo(FormData request);
  NetworkResult<void> changePassword(ChangePasswordRequestModel request);

// //Change password
//   NetworkResult<void> changePass(ChangePasswordRequest request);
//
//   NetworkResult<UserResponse> uploadPhoto(FormData request);
//
//
//   NetworkResult<UserResponse> tradingInfo(FormData request);
}
