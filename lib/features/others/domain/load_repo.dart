import 'package:dartz/dartz.dart';

import '../../../core/network/models/network_failure.dart';
import '../../../core/network/models/network_success.dart';
import '../data/models/ask_price_request_model.dart';
import '../data/models/ask_price_response_model.dart';
import '../data/models/assign_driver_request_model.dart';
import '../data/models/assign_driver_response_model.dart';

/// Repository dedicated to ask-price flows (different from home LoadRepository)
abstract class AskPriceRepository {
  /// Ask price for a load using PATCH method
  Future<Either<NetworkFailure, NetworkSuccess<AskPriceResponseModel>>>
      askPrice(String loadId, AskPriceRequestModel request);

  /// Assign driver to a load using POST method
  Future<Either<NetworkFailure, NetworkSuccess<AssignDriverResponseModel>>>
      assignDriver(String loadId, AssignDriverRequestModel request);
}
