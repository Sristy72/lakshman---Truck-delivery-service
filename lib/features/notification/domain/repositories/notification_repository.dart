import 'package:dartz/dartz.dart';

import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<Either<NetworkFailure, NetworkSuccess<List<NotificationModel>>>> getAllNotifications();
}