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
 
  static List<Supplier> getSuppliers(Item item) {
    return [
      Supplier(name: 'FreshFoods Ltd', reliabilityScore: 90, costPerUnit: 5.0),
      Supplier(name: 'Budget Supplies', reliabilityScore: 70, costPerUnit: 4.0),
      Supplier(name: 'Premium Organics', reliabilityScore: 95, costPerUnit: 6.0),
    ];
  }

  
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

 
  static PurchaseOrder generateOrder(Item item) {
    Supplier supplier = getBestSupplier(item);

    // Example logic: order enough to reach double the reorder point
    double orderQuantity = (item.reorderPoint * 2) - item.quantity;
    if (orderQuantity < 0) orderQuantity = 0;

    double totalCost = orderQuantity * supplier.costPerUnit;

    return PurchaseOrder(
      item: item,
      supplier: supplier,
      quantity: orderQuantity,
      totalCost: totalCost,
    );
  }
}
