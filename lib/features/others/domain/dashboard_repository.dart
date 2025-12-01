import 'package:dartz/dartz.dart';

import '../../../core/network/models/network_failure.dart';
import '../../../core/network/models/network_success.dart';
import '../data/models/dashboard_model.dart';

abstract class DashboardRepository {
  Future<Either<NetworkFailure, NetworkSuccess<DashboardModel>>> getDashboard();
}
