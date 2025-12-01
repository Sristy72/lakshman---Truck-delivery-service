import 'package:fl_chart/fl_chart.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';

import '../../data/models/dashboard_model.dart';
import '../../domain/dashboard_repository.dart';

class DashboardController extends GetxController {
  final DashboardRepository _repository;

  DashboardController({required DashboardRepository repository})
      : _repository = repository;

  // Observable state
  final Rx<DashboardModel?> dashboard = Rx<DashboardModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<FlSpot> chartData = <FlSpot>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      DPrint.log("========== FETCH DASHBOARD ==========");

      final result = await _repository.getDashboard();

      result.fold(
        (failure) {
          DPrint.error("❌ Failed to fetch dashboard: ${failure.message}");
          errorMessage.value = failure.message;
          dashboard.value = null;
        },
        (success) {
          DPrint.log("✅ Dashboard data received successfully");
          dashboard.value = success.data;
          
          // Convert revenue data to chart format
          chartData.value = success.data.toChartData();
          
          DPrint.log("📊 Chart data prepared:");
          DPrint.log("   Total data points: ${chartData.length}");
          
          errorMessage.value = '';
        },
      );
    } catch (e) {
      DPrint.error("❌ Exception in fetchDashboard: $e");
      errorMessage.value = 'An unexpected error occurred';
      dashboard.value = null;
    } finally {
      isLoading.value = false;
      DPrint.log("========================================");
    }
  }

  // Getters for easy access
  int get todaysDelivery => dashboard.value?.todaysDelivery ?? 0;
  double get todaysEarnings => dashboard.value?.todaysEarnings ?? 0.0;
  int get activeDrivers => dashboard.value?.activeDrivers ?? 0;
  int get runningLoads => dashboard.value?.runningLoads ?? 0;
  
  String get todaysEarningsFormatted {
    final earnings = todaysEarnings;
    if (earnings >= 1000) {
      return '\$${(earnings / 1000).toStringAsFixed(1)}k';
    }
    return '\$$earnings';
  }
}
