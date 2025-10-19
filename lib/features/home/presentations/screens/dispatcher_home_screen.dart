import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/dispatcher_home_widgets/header_section.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/dispatcher_home_widgets/recent_section.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/dispatcher_home_widgets/stats_section.dart';

class DispatcherHomeScreen extends StatelessWidget {
  const DispatcherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              HeaderSection(),
              SizedBox(height: 20),
              StatsSection(),
              SizedBox(height: 24),
              RecentSection(),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: const _BottomNavBar(),
    );
  }
}
