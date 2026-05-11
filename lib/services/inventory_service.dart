import '../models/item.dart';

class InventoryService {
  static List<Item> getInventory() {
    return [
      Item(name: 'Tomatoes', quantity: 20, unit: 'kg', expiryDate: DateTime(2026, 5, 12), reorderPoint: 10),
      Item(name: 'Cheese', quantity: 5, unit: 'kg', expiryDate: DateTime(2026, 5, 20), reorderPoint: 8),
      Item(name: 'Olive Oil', quantity: 10, unit: 'liters', expiryDate: DateTime(2027, 1, 1), reorderPoint: 5),
    ];
  }
}
