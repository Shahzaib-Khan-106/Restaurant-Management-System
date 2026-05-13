import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeService {
  static final supabase = Supabase.instance.client;

  // ✅ Add recipe with ingredients
  static Future<void> addRecipe(
      String name, List<Map<String, dynamic>> ingredients) async {
    // Insert recipe and get back the row
    final recipeResponse = await supabase
        .from('recipes')
        .insert({'name': name})
        .select()
        .single();

    final int recipeId = recipeResponse['id'] as int;

    // Insert each ingredient linked to recipe_id
    for (var ing in ingredients) {
      await supabase.from('recipe_ingredients').insert({
        'recipe_id': recipeId,
        'ingredient_name': ing['name'] as String,
        'quantity': (ing['quantity'] as num).toInt(),
      });
    }
  }

  // ✅ Fetch recipes with ingredients
  static Future<List<Map<String, dynamic>>> getRecipes() async {
    // Supabase returns List<Map<String, dynamic>>
    final List<Map<String, dynamic>> recipes =
        await supabase.from('recipes').select() as List<Map<String, dynamic>>;

    final List<Map<String, dynamic>> ingredients =
        await supabase.from('recipe_ingredients').select()
            as List<Map<String, dynamic>>;

    return recipes.map<Map<String, dynamic>>((recipe) {
      final recipeIngredients = ingredients
          .where((ing) => ing['recipe_id'] == recipe['id'])
          .map((ing) => {
                'ingredient_name': ing['ingredient_name'] as String,
                'quantity': (ing['quantity'] as num).toInt(),
              })
          .toList();

      return {
        'id': recipe['id'] as int,
        'name': recipe['name'] as String,
        'ingredients': recipeIngredients,
      };
    }).toList();
  }
}
