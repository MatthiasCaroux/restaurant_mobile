import 'package:flutter/material.dart';
import 'package:sae_mobile/database/fetch_function.dart';

class RestaurantAvisSection extends StatelessWidget {
  final int idRestaurant;

  const RestaurantAvisSection({super.key, required this.idRestaurant});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: FetchFunction.fetchAvis(),
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

            final avisList = snapshot.data!
                .where((avis) => avis['id_restaurant'] == idRestaurant)
                .toList();

            final moyenne = avisList.isNotEmpty
                ? avisList
                .map((a) => a['note'] ?? 0)
                .reduce((a, b) => a + b) /
                avisList.length
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
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          avis['titre'] ?? 'Sans titre',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          avis['text'] ?? '',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
