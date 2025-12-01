import 'package:dartz/dartz.dart';

import '../../../core/network/models/network_failure.dart';
import '../../../core/network/models/network_success.dart';
import '../data/models/fetch_plans_request_model.dart';
import '../data/models/fetch_plans_response_model.dart';

abstract class SubscriptionRepository {
  Future<Either<NetworkFailure, NetworkSuccess<List<FetchPlansResponseModel>>>>
      fetchPlans(FetchPlansRequestModel request);
}
