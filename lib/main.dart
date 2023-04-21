import 'package:flutter/material.dart';
import 'package:restaurant_user/ui/screens/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main(List<String> args) async {
  await Supabase.initialize(
    url: 'https://ouxnzpjfykvvbhabdwrw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91eG56cGpmeWt2dmJoYWJkd3J3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3ODY5NzU5MSwiZXhwIjoxOTk0MjczNTkxfQ.FdDNwBJqThFpU_mrlOBCxGmH7gFhatijCzccuS54-Xs',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        inputDecorationTheme: InputDecorationTheme(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          fillColor: Colors.green[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.green[900]!,
              width: 0.5,
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
