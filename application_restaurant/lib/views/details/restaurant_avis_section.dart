import 'package:flutter/material.dart';
import 'package:sae_mobile/database/fetch_function.dart';
import 'package:sae_mobile/database/insert_function.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RestaurantAvisSection extends StatefulWidget {
  final int idRestaurant;

  const RestaurantAvisSection({super.key, required this.idRestaurant});

  @override
  _RestaurantAvisSectionState createState() => _RestaurantAvisSectionState();
}

class _RestaurantAvisSectionState extends State<RestaurantAvisSection> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  double _rating = 3.0;
  final supabase = Supabase.instance.client;

  Future<void> _submitAvis() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Utilisateur non connecté.')),
      );
      return;
    }

    // Récupération de l'ID utilisateur
    final userData = await FetchFunction.fetchUtilisateurByEmail(user.email ?? '');
    final user_id = userData?['id']; 

    if (user_id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur : Utilisateur non trouvé.')),
      );
      return;
    }

    print("User ID: $user_id");
    print("Email utilisateur : ${user.email}");

    if (_formKey.currentState!.validate()) {
      await InsertFunction.insertAvis(
        text: _textController.text,
        note: _rating.toInt(),
        titre: _titleController.text,
      );

      final idAvis = await FetchFunction.fetchLastAvisId();
      if (idAvis != null) {
        await InsertFunction.insertDeposer(user_id, widget.idRestaurant, idAvis);
        setState(() {});
        _titleController.clear();
        _textController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avis ajouté avec succès !')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.idRestaurant);

    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: FetchFunction.fetchAvisParRestaurant(widget.idRestaurant),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Erreur: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("Aucun avis pour ce restaurant.",
                      style: TextStyle(color: Colors.white70));
                }

                final avisList = snapshot.data!;
                final moyenne = avisList.isNotEmpty
                    ? avisList.map((a) => a['note'] ?? 0).reduce((a, b) => a + b) / avisList.length
                    : 0;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text("Avis",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text(
                          "${moyenne.toStringAsFixed(1)} ★",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.amberAccent),
                        ),
                        const SizedBox(width: 6),
                        Text("(${avisList.length} avis)",
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...avisList.map((avis) {
                      return Card(
                        color: Colors.grey[850],
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                avis['Titre'] ?? 'Sans titre',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    avis['Utilisateur']?['username'] ?? 'Anonyme',
                                    style: const TextStyle(color: Colors.white54),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${avis['note']} ★",
                                    style: const TextStyle(color: Colors.amberAccent),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                avis['text'] ?? '',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
            const Divider(color: Colors.white24),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Ajouter un avis",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Titre de l'avis...",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un titre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _rating,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _rating.toString(),
                    onChanged: (value) {
                      setState(() {
                        _rating = value;
                      });
                    },
                  ),
                  TextFormField(
                    controller: _textController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Votre avis...",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un avis';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _submitAvis,
                    child: const Text("Soumettre"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
