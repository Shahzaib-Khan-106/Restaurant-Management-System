import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/item.dart';

class InventoryService {
  static final supabase = Supabase.instance.client;

  // ✅ Insert item into Supabase
  static Future<void> addItem(String name, String unit, int reorderPoint) async {
    await supabase.from('items').insert({
      'name': name,
      'unit': unit,
      'quantity': 0,
      'reorder_point': reorderPoint,
    });
  }

  // ✅ Fetch items from Supabase
  static Future<List<Item>> getInventory() async {
    final response = await supabase.from('items').select();
    return response.map<Item>((row) {
      return Item(
        name: row['name'],
        unit: row['unit'],
        quantity: row['quantity'],
        reorderPoint: row['reorder_point'],
      );
    }).toList();
  }

  // ✅ Update item quantity
  static Future<void> updateQuantity(String name, int newQuantity) async {
    await supabase
        .from('items')
        .update({'quantity': newQuantity})
        .eq('name', name);
  }
}
