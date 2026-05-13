import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard_screen.dart';
import 'kitchen_dashboard.dart';
import 'procurement_dashboard.dart';
import 'finance_dashboard.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedRole;
  bool _isLoading = false;

  final supabase = Supabase.instance.client;

  Future<void> _signUp() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      if (username.isEmpty || password.isEmpty || _selectedRole == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please fill all fields")),
        );
        setState(() => _isLoading = false);
        return;
      }

      // ✅ Insert into profiles table directly (no email)
      final response = await supabase.from('profiles').insert({
        'username': username,
        'password': password, // ⚠️ For demo only, hash in production!
        'role': _selectedRole,
      }).select().single();

      final role = response['role'];

      // ✅ Navigate to dashboard based on role
      if (role == 'Admin') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen()));
      } else if (role == 'Kitchen Staff') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => KitchenDashboard()));
      } else if (role == 'Procurement Officer') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProcurementDashboard()));
      } else if (role == 'Accountant') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FinanceDashboard()));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account created successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _usernameController, decoration: InputDecoration(labelText: "Username")),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: ['Admin', 'Kitchen Staff', 'Procurement Officer', 'Accountant']
                  .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedRole = val),
              decoration: InputDecoration(labelText: "Role"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _signUp,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Sign Up"),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text("Already have an account? Log in"),
            ),
          ],
        ),
      ),
    );
  }
}
