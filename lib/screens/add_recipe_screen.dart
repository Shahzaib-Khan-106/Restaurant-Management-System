import 'package:flutter/material.dart';
import '../services/recipe_service.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final nameController = TextEditingController();
  final ingredientController = TextEditingController();
  final quantityController = TextEditingController();
  final List<Map<String, dynamic>> ingredients = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Recipe")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Recipe Name"),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ingredientController,
                    decoration: const InputDecoration(labelText: "Ingredient"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(labelText: "Quantity"),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (ingredientController.text.isNotEmpty &&
                        quantityController.text.isNotEmpty) {
                      setState(() {
                        ingredients.add({
                          'name': ingredientController.text,
                          'quantity': int.parse(quantityController.text),
                        });
                        ingredientController.clear();
                        quantityController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...ingredients.map((ing) => ListTile(
                  title: Text(ing['name'] as String),
                  subtitle: Text("Qty: ${ing['quantity']}"),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () async {
                if (nameController.text.isNotEmpty && ingredients.isNotEmpty) {
                  try {
                    await RecipeService.addRecipe(
                        nameController.text, ingredients);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Recipe added successfully")),
                    );
                    Navigator.pop(context, true); // ✅ return success flag
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error saving recipe: $e")),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
