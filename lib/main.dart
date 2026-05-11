import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Supabase with your project credentials
  await Supabase.initialize(
    url: 'https://gjajzhgdjpleojhlyrwn.supabase.co',   // Your Project URL
    anonKey: 'sb_publishable_uTCO8nTkP9FDifq6hbLGOg_1z7V4B4z', // Your Anon/Public Key
  );

  // ✅ Test query: fetch all rows from "users" table
  try {
    final response = await Supabase.instance.client
    .from('users')
    .select();

print("Supabase test response: $response");


  } catch (error) {
    print("Supabase connection error: $error");
  }

  runApp(RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // ✅ Primary brand color
        primarySwatch: Colors.deepPurple,

        // ✅ AppBar styling
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // ✅ Button styling
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),

        // ✅ Text styling
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),

      // ✅ Entry point
      home: LoginScreen(),
    );
  }
}
