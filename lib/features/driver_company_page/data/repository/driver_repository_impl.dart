import 'package:dartz/dartz.dart';
import 'package:flutx_core/flutx_core.dart';

import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../domain/driver_repository.dart';
import '../../model/dariver_model.dart';
import '../datasources/driver_remote_datasource.dart';
import '../models/driver_details_response_model.dart';

class DriverRepositoryImpl implements DriverRepository {
  final DriverRemoteDataSource _remoteDataSource;

  DriverRepositoryImpl({required DriverRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<NetworkFailure, NetworkSuccess<List<Driver>>>> getDrivers() async {
    try {
      DPrint.log("📡 DriverRepository: Fetching drivers...");
      return await _remoteDataSource.getDrivers();
    } catch (e) {
      DPrint.error("❌ DriverRepository Error: $e");
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
      DPrint.log("📡 DriverRepository: Fetching driver details for ID: $driverId");
      return await _remoteDataSource.getDriverDetails(driverId);
    } catch (e) {
      DPrint.error("❌ DriverRepository Error: $e");
      return Left(
        NetworkFailure(
          message: 'An unexpected error occurred: $e',
          statusCode: 0,
        ),
      );
    }
  }

  @override
  Future<Either<NetworkFailure, NetworkSuccess<void>>> removeDriver(String driverId) async {
    try {
      DPrint.log("📡 DriverRepository: Removing driver ID: $driverId");
      return await _remoteDataSource.removeDriver(driverId);
    } catch (e) {
      DPrint.error("❌ DriverRepository Error: $e");
      return Left(
        NetworkFailure(
          message: 'An unexpected error occurred: $e',
          statusCode: 0,
        ),
      );
    }
  }
}
