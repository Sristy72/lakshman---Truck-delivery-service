import 'package:dartz/dartz.dart';

import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../domain/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../models/dashboard_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl({required DashboardRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<NetworkFailure, NetworkSuccess<DashboardModel>>> getDashboard() {
    return _remoteDataSource.getDashboard();
  }
}
