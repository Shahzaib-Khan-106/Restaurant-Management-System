import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; // ✅ for firstWhereOrNull
import '../services/recipe_service.dart';
import '../services/inventory_service.dart';
import '../models/item.dart';
import 'add_recipe_screen.dart'; // ✅ import the new screen

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  String searchQuery = '';
  late Future<List<Map<String, dynamic>>> _recipesFuture;

  @override
  void initState() {
    super.initState();
    _recipesFuture = RecipeService.getRecipes();
  }

  Future<void> _refreshRecipes() async {
    final newFuture = RecipeService.getRecipes();
    setState(() {
      _recipesFuture = newFuture;
    });
  }

  // ✅ Forecast availability
  Future<bool> _canPrepare(Map<String, dynamic> recipe) async {
    final inventory = await InventoryService.getInventory();
    final List<Map<String, dynamic>> ingredients =
        recipe['ingredients'] as List<Map<String, dynamic>>;

    for (var ing in ingredients) {
      final item = inventory.firstWhereOrNull(
        (i) => i.name.toLowerCase() ==
            (ing['ingredient_name'] as String).toLowerCase(),
      );
      if (item == null ||
          item.quantity < (ing['quantity'] as num).toInt()) {
        return false;
      }
    }
    return true;
  }

  // ✅ Cook recipe (deduct stock)
  Future<void> _cookRecipe(Map<String, dynamic> recipe) async {
    final inventory = await InventoryService.getInventory();
    final List<Map<String, dynamic>> ingredients =
        recipe['ingredients'] as List<Map<String, dynamic>>;

    for (var ing in ingredients) {
      final item = inventory.firstWhereOrNull(
        (i) => i.name.toLowerCase() ==
            (ing['ingredient_name'] as String).toLowerCase(),
      );
      if (item != null) {
        final requiredQty = (ing['quantity'] as num).toInt();
        final newQuantity = item.quantity - requiredQty;
        await InventoryService.updateQuantity(item.name, newQuantity);
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${recipe['name']} cooked! Ingredients deducted.")),
    );
    await _refreshRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // ✅ Navigate to AddRecipeScreen
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddRecipeScreen()),
              );
              if (result == true) {
                await _refreshRecipes(); // ✅ refresh when coming back
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ✅ Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Recipes',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // ✅ Recipe list
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _recipesFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final recipes = snapshot.data!;
                final filteredRecipes = recipes.where((recipe) {
                  final nameMatch = (recipe['name'] as String)
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
                  final ingredientMatch =
                      (recipe['ingredients'] as List<Map<String, dynamic>>)
                          .any((ing) => (ing['ingredient_name'] as String)
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()));
                  return nameMatch || ingredientMatch;
                }).toList();

                return ListView.builder(
                  itemCount: filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = filteredRecipes[index];
                    return FutureBuilder<bool>(
                      future: _canPrepare(recipe),
                      builder: (context, snap) {
                        final available = snap.data ?? false;
                        return Card(
                          child: ListTile(
                            title: Text(recipe['name'] as String),
                            subtitle: Text(
                              (recipe['ingredients']
                                      as List<Map<String, dynamic>>)
                                  .map((ing) =>
                                      "${ing['ingredient_name']}: ${ing['quantity']}")
                                  .join(', '),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  available
                                      ? Icons.check_circle
                                      : Icons.error,
                                  color:
                                      available ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  child: const Text("Cook"),
                                  onPressed: available
                                      ? () => _cookRecipe(recipe)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
