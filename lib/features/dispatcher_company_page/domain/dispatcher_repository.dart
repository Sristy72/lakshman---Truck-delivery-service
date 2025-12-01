import 'package:dartz/dartz.dart';

import '../../../core/network/models/network_failure.dart';
import '../../../core/network/models/network_success.dart';
import '../models/dispatcher_model.dart';

abstract class DispatcherRepository {
  Future<Either<NetworkFailure, NetworkSuccess<List<Dispatcher>>>> getDispatchers();
  Future<Either<NetworkFailure, NetworkSuccess<void>>> removeDispatcher(String dispatcherId);
}
