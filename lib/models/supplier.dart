class Supplier {
  final String name;
  final String description;   // ✅ Added
  final String contact;       // ✅ Optional contact info
  final int reliabilityScore; // ✅ Reliability percentage
  final double costPerUnit;   // ✅ Cost per unit

  Supplier({
    required this.name,
    required this.description,
    required this.contact,
    required this.reliabilityScore,
    required this.costPerUnit,
  });
}
