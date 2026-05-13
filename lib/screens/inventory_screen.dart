import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/inventory_service.dart';
import 'add_item_screen.dart';
import 'orders_screen.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Item> items = [];
  bool sortAscending = true;
  int sortColumnIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final fetchedItems = await InventoryService.getInventory();
    setState(() {
      items = fetchedItems;
    });
  }

  // ✅ Insert into DB here only
  void _addItem(Item item) async {
    await InventoryService.addItem(item.name, item.unit, item.reorderPoint);
    await _loadItems(); // refresh after adding
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Management')),
      body: Column(
        children: [
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text("No items yet. Add some!"))
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        sortColumnIndex: sortColumnIndex,
                        sortAscending: sortAscending,
                        columns: const [
                          DataColumn(label: Text('Item Name')),
                          DataColumn(label: Text('Quantity'), numeric: true),
                          DataColumn(label: Text('Unit')),
                          DataColumn(label: Text('Reorder Point'), numeric: true),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: items.map((item) {
                          final needsReorder = item.quantity < item.reorderPoint;
                          return DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>(
                              (states) => needsReorder ? Colors.red[100] : null,
                            ),
                            cells: [
                              DataCell(Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                              DataCell(Text(item.quantity.toString())),
                              DataCell(Text(item.unit)),
                              DataCell(Text(item.reorderPoint.toString())),
                              DataCell(
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.update, size: 18),
                                  label: const Text("Update Stock"),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    textStyle: const TextStyle(fontSize: 12),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => OrdersScreen()),
                                    ).then((_) => _loadItems());
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add New Item"),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddItemScreen(onItemAdded: _addItem),
                  ),
                ).then((_) => _loadItems());
              },
            ),
          ),
        ],
      ),
    );
  }
}
