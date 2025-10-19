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

import '../../../../../core/network/network_result.dart';
import '../../data/model/login_request_model.dart';
import '../../data/model/register_request_model.dart';

abstract class AuthRepository {
  NetworkResult<AuthResponseModel> login(LoginRequestModel request);
  NetworkResult<RegisterResponseModel> register(RegisterRequestModel request);
  NetworkResult<ForgotPassResponseModel> forgotPassword(ForgotPassRequestModel request);
  NetworkResult<VerifyMailOtpResponseModel> verifyOtp(VerifyMailOtpRequest request);
  NetworkResult<ResetPasswordResponseModel> setNewPassword(ResetPasswordRequestModel request);
  NetworkResult<RefreshTokenResponseModel> refreshToken(RefreshTokenRequestModel request);

}