import 'package:dartz/dartz.dart';

import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../model/dariver_model.dart';

abstract class DriverRepository {
  Future<Either<NetworkFailure, NetworkSuccess<List<Driver>>>> getDrivers();
}
