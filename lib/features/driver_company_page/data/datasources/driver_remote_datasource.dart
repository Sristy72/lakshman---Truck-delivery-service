import 'package:dartz/dartz.dart';
import 'package:flutx_core/flutx_core.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../model/dariver_model.dart';

abstract class DriverRemoteDataSource {
  Future<Either<NetworkFailure, NetworkSuccess<List<Driver>>>> getDrivers();
}

class DriverRemoteDataSourceImpl implements DriverRemoteDataSource {
  final ApiClient _apiClient;

  DriverRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<Either<NetworkFailure, NetworkSuccess<List<Driver>>>> getDrivers() async {
    try {
      DPrint.log("🚀 Fetching drivers from API...");
      
      final result = await _apiClient.get<List<Driver>>(
        ApiConstants.company.getDrivers,
        fromJsonT: (json) {
          DPrint.log("📦 Raw API Response: $json");
          
          if (json is List) {
            final drivers = json.map((item) => Driver.fromJson(item as Map<String, dynamic>)).toList();
            DPrint.log("✅ Parsed ${drivers.length} drivers");
            return drivers;
          }
          
          DPrint.log("⚠️ Unexpected response format");
          return <Driver>[];
        },
      );

      return result.fold(
        (failure) {
          DPrint.error("❌ Failed to fetch drivers: ${failure.message}");
          return Left(failure);
        },
        (success) {
          DPrint.log("✅ Successfully fetched ${success.data.length} drivers");
          return Right(success);
        },
      );
    } catch (e) {
      DPrint.error("❌ Exception in getDrivers: $e");
      return Left(
        NetworkFailure(
          message: 'An unexpected error occurred: $e',
          statusCode: 0,
        ),
      );
    }
  }
}
