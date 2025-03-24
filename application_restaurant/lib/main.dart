import 'package:flutter/material.dart';
import 'myrouter.dart'; // Import the router
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(
    url: 'https://lmlcsjxhreswvnrdvhpp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxtbGNzanhocmVzd3ZucmR2aHBwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzczODY1MDYsImV4cCI6MjA1Mjk2MjUwNn0.rJQL8rMW2tasZf2iEg1s6uH2dAq9DuDBxF6MOodf0QY',
  ).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router, 
    );
  }

}
