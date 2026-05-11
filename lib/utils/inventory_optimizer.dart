import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inventory Management')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Tomatoes'),
            subtitle: Text('Stock: 20kg | Expiry: 12 May'),
          ),
          ListTile(
            title: Text('Cheese'),
            subtitle: Text('Stock: 5kg | Expiry: 20 May'),
          ),
        ],
      ),
    );
  }
}
