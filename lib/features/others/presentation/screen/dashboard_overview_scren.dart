import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/company_appbar.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/company_drawer.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/revenue_graph.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanyAppbar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/images/dashboard_icon.png",
                  width: 18,
                  height: 18,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Dashboard / Overview",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 20),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _buildStatCard(
                  imagePath: "assets/images/today_delivery.png",
                  title: "Today's delivery",
                  value: "245",
                ),
                _buildStatCard(
                  imagePath: "assets/images/today_earning.png",
                  title: "Today's Earnings",
                  value: "\$3.8k",
                ),
                _buildStatCard(
                  imagePath: "assets/images/active_drivers.png",
                  title: "Active drivers",
                  value: "39",
                ),
                _buildStatCard(
                  imagePath: "assets/images/running_loads.png",
                  title: "Running loads",
                  value: "98",
                ),
              ],
            ),

            RevenueGraph(), 
          ],
        ),
      ),
      drawer: CompanyDrawer(),
    );
  }

  Widget _buildStatCard({
    required String imagePath,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 48, height: 48),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
