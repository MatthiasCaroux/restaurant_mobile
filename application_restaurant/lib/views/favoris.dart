import 'package:flutter/material.dart';
import 'package:sae_mobile/database/fetch_function.dart';
import 'package:sae_mobile/views/bottom_navigation_bar.dart';
import 'package:sae_mobile/views/details/restaurant_detail_page.dart';

class FavorisPage extends StatelessWidget {
  const FavorisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Bottom_Navigation_Bar(
      currentIndex: 0,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: FetchFunction.fetchFavoriteRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur lors du chargement des favoris : ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'Aucun restaurant favori trouvé',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ajoutez des restaurants à vos favoris\npour les retrouver ici',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final favoriteRestaurants = snapshot.data!;

          return ListView.builder(
            itemCount: favoriteRestaurants.length,
            itemBuilder: (context, index) {
              final restaurant = favoriteRestaurants[index];
              final restaurantName = (restaurant['nom_restaurant'] ?? 'inconnu')
                  .toString()
                  .toLowerCase()
                  .replaceAll(' ', '_')
                  .replaceAll('-', '_')
                  .replaceAll(RegExp(r'[^a-z0-9_]'), '');

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              RestaurantDetailPage(restaurant: restaurant),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
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
                                  child: const Icon(Icons.restaurant, size: 40),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              restaurant['nom_restaurant'] ?? 'Nom inconnu',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
