import 'package:flutter/material.dart';
import 'inventory_screen.dart';
import 'recipe_screen.dart';
import 'orders_screen.dart';
import 'MenuScreen.dart'; 

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Inventory Management'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InventoryScreen()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Recipe Management'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecipeScreen()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Orders & Suppliers'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersScreen()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Menu (Customer Storefront)'), 
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
