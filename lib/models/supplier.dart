class Supplier {
  final String name;
  final double reliabilityScore; // 0–100
  final double costPerUnit;      // price per unit

  Supplier({
    required this.name,
    required this.reliabilityScore,
    required this.costPerUnit,
  });
}
