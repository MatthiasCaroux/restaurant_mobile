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
  String? selectedType;
  bool isVegetarian = false;
  bool isPMR = false;
  bool showFilters = false;

  // Liste des types de restaurants mise à jour
  List<String> restaurantTypes = [
    'Tous', 
    'restaurant', 
    'bar', 
    'cafe', 
    'fast_food', 
    'ice_cream', 
    'pub'
  ];

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
                suffixIcon: IconButton(
                  icon: Icon(showFilters ? Icons.filter_list_off : Icons.filter_list, 
                       color: Colors.white),
                  onPressed: () {
                    setState(() {
                      showFilters = !showFilters;
                    });
                  },
                ),
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

          // Zone de filtres
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: showFilters ? 130 : 0,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Menu déroulant pour le type de restaurant
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Type d\'établissement',
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      ),
                      value: selectedType,
                      hint: const Text('Sélectionnez un type'),
                      onChanged: (value) {
                        setState(() {
                          selectedType = value;
                        });
                      },
                      items: restaurantTypes
                          .map((type) => DropdownMenuItem(
                                value: type == 'Tous' ? null : type,
                                child: Text(type == 'Tous' ? 'Tous' : 
                                      type == 'restaurant' ? 'Restaurant' :
                                      type == 'cafe' ? 'Café' :
                                      type == 'fast_food' ? 'Fast-food' :
                                      type == 'ice_cream' ? 'Glacier' :
                                      type == 'pub' ? 'Pub' :
                                      type.replaceFirst(type[0], type[0].toUpperCase())),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    // Cases à cocher
                    Row(
                      children: [
                        // Option Végétarien
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text('Végétarien', style: TextStyle(fontSize: 14)),
                            value: isVegetarian,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (bool? value) {
                              setState(() {
                                isVegetarian = value ?? false;
                              });
                            },
                          ),
                        ),
                        // Option PMR
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text('Accès PMR', style: TextStyle(fontSize: 14)),
                            value: isPMR,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (bool? value) {
                              setState(() {
                                isPMR = value ?? false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                      style: const TextStyle(color: Colors.redAccent),
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
                  final type = (restaurant['type'] ?? '').toString().toLowerCase();
                  
                  // Traitement de vegetarian qui est un booléen (TRUE, FALSE ou NULL)
                  final vegetarianValue = restaurant['vegetarian'];
                  final bool isVegetarianRestaurant = 
                      vegetarianValue is String ? 
                      vegetarianValue.toUpperCase() == 'TRUE' : 
                      vegetarianValue == true;
                  
                  // Traitement de wheelchair qui est un texte ('yes', 'limited', 'no', ou NULL)
                  final wheelchairValue = (restaurant['wheelchair'] ?? '').toString().toLowerCase();
                  final bool hasPMRAccess = 
                      wheelchairValue == 'yes' || wheelchairValue == 'limited';

                  // Filtrage par nom
                  bool matchesName = name.contains(searchQuery);
                  
                  // Filtrage par type
                  bool matchesType = selectedType == null || type == selectedType;
                  
                  // Filtrage par options
                  bool matchesVegetarian = !isVegetarian || isVegetarianRestaurant;
                  bool matchesPMR = !isPMR || hasPMRAccess;

                  return matchesName && matchesType && matchesVegetarian && matchesPMR;
                }).toList();

                return filteredRestaurants.isEmpty
                    ? const Center(
                        child: Text('Aucun établissement ne correspond à vos critères.', 
                            style: TextStyle(color: Colors.orangeAccent)),
                      )
                    : ListView.builder(
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
                          
                          // Vérification du statut végétarien
                          final vegetarianValue = restaurant['vegetarian'];
                          final bool isVegetarianRestaurant = 
                              vegetarianValue is String ? 
                              vegetarianValue.toUpperCase() == 'TRUE' : 
                              vegetarianValue == true;
                          
                          // Vérification du statut PMR
                          final wheelchairValue = (restaurant['wheelchair'] ?? '').toString().toLowerCase();
                          final bool hasFullPMRAccess = wheelchairValue == 'yes';
                          final bool hasLimitedPMRAccess = wheelchairValue == 'limited';

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
                                              'Type : ${getFormattedType(restaurant['type'] ?? '')}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                if (isVegetarianRestaurant)
                                                  const Padding(
                                                    padding: EdgeInsets.only(right: 8.0),
                                                    child: Tooltip(
                                                      message: 'Option végétarienne',
                                                      child: Icon(Icons.eco, color: Colors.green, size: 16),
                                                    ),
                                                  ),
                                                if (hasFullPMRAccess)
                                                  const Tooltip(
                                                    message: 'Accès PMR',
                                                    child: Icon(Icons.accessible, color: Colors.blue, size: 16),
                                                  ),
                                                if (hasLimitedPMRAccess)
                                                  const Tooltip(
                                                    message: 'Accès PMR limité',
                                                    child: Icon(Icons.accessible, color: Colors.orange, size: 16),
                                                  ),
                                              ],
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
  
  // Fonction pour formater le type d'établissement
  String getFormattedType(String type) {
    switch(type.toLowerCase()) {
      case 'restaurant':
        return 'Restaurant';
      case 'bar':
        return 'Bar';
      case 'cafe':
        return 'Café';
      case 'fast_food':
        return 'Fast-food';
      case 'ice_cream':
        return 'Glacier';
      case 'pub':
        return 'Pub';
      default:
        return type.isNotEmpty ? type[0].toUpperCase() + type.substring(1) : 'Non renseigné';
    }
  }
}