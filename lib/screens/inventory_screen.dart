import 'package:flutter/material.dart';
import '../services/inventory_service.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool sortAscending = true;
  int sortColumnIndex = 0;

  @override
  Widget build(BuildContext context) {
    final items = InventoryService.getInventory();

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Management')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              sortColumnIndex: sortColumnIndex,
              sortAscending: sortAscending,
              columns: [
                DataColumn(
                  label: const Text('Item Name'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      sortColumnIndex = columnIndex;
                      sortAscending = ascending;
                      items.sort((a, b) => ascending
                          ? a.name.compareTo(b.name)
                          : b.name.compareTo(a.name));
                    });
                  },
                ),
                DataColumn(
                  label: const Text('Quantity'),
                  numeric: true,
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      sortColumnIndex = columnIndex;
                      sortAscending = ascending;
                      items.sort((a, b) => ascending
                          ? a.quantity.compareTo(b.quantity)
                          : b.quantity.compareTo(a.quantity));
                    });
                  },
                ),
                const DataColumn(label: Text('Unit')),
                DataColumn(
                  label: const Text('Expiry Date'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      sortColumnIndex = columnIndex;
                      sortAscending = ascending;
                      items.sort((a, b) => ascending
                          ? a.expiryDate.compareTo(b.expiryDate)
                          : b.expiryDate.compareTo(a.expiryDate));
                    });
                  },
                ),
                DataColumn(
                  label: const Text('Reorder Point'),
                  numeric: true,
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      sortColumnIndex = columnIndex;
                      sortAscending = ascending;
                      items.sort((a, b) => ascending
                          ? a.reorderPoint.compareTo(b.reorderPoint)
                          : b.reorderPoint.compareTo(a.reorderPoint));
                    });
                  },
                ),
              ],
              rows: items.map((item) {
                final isExpiring = item.isExpiringSoon;
                final needsReorder = item.needsReorder;

                return DataRow(
                  color: MaterialStateProperty.resolveWith<Color?>(
                    (states) {
                      if (isExpiring) return Colors.red[100];
                      if (needsReorder) return Colors.orange[100];
                      return null;
                    },
                  ),
                  cells: [
                    DataCell(Text(item.name)),
                    DataCell(Text(item.quantity.toString())),
                    DataCell(Text(item.unit)),
                    DataCell(Text(item.expiryDate.toLocal().toString().split(" ")[0])),
                    DataCell(Text(item.reorderPoint.toString())),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
