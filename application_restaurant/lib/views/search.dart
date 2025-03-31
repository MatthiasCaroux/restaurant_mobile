import 'package:flutter/material.dart';
import 'package:sae_mobile/database/fetch_function.dart';
import 'package:sae_mobile/views/bottom_navigation_bar.dart';
import 'details/restaurant_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = '';
  List<Map<String, dynamic>> filteredRestaurants = [];

  @override
  Widget build(BuildContext context) {
    return Bottom_Navigation_Bar(
      currentIndex: 1, // 1 = Search
      child: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(color: Colors.white), // Texte en blanc
              decoration: InputDecoration(
                hintText: 'Rechercher un restaurant...',
                hintStyle: const TextStyle(
                    color: Colors.white70), // Texte d'indice en blanc/gris
                prefixIcon: const Icon(Icons.search,
                    color: Colors.white), // Icône en blanc
                filled: true,
                fillColor: Colors.black54, // Fond de la barre de recherche
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none, // Pas de bordure
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: FetchFunction.fetchRestaurant(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erreur lors du chargement des restaurants : ${snapshot.error}',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Aucun restaurant trouvé.',
                      style: TextStyle(color: Colors.orangeAccent),
                    ),
                  );
                }

                final restaurantList = snapshot.data!;
                filteredRestaurants = restaurantList.where((restaurant) {
                  final name = (restaurant['nom_restaurant'] ?? '')
                      .toString()
                      .toLowerCase();
                  return name.contains(searchQuery);
                }).toList();

                return ListView.builder(
                  itemCount: filteredRestaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = filteredRestaurants[index];
                    final restaurantName =
                        (restaurant['nom_restaurant'] ?? 'inconnu')
                            .toString()
                            .toLowerCase()
                            .replaceAll(' ', '_')
                            .replaceAll('-', '_')
                            .replaceAll(RegExp(r'[^a-z0-9_]'), '');

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SizedBox(
                          height: 120,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                child: Image.asset(
                                  'assets/images/restaurants_images/$restaurantName.jpg',
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 120,
                                      height: 120,
                                      color: Colors.grey,
                                      child: const Icon(Icons.restaurant),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        restaurant['nom_restaurant'] ??
                                            'Nom inconnu',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Type : ${restaurant['type'] ?? 'Non renseigné'}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RestaurantDetailPage(
                                          restaurant: restaurant),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
