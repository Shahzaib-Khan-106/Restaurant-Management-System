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

  // ✅ Make this async because inventory fetch is async
  static Future<bool> canPrepare(Recipe recipe) async {
    final inventory = await InventoryService.getInventory(); // wait for DB

    for (var entry in recipe.ingredients.entries) {
      final item = inventory.firstWhere(
        (i) => i.name == entry.key,
        orElse: () => Item(
          name: entry.key,
          quantity: 0,
          unit: '',
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
