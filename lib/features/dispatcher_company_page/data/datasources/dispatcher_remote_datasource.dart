import 'package:dartz/dartz.dart';
import 'package:flutx_core/flutx_core.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../models/dispatcher_model.dart';

abstract class DispatcherRemoteDataSource {
  Future<Either<NetworkFailure, NetworkSuccess<List<Dispatcher>>>> getDispatchers();
  Future<Either<NetworkFailure, NetworkSuccess<void>>> removeDispatcher(String dispatcherId);
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
            DPrint.log("✅ Received ${json.length} dispatchers");
            return json.map((item) => Dispatcher.fromJson(item as Map<String, dynamic>)).toList();
          } else {
            DPrint.error("❌ Expected List, got ${json.runtimeType}");
            throw Exception('Invalid response format');
          }
        },
      );

      return result.fold(
        (failure) {
          DPrint.error("❌ API Error: ${failure.message}");
          return Left(failure);
        },
        (success) {
          DPrint.log("✅ Successfully fetched ${success.data.length} dispatchers");
          return Right(success);
        },
      );
    } catch (e) {
      DPrint.error("❌ Exception in getDispatchers: $e");
      return Left(
        NetworkFailure(
          message: 'Failed to fetch dispatchers: $e',
          statusCode: 0,
        ),
      );
    }
  }

  @override
  Future<Either<NetworkFailure, NetworkSuccess<void>>> removeDispatcher(String dispatcherId) async {
    try {
      DPrint.log("🗑️ Removing dispatcher with ID: $dispatcherId");
      
      final result = await _apiClient.delete<void>(
        ApiConstants.company.removeDispatcher(dispatcherId),
        fromJsonT: (json) {
          DPrint.log("📦 Remove Dispatcher Response: $json");
          // API returns {success: true, message: "...", data: null}
          // We don't need to return anything, just acknowledge success
          return;
        },
      );

      return result.fold(
        (failure) {
          DPrint.error("❌ Remove Dispatcher API Error: ${failure.message}");
          return Left(failure);
        },
        (success) {
          DPrint.log("✅ Dispatcher removed successfully");
          return Right(NetworkSuccess<void>(
            data: null,
            message: 'Dispatcher removed successfully',
            statusCode: 200,
          ));
        },
      );
    } catch (e) {
      DPrint.error("❌ Exception in removeDispatcher: $e");
      return Left(
        NetworkFailure(
          message: 'Failed to remove dispatcher: $e',
          statusCode: 0,
        ),
      );
    }
  }
}
