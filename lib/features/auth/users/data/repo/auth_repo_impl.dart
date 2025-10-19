import 'package:flutter_lakshman1020/features/auth/users/data/model/auth_response_model.dart';
import 'package:flutter_lakshman1020/features/auth/users/data/model/forgot_pass_request_model.dart';
import 'package:flutter_lakshman1020/features/auth/users/data/model/forgot_pass_response_model.dart';
import 'package:flutter_lakshman1020/features/auth/users/data/model/refresh_token_request_model.dart';
import 'package:flutter_lakshman1020/features/auth/users/data/model/refresh_token_response_model.dart';
import 'package:flutter_lakshman1020/features/auth/users/data/model/register_response_model.dart';
import 'package:flutter_lakshman1020/features/auth/users/data/model/set_password_request_model.dart';
import 'package:flutter_lakshman1020/features/auth/users/data/model/set_password_response_model.dart';
import 'package:flutter_lakshman1020/features/auth/users/data/model/verify_otp_request-model.dart';
import 'package:flutter_lakshman1020/features/auth/users/data/model/verify_otp_response_model.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/constants/api_constants.dart';
import '../../../../../core/network/network_result.dart';
import '../../domain/repo/auth_repo.dart';
import '../model/login_request_model.dart';
import '../model/register_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<AuthResponseModel> login(LoginRequestModel request) {
    return _apiClient.post<AuthResponseModel>(
      ApiConstants.auth.login,
      data: request.toJson(),
      fromJsonT: (json) => AuthResponseModel.fromJson(json),
      // isFormData: true
    );
  }


  @override
  NetworkResult<RegisterResponseModel> register(RegisterRequestModel request) {
    return _apiClient.post<RegisterResponseModel>(
      ApiConstants.auth.register,
      data: request.toJson(),
      fromJsonT: (json) => RegisterResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<ForgotPassResponseModel> forgotPassword(
    ForgotPassRequestModel request,
  ) {
    return _apiClient.post(
      ApiConstants.auth.forgotPass,
      data: request.toJson(),
      fromJsonT: (json) => ForgotPassResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<VerifyMailOtpResponseModel> verifyOtp(
    VerifyMailOtpRequest request,
  ) {
    return _apiClient.post(
      ApiConstants.auth.verifyMailOtp,
      data: request.toJson(),
      fromJsonT: (json) => VerifyMailOtpResponseModel.fromJson(json),
    );
  }


  @override
  NetworkResult<ResetPasswordResponseModel> setNewPassword(
    ResetPasswordRequestModel request,
  ) {
    return _apiClient.post(
      ApiConstants.auth.setNewPass,
      data: request.toJson(),
      fromJsonT: (json) => ResetPasswordResponseModel.fromJson(json),
    );
  }

   @override
  NetworkResult<RefreshTokenResponseModel> refreshToken(
    RefreshTokenRequestModel request,
  ) {
    return _apiClient.post(
      ApiConstants.auth.refreshToken,
      data: request.toJson(),
      fromJsonT: (json) => RefreshTokenResponseModel.fromJson(json),
    );
  }
}
