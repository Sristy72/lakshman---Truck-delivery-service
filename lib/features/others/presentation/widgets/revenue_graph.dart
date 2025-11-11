import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/dummy_data.dart';

class RevenueGraph extends StatefulWidget {
  const RevenueGraph({super.key});

  @override
  State<RevenueGraph> createState() => _RevenueGraphState();
}

class _RevenueGraphState extends State<RevenueGraph> {
  String selectedRange = "daily"; // default option

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Revenue",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              DropdownButton<String>(
                value: selectedRange,
                underline: const SizedBox(),
                style: const TextStyle(color: Colors.black54, fontSize: 14),
                items: const [
                  DropdownMenuItem(value: "daily", child: Text("daily")),
                  DropdownMenuItem(value: "weekly", child: Text("weekly")),
                  DropdownMenuItem(value: "monthly", child: Text("monthly")),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRange = value!;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// 🔹 Line Chart
          Container(
            height: 220,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              border: Border.all(color: Colors.black12),
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        const days = [
                          "Mon",
                          "Tue",
                          "Wed",
                          "Thu",
                          "Fri",
                          "Sat",
                          "Sun",
                        ];
                        if (value.toInt() < days.length) {
                          return Text(
                            days[value.toInt()],
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: chartData[selectedRange]!,
                    isCurved: true,
                    color: TColors.primary,
                    barWidth: 0,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          TColors.primary,
                          TColors.primary.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
