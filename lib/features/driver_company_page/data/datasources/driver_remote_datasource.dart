import 'package:dartz/dartz.dart';
import 'package:flutx_core/flutx_core.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../model/dariver_model.dart';
import '../models/driver_details_response_model.dart';

abstract class DriverRemoteDataSource {
  Future<Either<NetworkFailure, NetworkSuccess<List<Driver>>>> getDrivers();
  Future<Either<NetworkFailure, NetworkSuccess<DriverDetailsResponseModel>>> getDriverDetails(String driverId);
  Future<Either<NetworkFailure, NetworkSuccess<void>>> removeDriver(String driverId);
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

  @override
  Future<Either<NetworkFailure, NetworkSuccess<DriverDetailsResponseModel>>> getDriverDetails(String driverId) async {
    try {
      DPrint.log("🚀 Fetching driver details for ID: $driverId");
      
      final result = await _apiClient.get<DriverDetailsResponseModel>(
        ApiConstants.company.getDriverDetails(driverId),
        fromJsonT: (json) {
          DPrint.log("📦 Raw Driver Details Response: $json");
          return DriverDetailsResponseModel.fromJson(json as Map<String, dynamic>);
        },
      );

      return result.fold(
        (failure) {
          DPrint.error("❌ Failed to fetch driver details: ${failure.message}");
          return Left(failure);
        },
        (success) {
          DPrint.log("✅ Successfully fetched driver details: ${success.data.user.name}");
          return Right(success);
        },
      );
    } catch (e) {
      DPrint.error("❌ Exception in getDriverDetails: $e");
      return Left(
        NetworkFailure(
          message: 'Failed to fetch driver details: $e',
          statusCode: 0,
        ),
      );
    }
  }

  @override
  Future<Either<NetworkFailure, NetworkSuccess<void>>> removeDriver(String driverId) async {
    try {
      DPrint.log("🗑️ Removing driver with ID: $driverId");
      
      final result = await _apiClient.get<void>(
        ApiConstants.company.removeDriver(driverId),
        fromJsonT: (json) {
          DPrint.log("📦 Remove Driver Response: $json");
          // API returns driver object but we don't need to use it
          return;
        },
      );

      return result.fold(
        (failure) {
          DPrint.error("❌ Remove Driver API Error: ${failure.message}");
          return Left(failure);
        },
        (success) {
          DPrint.log("✅ Driver removed successfully");
          return Right(NetworkSuccess<void>(
            data: null,
            message: 'Driver removed successfully',
            statusCode: 200,
          ));
        },
      );
    } catch (e) {
      DPrint.error("❌ Exception in removeDriver: $e");
      return Left(
        NetworkFailure(
          message: 'Failed to remove driver: $e',
          statusCode: 0,
        ),
      );
    }
  }
}
