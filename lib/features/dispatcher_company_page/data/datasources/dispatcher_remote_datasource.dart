import 'package:dartz/dartz.dart';
import 'package:flutx_core/flutx_core.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../models/dispatcher_model.dart';

abstract class DispatcherRemoteDataSource {
  Future<Either<NetworkFailure, NetworkSuccess<List<Dispatcher>>>> getDispatchers();
}

class DispatcherRemoteDataSourceImpl implements DispatcherRemoteDataSource {
  final ApiClient _apiClient;

  DispatcherRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<Either<NetworkFailure, NetworkSuccess<List<Dispatcher>>>> getDispatchers() async {
    try {
      DPrint.log("🚀 Fetching dispatchers from API...");
      
      final result = await _apiClient.get<List<Dispatcher>>(
        ApiConstants.company.getDispatchers,
        fromJsonT: (json) {
          DPrint.log("📦 Raw API Response: $json");
          
          if (json is List) {
            final dispatchers = json.map((item) => Dispatcher.fromJson(item as Map<String, dynamic>)).toList();
            DPrint.log("✅ Parsed ${dispatchers.length} dispatchers");
            return dispatchers;
          }
          
          DPrint.log("⚠️ Unexpected response format");
          return <Dispatcher>[];
        },
      );

      return result.fold(
        (failure) {
          DPrint.error("❌ Failed to fetch dispatchers: ${failure.message}");
          return Left(failure);
        },
        (success) {
          DPrint.log("✅ Successfully fetched ${success.data.length} dispatchers");
          return Right(success);
        },
      );
    } catch (e) {
      DPrint.error("❌ Exception in getDispatchers: $e");
      return const Left(
        UnknownFailure(message: "Failed to fetch dispatchers"),
      );
    }
  }
}
