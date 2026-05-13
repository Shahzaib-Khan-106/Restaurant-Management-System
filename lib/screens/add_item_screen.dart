import 'package:flutter/material.dart';
import '../models/item.dart';

class AddItemScreen extends StatefulWidget {
  final Function(Item) onItemAdded;

  AddItemScreen({required this.onItemAdded});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _reorderController = TextEditingController();
  String _selectedUnit = 'kg';

  final List<String> units = ['kg', 'liters', 'pieces'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Item")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Item Name"),
                validator: (value) => value!.isEmpty ? "Enter item name" : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedUnit,
                items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                onChanged: (val) => setState(() => _selectedUnit = val!),
                decoration: const InputDecoration(labelText: "Unit"),
              ),
              TextFormField(
                controller: _reorderController,
                decoration: const InputDecoration(labelText: "Reorder Point"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter reorder point" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text("Add Item"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final item = Item(
                      name: _nameController.text,
                      unit: _selectedUnit,
                      reorderPoint: int.parse(_reorderController.text),
                      quantity: 0,
                    );
                    // ✅ Only pass item back, no DB insert here
                    widget.onItemAdded(item);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
