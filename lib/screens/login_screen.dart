import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard_screen.dart';
import 'kitchen_dashboard.dart';
import 'procurement_dashboard.dart';
import 'finance_dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final supabase = Supabase.instance.client;

  String? _errorMessage; // ✅ holds error text

  Future<void> _login() async {
    setState(() => _errorMessage = null); // clear old error

    try {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      if (username.isEmpty || password.isEmpty) {
        setState(() => _errorMessage = "Please enter username and password");
        return;
      }

      // ✅ Try to fetch user by username
      final response = await supabase
          .from('profiles')
          .select('role, password')
          .eq('username', username)
          .maybeSingle();

      if (response == null) {
        setState(() => _errorMessage = "Either username or password is wrong");
        return;
      }

      if (response['password'] != password) {
        setState(() => _errorMessage = "Either username or password is wrong");
        return;
      }

      // ✅ Correct username & password → navigate by role
      final role = response['role'];
      if (role == 'Admin') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen()));
      } else if (role == 'Kitchen Staff') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => KitchenDashboard()));
      } else if (role == 'Procurement Officer') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProcurementDashboard()));
      } else if (role == 'Accountant') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FinanceDashboard()));
      }

    } catch (e) {
      setState(() => _errorMessage = "Login failed: $e");
    }
  }

  void _goToSignUp() {
    Navigator.pushNamed(context, '/signup');
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
                const Text(
                  "Welcome to Restaurant System",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 15),

                // ✅ Error message inline
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),

                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text("Login"),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _goToSignUp,
                  child: const Text("Don't have an account? Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
