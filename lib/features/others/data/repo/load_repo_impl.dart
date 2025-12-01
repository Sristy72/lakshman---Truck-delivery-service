import 'package:dartz/dartz.dart';
import 'package:flutx_core/flutx_core.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../domain/load_repo.dart';
import '../models/ask_price_request_model.dart';
import '../models/ask_price_response_model.dart';
import '../models/assign_driver_request_model.dart';
import '../models/assign_driver_response_model.dart';

class LoadRepositoryImpl implements AskPriceRepository {
  final ApiClient _apiClient;

  LoadRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Either<NetworkFailure, NetworkSuccess<AskPriceResponseModel>>> 
      askPrice(String loadId, AskPriceRequestModel request) async {
    try {
      final requestData = request.toJson();
      DPrint.log("🚀 Asking price for loadId: $loadId");
      DPrint.log("📦 Request data: $requestData");
      DPrint.log("🔗 Endpoint: ${ApiConstants.load.askPrice(loadId)}");

      final result = await _apiClient.patch<AskPriceResponseModel>(
        ApiConstants.load.askPrice(loadId),
        data: requestData,
        fromJsonT: (json) {
          DPrint.log("📥 Raw API Response: $json");
          return AskPriceResponseModel.fromJson(json as Map<String, dynamic>);
        },
      );

      return result.fold(
        (failure) {
          DPrint.error("❌ Failed to ask price: ${failure.message}");
          return Left(failure);
        },
        (success) {
          DPrint.log("✅ Price asked successfully");
          DPrint.log("📦 Parsed response - Status: ${success.data.orderStatus}, Price: ${success.data.askPrice}");

          return Right(NetworkSuccess(
            data: success.data,
            message: success.message,
            statusCode: success.statusCode,
          ));
        },
      );
    } catch (e) {
      DPrint.error("❌ Unexpected error asking price: $e");
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<NetworkFailure, NetworkSuccess<AssignDriverResponseModel>>>
      assignDriver(String loadId, AssignDriverRequestModel request) async {
    try {
      final requestData = request.toJson();
      DPrint.log("🚗 Assigning driver to loadId: $loadId");
      DPrint.log("📦 Request data: $requestData");
      DPrint.log("🔗 Endpoint: ${ApiConstants.load.assignDriver(loadId)}");

      final result = await _apiClient.patch<AssignDriverResponseModel>(
        ApiConstants.load.assignDriver(loadId),
        data: requestData,
        fromJsonT: (json) {
          DPrint.log("📥 Raw API Response: $json");
          return AssignDriverResponseModel.fromJson(json as Map<String, dynamic>);
        },
      );

      return result.fold(
        (failure) {
          DPrint.error("❌ Failed to assign driver: ${failure.message}");
          return Left(failure);
        },
        (success) {
          DPrint.log("✅ Driver assigned successfully");
          DPrint.log("📦 Parsed response - Status: ${success.data.orderStatus}, Driver: ${success.data.driver}");

          return Right(NetworkSuccess(
            data: success.data,
            message: success.message,
            statusCode: success.statusCode,
          ));
        },
      );
    } catch (e) {
      DPrint.error("❌ Unexpected error assigning driver: $e");
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
