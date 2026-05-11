import '../models/item.dart';
import '../models/recipe.dart';
import '../services/inventory_service.dart';

class RecipeForecaster {
  static List<Recipe> getRecipes() {
    return [
      Recipe(name: 'Tomato Pasta', ingredients: {
        'Tomatoes': 5,
        'Olive Oil': 1,
        'Cheese': 2,
      }),
      Recipe(name: 'Cheese Pizza', ingredients: {
        'Cheese': 4,
        'Tomatoes': 3,
        'Olive Oil': 1,
      }),
    ];
  }

  static bool canPrepare(Recipe recipe) {
    final inventory = InventoryService.getInventory();

    for (var entry in recipe.ingredients.entries) {
      final item = inventory.firstWhere(
        (i) => i.name == entry.key,
        orElse: () => Item(
          name: entry.key,
          quantity: 0,
          unit: '',
          expiryDate: DateTime.now(),
          reorderPoint: 0,
        ),
      );

      if (item.quantity < entry.value) {
        return false;
      }
    }
    return true;
  }
}
