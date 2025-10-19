class ApiConstants {
  /// [Base Configuration]
  // static const String baseDomain = 'https://karlfive223-backend.onrender.com';

  static const String baseDomain = 'http://10.10.5.3:8001';
  static const String baseUrl = '$baseDomain/api/v1';

  /// soykot ip

  static const String soyDomain = 'http://10.10.5.91:5002';

  /// [Headers]
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };

  static Map<String, String> get multipartHeaders => {
    'Accept': 'application/json',
    // Content-Type will be set automatically for multipart
  };

  /// [Endpoint Groups]
  static AuthEndpoints get auth => AuthEndpoints();

  static UserEndpoints get user => UserEndpoints();
  static NotificationEndpoints get notification => NotificationEndpoints();

  static TeamEndpointcs get team => TeamEndpointcs();
  static LeagueEndpoints get league => LeagueEndpoints();
  static LoadEndpoints get load => LoadEndpoints();

  static GetProfile get getProfile => GetProfile();
}

/// [Authentication Endpoints]
class AuthEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/auth';

  final String login = '$_base/login';

  final String register = '$_base/register';
  final String forgotPass = '$_base/forget';
  final String resrtPass = '$_base/reset-password';
  final String verifyMailOtp = '$_base/verify-otp';

  final String refreshToken = '$_base/refresh-token';

  final String setNewPass = '$_base/reset-password';

  final String changePass = '$_base/change-password';
}

class GetProfile {
  static const String _base = '${ApiConstants.baseUrl}/user';
  final String fetchProfile = '$_base/profile';
  final String updateProfile = '$_base/update-profile';
}

class UserEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/user';
  final String updateProfile = '$_base/update-profile';
  final String getUserProfile = '$_base/profile';

  // final String create = '$_base/create';
}

class NotificationEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/notification';

  final String getnotifications = '$_base/getnotifications';
}

class TeamEndpointcs {
  static const String _base = '${ApiConstants.baseUrl}/team';

  final String create = '$_base/create';
}

class LeagueEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/league';

  final String getAllLeagues = '$_base/all-league';
}

class LoadEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/load';

  final String getLoads = _base;
}
