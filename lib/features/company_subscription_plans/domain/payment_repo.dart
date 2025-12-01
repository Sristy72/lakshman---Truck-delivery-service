import 'package:dartz/dartz.dart';

import '../../../core/network/models/network_failure.dart';
import '../../../core/network/models/network_success.dart';
import '../data/models/confirm_payment_request_model.dart';
import '../data/models/create_payment_request_model.dart';
import '../data/models/create_payment_response_model.dart';

abstract class PaymentRepository {
  /// Create a PaymentIntent and return the decoded JSON response as a Map.
  Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency);
  
  /// Create payment through backend API
  Future<Either<NetworkFailure, NetworkSuccess<CreatePaymentResponseModel>>> 
      createPayment(CreatePaymentRequestModel request);
  
  /// Confirm payment through backend API (no response expected)
  Future<void> confirmPayment(ConfirmPaymentRequestModel request);
}
