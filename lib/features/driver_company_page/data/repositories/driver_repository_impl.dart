import 'package:dartz/dartz.dart';

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
  Future<Either<NetworkFailure, NetworkSuccess<List<Driver>>>> getDrivers() {
    return _remoteDataSource.getDrivers();
  }

  @override
  Future<Either<NetworkFailure, NetworkSuccess<DriverDetailsResponseModel>>> getDriverDetails(String driverId) {
    return _remoteDataSource.getDriverDetails(driverId);
  }

  @override
  Future<Either<NetworkFailure, NetworkSuccess<void>>> removeDriver(String driverId) {
    return _remoteDataSource.removeDriver(driverId);
  }
}
