import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../database/insert_function.dart';

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connexion"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: "Nom d'utilisateur"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Entrez votre nom d'utilisateur";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "Mot de passe"),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Entrez votre mot de passe";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Logique de connexion
                      context.go('/');
                    }
                  },
                  child: Text("Se connecter"),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    context.go('/register');
                  },
                  child: Text("Pas inscrit ? Inscrivez-vous"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}