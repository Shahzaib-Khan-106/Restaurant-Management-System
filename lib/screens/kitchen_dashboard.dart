// kitchen_dashboard.dart
import 'package:flutter/material.dart';
import 'inventory_screen.dart';
import 'recipe_screen.dart';

class KitchenDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kitchen Dashboard")),
      body: Column(
        children: [
          Expanded(child: InventoryScreen()),
          Expanded(child: RecipeScreen()),
        ],
      ),
    );
  }
}
