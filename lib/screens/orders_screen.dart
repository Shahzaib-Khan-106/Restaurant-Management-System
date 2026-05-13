import 'package:flutter/material.dart';
import '../services/inventory_service.dart';
import '../services/order_service.dart';
import '../models/item.dart';
import '../models/supplier.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<String> generatedOrders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders & Suppliers')),
      body: FutureBuilder<List<Item>>(
        future: InventoryService.getInventory(), // ✅ async fetch
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final inventory = snapshot.data ?? [];
          final reorderItems = inventory.where((item) => item.needsReorder).toList();

          if (reorderItems.isEmpty) {
            return const Center(child: Text('No items need reordering'));
          }

          return ListView.builder(
            itemCount: reorderItems.length,
            itemBuilder: (context, index) {
              Item item = reorderItems[index];
              Supplier bestSupplier = OrderService.getBestSupplier(item);
              final suppliers = OrderService.getSuppliers(item);

              return Card(
                margin: const EdgeInsets.all(12),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Item header
                    ListTile(
                      title: Text(
                        'Item: ${item.name}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Quantity: ${item.quantity} ${item.unit} | Reorder Point: ${item.reorderPoint}',
                      ),
                      trailing: ElevatedButton(
                        child: const Text('Generate Order'),
                        onPressed: () async {
                          final order = OrderService.generateOrder(item);

                          // ✅ Update quantity in Supabase
                          await InventoryService.updateQuantity(
                            item.name,
                            item.quantity,
                          );

                          setState(() {
                            generatedOrders.add(
                              '${order.item.name} → ${order.supplier.name} | Qty: ${order.quantity} ${order.item.unit} | Total: \$${order.totalCost}',
                            );
                          });
                        },
                      ),
                    ),

                    // ✅ Supplier table
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Supplier')),
                          DataColumn(label: Text('Description')),
                          DataColumn(label: Text('Reliability')),
                          DataColumn(label: Text('Cost/Unit')),
                        ],
                        rows: suppliers.map((supplier) {
                          final isBest = supplier.name == bestSupplier.name;
                          return DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>(
                              (states) => isBest ? Colors.green[100] : null,
                            ),
                            cells: [
                              DataCell(Text(supplier.name)),
                              DataCell(Text(supplier.description)),
                              DataCell(Text('${supplier.reliabilityScore}%')),
                              DataCell(Text('\$${supplier.costPerUnit}')),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomSheet: generatedOrders.isEmpty
          ? null
          : Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Generated Purchase Orders:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...generatedOrders.map((o) => Text(o)).toList(),
                ],
              ),
            ),
    );
  }
}
