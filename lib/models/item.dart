class Item {
  final String name;
  final double quantity;
  final String unit;
  final DateTime expiryDate;
  final double reorderPoint; // new field

  Item({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.expiryDate,
    required this.reorderPoint,
  });

  bool get isExpiringSoon {
    final now = DateTime.now();
    return expiryDate.difference(now).inDays <= 5;
  }

  bool get needsReorder {
    return quantity < reorderPoint;
  }
}
