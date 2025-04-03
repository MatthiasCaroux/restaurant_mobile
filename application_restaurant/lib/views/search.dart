import 'package:flutter/material.dart';
import 'package:sae_mobile/database/fetch_function.dart';
import 'package:sae_mobile/views/bottom_navigation_bar.dart';
import 'package:go_router/go_router.dart';
import 'details/restaurant_detail_page.dart';

class SearchPage extends StatefulWidget {
  final String? initialType;
  final String? initialCuisine;

  const SearchPage({
    super.key,
    this.initialType,
    this.initialCuisine,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = '';
  List<Map<String, dynamic>> filteredRestaurants = [];
  String? selectedType;
  String? selectedCuisine;
  bool isVegetarian = false;
  bool isPMR = false;
  bool showFilters = false;

  // Liste des types de restaurants
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
  void initState() {
    super.initState();
    selectedType = widget.initialType;
    selectedCuisine = widget.initialCuisine;
    if (widget.initialType != null || widget.initialCuisine != null) {
      showFilters = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Bottom_Navigation_Bar(
      currentIndex: 1, // 1 = Search
      child: Column(
        children: [
          const SizedBox(height: 25),
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Rechercher un restaurant...',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                suffixIcon: IconButton(
                  icon: Icon(
                    showFilters ? Icons.filter_list_off : Icons.filter_list,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      showFilters = !showFilters;
                    });
                  },
                ),
                filled: true,
                fillColor: Colors.black54,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
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
            height: showFilters ? 210 : 0,
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
                    
                    // Menu déroulant pour le type de cuisine
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: FetchFunction.fetchTypeCuisine(),
                      builder: (context, cuisineSnapshot) {
                        if (cuisineSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        } else if (cuisineSnapshot.hasError) {
                          return Text(
                            'Erreur : ${cuisineSnapshot.error}',
                            style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                          );
                        } else if (!cuisineSnapshot.hasData || cuisineSnapshot.data!.isEmpty) {
                          return const Text(
                            "Aucun type de cuisine trouvé.",
                            style: TextStyle(color: Colors.orangeAccent, fontSize: 12),
                          );
                        }

                        List<DropdownMenuItem<String>> cuisineItems = [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('Tous'),
                          )
                        ];

                        cuisineSnapshot.data!.forEach((cuisine) {
                          String cuisineType = cuisine['nom_type_cuisine'] ?? '';
                          if (cuisineType.isNotEmpty) {
                            cuisineItems.add(DropdownMenuItem<String>(
                              value: cuisineType,
                              child: Text(cuisineType),
                            ));
                          }
                        });

                        return DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Type de cuisine',
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          ),
                          value: selectedCuisine,
                          hint: const Text('Sélectionnez un type de cuisine'),
                          onChanged: (value) {
                            setState(() {
                              selectedCuisine = value;
                            });
                          },
                          items: cuisineItems,
                        );
                      },
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
                  final String restaurantType = (restaurant['type_restaurant'] ?? '').toString().toLowerCase();
                  final name = (restaurant['nom_restaurant'] ?? '')
                      .toString()
                      .toLowerCase();
                  final type = restaurantType;
                  final cuisine = (restaurant['cuisine'] ?? '').toString();
                  
                  final vegetarianValue = restaurant['vegetarian'];
                  final bool isVegetarianRestaurant = 
                      vegetarianValue is String ? 
                      vegetarianValue.toUpperCase() == 'TRUE' : 
                      vegetarianValue == true;
                  
                  final wheelchairValue = (restaurant['wheelchair'] ?? '').toString().toLowerCase();
                  final bool hasPMRAccess = 
                      wheelchairValue == 'yes' || wheelchairValue == 'limited';

                  bool matchesName = name.contains(searchQuery);
                  bool matchesType = selectedType == null || type == selectedType?.toLowerCase();
                  bool matchesCuisine = selectedCuisine == null || cuisine == selectedCuisine;
                  bool matchesVegetarian = !isVegetarian || isVegetarianRestaurant;
                  bool matchesPMR = !isPMR || hasPMRAccess;

                  return matchesName && matchesType && matchesCuisine && matchesVegetarian && matchesPMR;
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
                          
                          final String restaurantType = (restaurant['type_restaurant'] ?? '').toString();
                          
                          final vegetarianValue = restaurant['vegetarian'];
                          final bool isVegetarianRestaurant = 
                              vegetarianValue is String ? 
                              vegetarianValue.toUpperCase() == 'TRUE' : 
                              vegetarianValue == true;
                          
                          final wheelchairValue = (restaurant['wheelchair'] ?? '').toString().toLowerCase();
                          final bool hasFullPMRAccess = wheelchairValue == 'yes';
                          final bool hasLimitedPMRAccess = wheelchairValue == 'limited';

                          final cuisineType = restaurant['cuisine'] != null && 
                                             restaurant['cuisine'].toString().isNotEmpty ?
                                             restaurant['cuisine'].toString() : '';

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
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                            const SizedBox(height: 4),
                                            Text(
                                              'Type : ${getFormattedType(restaurantType)}',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            if (cuisineType.isNotEmpty)
                                              Text(
                                                'Cuisine : $cuisineType',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                ),
                                                overflow: TextOverflow.ellipsis,
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