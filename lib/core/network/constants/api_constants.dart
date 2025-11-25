class ApiConstants {
  /// [Base Configuration]
  // static const String baseDomain = 'https://karlfive223-backend.onrender.com';

  static const String baseDomain = 'http://10.10.5.59:8001'; // soykot
  static const String baseUrl = '$baseDomain/api/v1';

  /// Google Maps API key for geocoding addresses from coordinates
  static const String googleMapsApiKey = 'AIzaSyALWWWVRTpQHw1A8okK1Mxx6lCgFRyGRPI';

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
  
  static PlanEndpoints get plan => PlanEndpoints();
  
  static PaymentEndpoints get payment => PaymentEndpoints();
  
  static CompanyEndpoints get company => CompanyEndpoints();
  static ChatEndpoints get chat => ChatEndpoints();// Soykot
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
  static const String _baseUrl = '${ApiConstants.baseUrl}';
  
  // Single endpoint for all roles - backend handles role-based logic
  String fetchProfileByRole(String role) {
    return '$_baseUrl/user/profile';
  }
  
  
  String updateProfileByRole(String role) {
    return '$_baseUrl/user/update-profile';
  }
  
  
  // Legacy endpoints for backward compatibility
  final String fetchProfile = '$_baseUrl/user/profile';
  final String updateProfile = '$_baseUrl/user/update-profile';
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
  String getById(String id) => '$_base/$id';
  String priceAction(String id) => '$_base/$id/price-action';
  String askPrice(String id) => '$_base/$id/ask-price';
}

class PlanEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/plan';

  final String getPlans = _base;
}

class PaymentEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/payment';

  final String createPayment = '$_base/create-payment';
  final String confirmPayment = '$_base/confirm-payment';
}

class AskPriceEndpoints{
  static const String _base = '${ApiConstants.baseUrl}/load';

  String askPrice(String id) => '$_base/$id/ask-price';
}

class CompanyEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/company';

  final String createDriver = '$_base/create-driver';
  final String createDispatcher = '$_base/create-dispacher';
  final String getDispatchers = '$_base/dispacher'; // Note: API has typo "dispacher"
  final String getDrivers = '$_base/driver';
}

//Soykot
class ChatEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/chat';

  final String getAllChats = '$_base/get-chat';
  final String createChat = '$_base/create';
  final String sendMessage = '$_base/send-message';
  final String updateMessage = '$_base/update-message';
  final String getUserAllChat = '$_base/user/all';
  final String getAllChatForFarm = '$_base/farm/all';
  final String newRequest = '$_base/new-request';
}


//Soykot