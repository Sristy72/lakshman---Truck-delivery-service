import 'package:dartz/dartz.dart';
import 'package:flutx_core/flutx_core.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../domain/subscription_repo.dart';
import '../models/fetch_plans_request_model.dart';
import '../models/fetch_plans_response_model.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final ApiClient _apiClient;

  SubscriptionRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<Either<NetworkFailure, NetworkSuccess<List<FetchPlansResponseModel>>>>
      fetchPlans(FetchPlansRequestModel request) async {
    try {
      DPrint.log("🚀 Fetching subscription plans for: ${request.email}");

      // Use GET request with query parameters instead of POST
      final result = await _apiClient.get<List<dynamic>>(
        ApiConstants.plan.getPlans,
        queryParameters: request.toJson(),
        fromJsonT: (json) => json as List<dynamic>,
      );

      return result.fold(
        (failure) {
          DPrint.error("❌ Failed to fetch plans: ${failure.message}");
          return Left(failure);
        },
        (success) {
          DPrint.log("✅ Plans fetched successfully: ${success.data.length} plans");
          
          final plans = success.data
              .map((json) => FetchPlansResponseModel.fromJson(json as Map<String, dynamic>))
              .toList();

          return Right(NetworkSuccess(
            data: plans,
            message: success.message,
            statusCode: success.statusCode,
          ));
        },
      );
    } catch (e) {
      DPrint.error("❌ Unexpected error fetching plans: $e");
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
