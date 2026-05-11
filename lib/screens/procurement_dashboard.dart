// procurement_dashboard.dart
import 'package:flutter/material.dart';
import 'orders_screen.dart';
import 'suppliers_screen.dart';

class ProcurementDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Procurement Dashboard")),
      body: Column(
        children: [
          Expanded(child: OrdersScreen()),
          Expanded(child: SuppliersScreen()),
        ],
      ),
    );
  }
}
