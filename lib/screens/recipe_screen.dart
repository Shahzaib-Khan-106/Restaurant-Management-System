import 'package:flutter/material.dart';
import '../utils/recipe_forecaster.dart';
import '../models/recipe.dart';

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final recipes = RecipeForecaster.getRecipes();

    // Filter recipes by search query (name or ingredient)
    final filteredRecipes = recipes.where((recipe) {
      final nameMatch = recipe.name.toLowerCase().contains(searchQuery.toLowerCase());
      final ingredientMatch = recipe.ingredients.keys.any(
        (ingredient) => ingredient.toLowerCase().contains(searchQuery.toLowerCase()),
      );
      return nameMatch || ingredientMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Recipe Forecasting')),
      body: Column(
        children: [
          // ✅ Search bar
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
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
            child: ListView.builder(
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                Recipe recipe = filteredRecipes[index];
                bool available = RecipeForecaster.canPrepare(recipe);

                return Card(
                  child: ListTile(
                    title: Text(recipe.name),
                    subtitle: Text(
                      recipe.ingredients.entries
                          .map((e) => '${e.key}: ${e.value}')
                          .join(', '),
                    ),
                    trailing: available
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.error, color: Colors.red),
                  ),
                );
              },
            ),
          ),

          // ✅ Summary box
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text('Summary:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Available Recipes: ${filteredRecipes.where((r) => RecipeForecaster.canPrepare(r)).map((r) => r.name).join(", ")}'),
                Text('Blocked Recipes: ${filteredRecipes.where((r) => !RecipeForecaster.canPrepare(r)).map((r) => r.name).join(", ")}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
