import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseView extends StatelessWidget {
  const DatabaseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database View'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await Supabase.initialize(
              url: 'https://lmlcsjxhreswvnrdvhpp.supabase.co', 
              anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxtbGNzanhocmVzd3ZucmR2aHBwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzczODY1MDYsImV4cCI6MjA1Mjk2MjUwNn0.rJQL8rMW2tasZf2iEg1s6uH2dAq9DuDBxF6MOodf0QY', // Replace with your public key
            );
            final client = Supabase.instance.client;

            try {
              final response = await client.auth.signInWithPassword(
                email: 'postgres.lmlcsjxhreswvnrdvhpp', // Replace with your email
                password: 'faitleloup', // Replace with your password
              );

              if (response.user != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Connexion réussie : ${response.user!.email}')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Échec de la connexion')),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erreur lors de la connexion : $e')),
              );
            }
          },
          child: const Text('Connect to Database'),
        ),
      ),
    );
  }
}
