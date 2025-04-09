import 'package:flutter/material.dart';
import 'package:sae_mobile/database/fetch_function.dart';

class DatabaseView extends StatelessWidget {
  const DatabaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des Avis')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: FetchFunction.fetchRestaurant(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun avis trouvé.'));
          }

          final avisList = snapshot.data!;
          return ListView.builder(
            itemCount: avisList.length,
            itemBuilder: (context, index) {
              final avis = avisList[index];
              return ListTile(
                title: Text(avis['nom_restaurant'] ?? 'Avis sans texte'),
                subtitle: Text('ID: ${avis['id'] ?? 'Inconnu'}'),
              );
            },
          );
        },
      ),
    );
  }
}
