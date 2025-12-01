import 'package:flutter/material.dart';

import '../widgets/activity_body.dart';

class ActivityScreen extends StatelessWidget {
  final bool embed;

  const ActivityScreen({Key? key, this.embed = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (embed) return const SizedBox.expand(child: ActivityBody());
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Activity',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: const ActivityBody(),
    );
  }
}