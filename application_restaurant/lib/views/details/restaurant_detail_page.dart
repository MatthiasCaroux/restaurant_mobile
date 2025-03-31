import 'package:flutter/material.dart';
import 'restaurant_header.dart';
import 'restaurant_map_section.dart';
import 'restaurant_contact_buttons.dart';
import 'restaurant_avis_section.dart';

class RestaurantDetailPage extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final imageName = (restaurant['nom_restaurant'] ?? '')
        .toString()
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('-', '_')
        .replaceAll(RegExp(r'[^a-z0-9_]'), '');

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Restaurant",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RestaurantHeader(
              nom: restaurant['nom_restaurant'],
              imageName: imageName,
            ),
            const SizedBox(height: 12),
            RestaurantMapSection(
              latitude: double.tryParse(restaurant['latitude']?.toString() ?? '0') ?? 0,
              longitude: double.tryParse(restaurant['longitude']?.toString() ?? '0') ?? 0,
              commune: restaurant['commune'] ?? '',
              departement: restaurant['departement'] ?? '',
            ),
            const SizedBox(height: 12),
            RestaurantContactButtons(
              telephone: restaurant['telephone_restaurant'] ?? '',
              type: restaurant['type_restaurant'] ?? '',
              departement: restaurant['departement'] ?? '',
            ),
            const SizedBox(height: 16),
            RestaurantAvisSection(idRestaurant: restaurant['id_restaurant'], ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
