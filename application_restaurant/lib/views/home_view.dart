import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Exemple de données fictives
    final List<Map<String, String>> restaurants = [
      {"name": "Restaurant 1", "image": "assets/restaurant1.jpg"},
      {"name": "Restaurant 2", "image": "assets/restaurant2.jpg"},
      {"name": "Restaurant 3", "image": "assets/restaurant3.jpg"},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header (avatar + "Hello")
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Avatar fictif (peut être un NetworkImage ou un AssetImage)
                  const CircleAvatar(
                    radius: 26,
                    backgroundImage: AssetImage('assets/user.jpg'),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Hello,",
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      Text(
                        "Luca Romano",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Icône de paramètres ou profil
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white70),
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Liste de restaurants
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white10,
                    backgroundImage: AssetImage(restaurant["image"]!),
                  ),
                  title: Text(
                    restaurant["name"]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Action lors du clic sur un restaurant
                    },
                    child: const Text(
                      "Voir",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
