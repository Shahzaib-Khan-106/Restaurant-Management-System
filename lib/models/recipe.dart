import 'item.dart';

class Recipe {
  final String name;
  final Map<String, double> ingredients; // ingredient name → required quantity

  Recipe({
    required this.name,
    required this.ingredients,
  });
}
