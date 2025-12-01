import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/skeleton_loader.dart';

import '../controller/activitry_controller.dart';
import 'activity_list_widgets.dart';
import 'user_stats_widget.dart';

/// Embeddable activity body used inside an IndexedStack page.
/// Keeps a local [ActivityController] and shows a loader while data loads.
class ActivityBody extends StatefulWidget {
  const ActivityBody({Key? key}) : super(key: key);

  @override
  State<ActivityBody> createState() => _ActivityBodyState();
}

class _ActivityBodyState extends State<ActivityBody> {
  late ActivityController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ActivityController();
    _controller.loadData();
  }

  @override
  void dispose() {
    // Properly dispose the controller to stop background geocoding
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return UserStatsWidget(controller: _controller);
          },
        ),
        Expanded(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              if (_controller.isLoading) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 5,
                  itemBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: SkeletonListItem(
                      hasLeading: false,
                      lines: 3,
                    ),
                  ),
                );
              }
              return ActivityListWidget(controller: _controller);
            },
          ),
        ),
      ],
    );
  }
}
