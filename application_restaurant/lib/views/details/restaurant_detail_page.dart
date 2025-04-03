import 'package:flutter/material.dart';
import 'restaurant_header.dart';
import 'restaurant_map_section.dart';
import 'restaurant_contact_buttons.dart';
import 'restaurant_avis_section.dart';
import '../../database/insert_function.dart';

class RestaurantDetailPage extends StatefulWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  void _loadFavoriteStatus() async {
    final idUtilisateur = 1; // À remplacer plus tard par l'utilisateur connecté
    final idRestaurant = widget.restaurant['id_restaurant'];

    try {
      final favori = await InsertFunction.isRestaurantFavori(
        idUtilisateur: idUtilisateur,
        idRestaurant: idRestaurant,
      );

      setState(() {
        isFavorite = favori;
      });
    } catch (e) {
      print('Erreur lors du chargement des favoris : $e');
    }
  }

  void toggleFavorite() async {
    final idUtilisateur = 1;
    final idRestaurant = widget.restaurant['id_restaurant'];

    setState(() {
      isFavorite = !isFavorite;
    });

    try {
      await InsertFunction.toggleFavori(
        idUtilisateur: idUtilisateur,
        idRestaurant: idRestaurant,
        isFavorite: isFavorite,
      );
    } catch (e) {
      print("Erreur favoris : $e");
    }

    print(
        '${widget.restaurant['nom_restaurant']} est ${isFavorite ? 'ajouté' : 'retiré'} des favoris');
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = widget.restaurant;

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
        title: const Text("Restaurant", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: toggleFavorite,
          )
        ],
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
              latitude:
                  double.tryParse(restaurant['latitude']?.toString() ?? '0') ??
                      0,
              longitude:
                  double.tryParse(restaurant['longitude']?.toString() ?? '0') ??
                      0,
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
            RestaurantAvisSection(idRestaurant: restaurant['id_restaurant']),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
