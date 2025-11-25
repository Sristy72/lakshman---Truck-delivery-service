import 'package:flutter/material.dart';

class ActivityController extends ChangeNotifier {
  bool _isLoading = false;
  
  bool get isLoading => _isLoading;

  // Mock data - replace with actual data later
  String userName = 'Michael Ken';
  String userRole = 'Supervisor';
  
  // Period and checkpoint tracking
  String _period = 'Weekly';
  String get period => _period;
  
  late int _checkpoints;
  int get checkpoints => _checkpoints;

  // Checkpoint data for different periods
  final Map<String, int> checkpointsByPeriod = {
    'Daily': 28,
    'Weekly': 198,
    'Monthly': 842,
  };

  List<Map<String, String>> activities = List.generate(8, (i) => {
    'id': '#nod_45693',
    'description': 'Medical equipment',
    'status': 'hellopublic.in',
    'location': 'Chicago, IL',
  });

  ActivityController() {
    _checkpoints = checkpointsByPeriod['Weekly'] ?? 198;
  }

  void loadData() {
    _isLoading = true;
    notifyListeners();

    // Simulate loading
    Future.delayed(Duration(milliseconds: 500), () {
      _isLoading = false;
      notifyListeners();
    });
  }

  void changePeriod(String newPeriod) {
    _period = newPeriod;
    _checkpoints = checkpointsByPeriod[newPeriod] ?? 198;
    notifyListeners();
  }
}