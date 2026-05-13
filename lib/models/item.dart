class Item {
  final String name;
  final String unit;
  int quantity;
  final int reorderPoint;

  Item({
    required this.name,
    required this.unit,
    this.quantity = 0,
    required this.reorderPoint,
  });

  bool get needsReorder => quantity < reorderPoint;
}
