import 'package:dartz/dartz.dart';

import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../domain/dispatcher_repository.dart';
import '../../models/dispatcher_model.dart';
import '../datasources/dispatcher_remote_datasource.dart';

class DispatcherRepositoryImpl implements DispatcherRepository {
  final DispatcherRemoteDataSource _remoteDataSource;

  DispatcherRepositoryImpl({required DispatcherRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<NetworkFailure, NetworkSuccess<List<Dispatcher>>>> getDispatchers() {
    return _remoteDataSource.getDispatchers();
  }

  @override
  Future<Either<NetworkFailure, NetworkSuccess<void>>> removeDispatcher(String dispatcherId) {
    return _remoteDataSource.removeDispatcher(dispatcherId);
  }
}
