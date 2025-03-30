import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sae_mobile/views/bottom_navigation_bar.dart';

class ComptePage extends StatefulWidget {
  const ComptePage({super.key});

  @override
  State<ComptePage> createState() => _ComptePageState();
}

class _ComptePageState extends State<ComptePage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoginMode = true;
  bool _loading = false;
  String? _error;

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      if (_isLoginMode) {
        await Supabase.instance.client.auth.signInWithPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Connexion réussie !")),
        );
        await Future.delayed(const Duration(seconds: 1));
        setState(() {}); // Refresh
      } else {
        final response = await Supabase.instance.client.auth.signUp(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (!mounted) return;
        if (response.user != null) {
          setState(() {
        _error = "Un email de confirmation a été envoyé à votre adresse.";
          });
        }
      }
    } catch (e) {
      setState(() => _error = "Erreur : $e");
    } finally {
      setState(() => _loading = false);
    }
  }


  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
    setState(() {}); // Refresh page
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Bottom_Navigation_Bar(
      currentIndex: 4,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: user == null ? _buildAuthForm() : _buildProfile(user),
        ),
      ),
    );
  }

  Widget _buildAuthForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            _isLoginMode ? "Connexion" : "Inscription",
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
          const SizedBox(height: 16),
          if (_error != null)
            Text(_error!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 10),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? "Entrez un email" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Mot de passe",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) => value == null || value.length < 6
                      ? "Minimum 6 caractères"
                      : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _loading ? null : _handleAuth,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_isLoginMode ? "Se connecter" : "S'inscrire"),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLoginMode = !_isLoginMode;
                      _error = null;
                    });
                  },
                  child: Text(_isLoginMode
                      ? "Pas de compte ? S'inscrire"
                      : "Déjà un compte ? Se connecter"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile(User user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.account_circle, size: 80, color: Colors.white),
        const SizedBox(height: 16),
        Text("Connecté en tant que :", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 6),
        Text(user.email ?? "Email inconnu",
            style: TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _logout,
          child: const Text("Se déconnecter"),
        )
      ],
    );
  }
}
