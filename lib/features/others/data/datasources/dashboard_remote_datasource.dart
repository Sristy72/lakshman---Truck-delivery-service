import 'package:dartz/dartz.dart';
import 'package:flutx_core/flutx_core.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../models/dashboard_model.dart';

abstract class DashboardRemoteDataSource {
  Future<Either<NetworkFailure, NetworkSuccess<DashboardModel>>> getDashboard();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient _apiClient;

  DashboardRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<Either<NetworkFailure, NetworkSuccess<DashboardModel>>> getDashboard() async {
    try {
      DPrint.log("🚀 Fetching dashboard data from API...");
      
      final result = await _apiClient.get<DashboardModel>(
        ApiConstants.user.getUserProfile,
        fromJsonT: (json) {
          DPrint.log("📦 Raw Dashboard Response: $json");
          
          final dashboard = DashboardModel.fromJson(json as Map<String, dynamic>);
          
          DPrint.log("✅ Dashboard parsed successfully:");
          DPrint.log("   Today's Delivery: ${dashboard.todaysDelivery}");
          DPrint.log("   Today's Earnings: \$${dashboard.todaysEarnings}");
          DPrint.log("   Active Drivers: ${dashboard.activeDrivers}");
          DPrint.log("   Running Loads: ${dashboard.runningLoads}");
          DPrint.log("   Revenue Data Points: ${dashboard.revenue.length}");
          
          return dashboard;
        },
      );

      return result.fold(
        (failure) {
          DPrint.error("❌ Failed to fetch dashboard: ${failure.message}");
          return Left(failure);
        },
        (success) {
          DPrint.log("✅ Successfully fetched dashboard data");
          return Right(success);
        },
      );
    } catch (e) {
      DPrint.error("❌ Exception in getDashboard: $e");
      return const Left(
        UnknownFailure(message: "Failed to fetch dashboard data"),
      );
    }
  }
}
