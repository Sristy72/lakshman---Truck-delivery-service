import 'package:fl_chart/fl_chart.dart';

class DashboardModel {
  final int todaysDelivery;
  final double todaysEarnings;
  final int activeDrivers;
  final int runningLoads;
  final List<RevenueData> revenue;

  DashboardModel({
    required this.todaysDelivery,
    required this.todaysEarnings,
    required this.activeDrivers,
    required this.runningLoads,
    required this.revenue,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final dashboard = json['dashboard'] as Map<String, dynamic>?;
    
    if (dashboard == null) {
      return DashboardModel(
        todaysDelivery: 0,
        todaysEarnings: 0.0,
        activeDrivers: 0,
        runningLoads: 0,
        revenue: [],
      );
    }

    return DashboardModel(
      todaysDelivery: dashboard['todaysDelivery'] ?? 0,
      todaysEarnings: (dashboard['todaysEarnings'] ?? 0).toDouble(),
      activeDrivers: dashboard['activeDrivers'] ?? 0,
      runningLoads: dashboard['runningLoads'] ?? 0,
      revenue: (dashboard['revenue'] as List<dynamic>?)
              ?.map((item) => RevenueData.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // Convert revenue data to chart format for fl_chart
  List<FlSpot> toChartData() {
    if (revenue.isEmpty) {
      return [];
    }

    // Map day names to indices for x-axis
    const dayIndices = {
      'Mon': 0.0,
      'Tue': 1.0,
      'Wed': 2.0,
      'Thu': 3.0,
      'Fri': 4.0,
      'Sat': 5.0,
      'Sun': 6.0,
    };

    final spots = <FlSpot>[];
    
    for (final data in revenue) {
      final xValue = dayIndices[data.day] ?? 0.0;
      spots.add(FlSpot(xValue, data.value));
    }

    // Sort by x value to ensure proper line drawing
    spots.sort((a, b) => a.x.compareTo(b.x));

    return spots;
  }
}

class RevenueData {
  final String day; // Mon, Tue, Wed, etc.
  final double value;

  RevenueData({
    required this.day,
    required this.value,
  });

  factory RevenueData.fromJson(Map<String, dynamic> json) {
    return RevenueData(
      day: json['day'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'value': value,
    };
  }
}
