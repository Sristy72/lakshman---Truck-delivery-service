import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:http/http.dart' as http;

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../domain/payment_repo.dart';
import '../models/confirm_payment_request_model.dart';
import '../models/create_payment_request_model.dart';
import '../models/create_payment_response_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final ApiClient _apiClient;

  PaymentRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    final secretKey = "sk_test_51S6pMbRZVOYD6qjBs3XxcUpw32E2k2j6b2AW2YH8WFIgjMbQi6MYMNRtWSkalY9uXVidPA0JSeMEJpQfSpoE8v6400VdeWSwFn";
    if (secretKey.isEmpty) {
      throw Exception('Secret key not available');
    }

    // Clean and parse amount (support decimals like "99.99" and commas)
    final cleaned = amount.replaceAll(RegExp(r'[^0-9\.]'), '').trim();
    final parsed = double.tryParse(cleaned);
    if (parsed == null) {
      throw Exception('Invalid amount format: $amount');
    }
    final amountInCents = (parsed * 100).round().toString();

    final body = {
      'amount': amountInCents,
      'currency': currency,
      'payment_method_types[]': 'card',
    };

    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body,
    );

    final decoded = jsonDecode(response.body.toString());
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected Stripe response: ${response.body}');
    }

    if (!decoded.containsKey('client_secret')) {
      // include Stripe error message if present
      final err = decoded['error'];
      final msg = err is Map && err.containsKey('message') ? err['message'] : response.body;
      throw Exception('Stripe error creating payment intent: $msg');
    }

  return decoded;
  }

  @override
  Future<Either<NetworkFailure, NetworkSuccess<CreatePaymentResponseModel>>> 
      createPayment(CreatePaymentRequestModel request) async {
    try {
      DPrint.log("🚀 Creating payment for user: ${request.userId}, plan: ${request.planId}");

      final result = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.payment.createPayment,
        data: request.toJson(),
        fromJsonT: (json) => json as Map<String, dynamic>,
      );

      return result.fold(
        (failure) {
          DPrint.error("❌ Failed to create payment: ${failure.message}");
          return Left(failure);
        },
        (success) {
          DPrint.log("✅ Payment created successfully");
          
          final paymentResponse = CreatePaymentResponseModel.fromJson(success.data);

          return Right(NetworkSuccess(
            data: paymentResponse,
            message: success.message,
            statusCode: success.statusCode,
          ));
        },
      );
    } catch (e) {
      DPrint.error("❌ Unexpected error creating payment: $e");
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<void> confirmPayment(ConfirmPaymentRequestModel request) async {
    try {
      DPrint.log("🚀 Confirming payment for Payment Intent ID: ${request.paymentIntentId}");

      await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.payment.confirmPayment,
        data: request.toJson(),
        fromJsonT: (json) => json as Map<String, dynamic>,
      );

      DPrint.log("✅ Payment confirmation API called");
    } catch (e) {
      DPrint.error("❌ Unexpected error confirming payment: $e");
      rethrow;
    }
  }
}
