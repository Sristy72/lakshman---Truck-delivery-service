import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/dummy_data.dart';
import 'package:get/get.dart';

class RevenueGraph extends StatefulWidget {
  final RxList<FlSpot>? chartData;
  
  const RevenueGraph({super.key, this.chartData});

  @override
  State<RevenueGraph> createState() => _RevenueGraphState();
}

class _RevenueGraphState extends State<RevenueGraph> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Revenue",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// 🔹 Line Chart
          widget.chartData != null
              ? Obx(() => _buildChart(widget.chartData!))
              : _buildChart(chartData["weekly"] ?? []),
        ],
      ),
    );
  }

  Widget _buildChart(List<FlSpot> spots) {
    // If no data, show empty state
    if (spots.isEmpty) {
      return Container(
        height: 220,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: Colors.black12),
        ),
        child: const Center(
          child: Text(
            'No revenue data available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    // Calculate max value from spots and round up to nearest 1000
    double maxValue = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    // Round up to nearest 1000
    double maxY = ((maxValue / 1000).ceil() * 1000).toDouble();
    // Ensure at least 4000 for nice intervals
    if (maxY < 4000) maxY = 4000;

    return Container(
      height: 300, // Increased height for bigger graph
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.black12),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false, // Hide vertical grid lines
            horizontalInterval: (maxY / 4), // Divide into 4 equal parts
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withValues(alpha: 0.15),
                strokeWidth: 1,
                dashArray: [5, 5], // Dashed lines like in the image
              );
            },
          ),
          titlesData: FlTitlesData(
            // Hide top titles
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            // Hide right titles
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            // Show left titles (Y-axis - Amount)
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                interval: (maxY / 4), // Show 5 labels: 0, 1k, 2k, 3k, 4k
                getTitlesWidget: (value, meta) {
                  // Format like in image: $ 0, $ 1k, $ 2k, $ 3k, $ 4k
                  String text;
                  if (value == 0) {
                    text = '\$ 0';
                  } else if (value >= 1000) {
                    final kValue = (value / 1000).toInt();
                    text = '\$ ${kValue}k';
                  } else {
                    text = '\$${value.toInt()}';
                  }
                  return Text(
                    text,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                },
              ),
            ),
            // Show bottom titles (X-axis - Days)
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  // Full day names like in the image
                  const days = [
                    "Fri",
                    "Sat",
                    "Sun",
                    "Mon",
                    "Tue",
                    "Wed",
                    "Thurs",
                  ];
                  final index = value.toInt();
                  if (index >= 0 && index < days.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        days[index],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false, // Hide all borders for cleaner look
          ),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: maxY, // Set max Y to calculated value
          // Add touch interaction to show tooltip
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => TColors.primary,
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  final value = spot.y;
                  String formattedValue;
                  if (value >= 1000) {
                    formattedValue = '${(value / 1000).toStringAsFixed(1)}k';
                  } else {
                    formattedValue = value.toInt().toString();
                  }
                  return LineTooltipItem(
                    'revenue $formattedValue',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
            handleBuiltInTouches: true,
            getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
              return spotIndexes.map((index) {
                return TouchedSpotIndicatorData(
                  FlLine(
                    color: TColors.primary.withValues(alpha: 0.5),
                    strokeWidth: 2,
                    dashArray: [5, 5],
                  ),
                  FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 6,
                        color: Colors.white,
                        strokeWidth: 3,
                        strokeColor: TColors.primary,
                      );
                    },
                  ),
                );
              }).toList();
            },
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.4, // Smoother curve like in the image
              color: TColors.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    TColors.primary.withValues(alpha: 0.4),
                    TColors.primary.withValues(alpha: 0.1),
                    TColors.primary.withValues(alpha: 0.02),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
