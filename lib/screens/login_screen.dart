import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'inventory_screen.dart';
import 'recipe_screen.dart';
import 'orders_screen.dart';
import 'suppliers_screen.dart';
import 'analytics_screen.dart';
import 'kitchen_dashboard.dart';
import 'procurement_dashboard.dart';
import 'finance_dashboard.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRole = "Admin";

  void _login() {
    // ✅ Role-based navigation (frontend only for now)
    if (selectedRole == "Admin") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen()));
    } else if (selectedRole == "Kitchen Staff") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => KitchenDashboard()));
    } else if (selectedRole == "Procurement Officer") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProcurementDashboard()));
    } else if (selectedRole == "Accountant") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FinanceDashboard()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restaurant Login")),
      body: Center(
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Welcome to Restaurant System",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 15),
                DropdownButton<String>(
                  value: selectedRole,
                  items: ["Admin", "Kitchen Staff", "Procurement Officer", "Accountant"]
                      .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                      .toList(),
                  onChanged: (value) => setState(() => selectedRole = value!),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
