import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseView extends StatelessWidget {
  Future<List<Map<String, dynamic>>> _fetchAvis() async {
    try {
      final response = await Supabase.instance.client.from('Avis').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Erreur lors de la récupération des avis : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des Avis')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchAvis(),
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
                title: Text(avis['text'] ?? 'Avis sans texte'),
                subtitle: Text('ID: ${avis['id'] ?? 'Inconnu'}'),
              );
            },
          );
        },
      ),
    );
  }
}