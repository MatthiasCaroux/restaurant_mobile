import 'package:flutter/material.dart';
import 'package:sae_mobile/database/fetch_function.dart';
import 'package:sae_mobile/views/bottom_navigation_bar.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Bottom_Navigation_Bar(
      currentIndex: 2,
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
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header profil
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('arthur.jpeg'),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Bonjour Arthur",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "On mange où aujourd'hui ?",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () => context.go('/database'),
                        child: const Text('Database'),
                      ),

                      // --- CATEGORIES ---
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Catégories",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(3, (index) {
                          return Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(right: index < 2 ? 8.0 : 0.0),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                      child: Image.asset(
                                        'fastfood.jpg',
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Catégorie ${index + 1}"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      // --- TYPES DE CUISINE ---
                      const Padding(
                        padding: EdgeInsets.only(top: 30.0),
                        child: Text(
                          "Type de cuisine",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: FetchFunction.fetchTypeCuisine(),
                        builder: (context, typeSnapshot) {
                          if (typeSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (typeSnapshot.hasError) {
                            return Center(
                              child: Text(
                                'Erreur lors du chargement des types de cuisine : ${typeSnapshot.error}',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            );
                          } else if (!typeSnapshot.hasData ||
                              typeSnapshot.data!.isEmpty) {
                            return const Text(
                              "Aucun type de cuisine trouvé.",
                              style: TextStyle(color: Colors.orangeAccent),
                            );
                          }

                          final typeList = typeSnapshot.data!;
                          return SizedBox(
                            height: 160,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: typeList.map((typeCuisine) {
                                  final type =
                                      typeCuisine['nom_type_cuisine'] ??
                                          'inconnu';

                                  final imageName = type
                                      .toString()
                                      .toLowerCase()
                                      .replaceAll(' ', '_')
                                      .replaceAll('-', '_')
                                      .replaceAll(RegExp(r'[^a-z0-9_]'), '');

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: SizedBox(
                                      width: 140,
                                      child: Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                topRight: Radius.circular(12),
                                              ),
                                              child: Image.asset(
                                                'assets/images/types_cuisines_images/$imageName.jpg',
                                                height: 90,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                    'assets/images/types_cuisine_images/default.jpg',
                                                    height: 90,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                type,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 30, bottom: 10),
                  child: Text(
                    "Les restaurants",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // --- LISTE DES RESTAURANTS ---
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final restaurant = restaurantList[index];
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
                                  'images/restaurants_images/$restaurantName.jpg',
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
                                  // Action de navigation
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: restaurantList.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
