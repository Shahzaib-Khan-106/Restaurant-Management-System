import '../models/item.dart';
import '../models/supplier.dart';

class PurchaseOrder {
  final Item item;
  final Supplier supplier;
  final double quantity;
  final double totalCost;

  PurchaseOrder({
    required this.item,
    required this.supplier,
    required this.quantity,
    required this.totalCost,
  });
}

class OrderService {
  // ✅ Return suppliers with full details
  static List<Supplier> getSuppliers(Item item) {
    return [
      Supplier(
        name: 'FreshFoods Ltd',
        description: 'Organic vegetables and fruits supplier',
        contact: 'freshfoods@example.com',
        reliabilityScore: 90,
        costPerUnit: 5.0,
      ),
      Supplier(
        name: 'Budget Supplies',
        description: 'Affordable bulk food distributor',
        contact: 'budget@example.com',
        reliabilityScore: 70,
        costPerUnit: 4.0,
      ),
      Supplier(
        name: 'Premium Organics',
        description: 'High-quality organic produce supplier',
        contact: 'premium@example.com',
        reliabilityScore: 95,
        costPerUnit: 6.0,
      ),
    ];
  }

  // ✅ Best supplier logic: highest reliability, then lowest cost
  static Supplier getBestSupplier(Item item) {
    final suppliers = getSuppliers(item);

    suppliers.sort((a, b) {
      if (a.reliabilityScore == b.reliabilityScore) {
        return a.costPerUnit.compareTo(b.costPerUnit);
      }
      return b.reliabilityScore.compareTo(a.reliabilityScore);
    });

    return suppliers.first;
  }

  // ✅ Generate purchase order and update item quantity
  static PurchaseOrder generateOrder(Item item) {
    Supplier supplier = getBestSupplier(item);

    double orderQuantity = ((item.reorderPoint * 2) - item.quantity).toDouble();
    if (orderQuantity < 0) orderQuantity = 0;

    double totalCost = orderQuantity * supplier.costPerUnit;

    // Update item quantity after order
    item.quantity += orderQuantity.toInt();

    return PurchaseOrder(
      item: item,
      supplier: supplier,
      quantity: orderQuantity,
      totalCost: totalCost,
    );
  }
}
