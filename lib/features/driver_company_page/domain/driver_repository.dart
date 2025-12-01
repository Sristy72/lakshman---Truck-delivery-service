import 'package:dartz/dartz.dart';

import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../data/models/driver_details_response_model.dart';
import '../model/dariver_model.dart';

abstract class DriverRepository {
  Future<Either<NetworkFailure, NetworkSuccess<List<Driver>>>> getDrivers();
  Future<Either<NetworkFailure, NetworkSuccess<DriverDetailsResponseModel>>> getDriverDetails(String driverId);
  Future<Either<NetworkFailure, NetworkSuccess<void>>> removeDriver(String driverId);
}
