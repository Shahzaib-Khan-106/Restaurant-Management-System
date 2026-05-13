import 'package:flutter/material.dart';

class Recipe {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Recipe({required this.name, required this.description, required this.price, required this.imageUrl});
}

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<Recipe> recipes = [
    Recipe(name: "Chicken Biryani", description: "Spicy rice with chicken", price: 350, imageUrl: "assets/biryani.jpg"),
    Recipe(name: "Beef Burger", description: "Juicy grilled burger", price: 250, imageUrl: "assets/burger.jpg"),
    Recipe(name: "Cold Coffee", description: "Refreshing iced coffee", price: 150, imageUrl: "assets/coffee.jpg"),
  ];

  final List<Recipe> cart = [];

  void _addToCart(Recipe recipe) {
    setState(() {
      cart.add(recipe);
    });
  }

  void _goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CartScreen(cart: cart)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _goToCart,
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      cart.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(recipe.imageUrl, fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("Rs. ${recipe.price}", style: const TextStyle(color: Colors.green)),
                      const SizedBox(height: 6),
                      ElevatedButton(
                        onPressed: () => _addToCart(recipe),
                        child: const Text("Add to Cart"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final List<Recipe> cart;
  CartScreen({required this.cart});

  @override
  Widget build(BuildContext context) {
    double total = cart.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final item = cart[index];
          return ListTile(
            leading: Image.asset(item.imageUrl, width: 50, fit: BoxFit.cover),
            title: Text(item.name),
            subtitle: Text("Rs. ${item.price}"),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // TODO: Checkout logic
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Order placed successfully!")),
            );
          },
          child: Text("Checkout (Rs. $total)"),
        ),
      ),
    );
  }
}
