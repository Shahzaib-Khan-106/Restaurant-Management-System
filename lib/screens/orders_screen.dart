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
    final items = InventoryService.getInventory();
    final reorderItems = items.where((item) => item.needsReorder).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Orders & Suppliers')),
      body: reorderItems.isEmpty
          ? Center(child: Text('No items need reordering'))
          : ListView.builder(
              itemCount: reorderItems.length,
              itemBuilder: (context, index) {
                Item item = reorderItems[index];
                Supplier bestSupplier = OrderService.getBestSupplier(item);
                final suppliers = OrderService.getSuppliers(item);

                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Order ${item.name}'),
                        subtitle: Text('Best Supplier: ${bestSupplier.name}'),
                        trailing: ElevatedButton(
                          child: Text('Generate Order'),
                          onPressed: () {
                            final order = OrderService.generateOrder(item);
                            setState(() {
                              generatedOrders.add(
                                '${order.item.name} → ${order.supplier.name} | Qty: ${order.quantity} ${order.item.unit} | Total: \$${order.totalCost}',
                              );
                            });
                          },
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('Supplier')),
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
            ),
      bottomSheet: generatedOrders.isEmpty
          ? null
          : Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Generated Purchase Orders:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...generatedOrders.map((o) => Text(o)).toList(),
                ],
              ),
            ),
    );
  }
}
