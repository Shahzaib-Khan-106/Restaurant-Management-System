// finance_dashboard.dart
import 'package:flutter/material.dart';
import 'analytics_screen.dart';

class FinanceDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Finance Dashboard")),
      body: AnalyticsScreen(),
    );
  }
}
