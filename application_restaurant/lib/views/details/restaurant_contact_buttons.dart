import 'package:flutter/material.dart';

class RestaurantContactButtons extends StatelessWidget {
  final String telephone;
  final String type;
  final String departement;
  final String opening_hours;

  const RestaurantContactButtons({
    super.key,
    required this.telephone,
    required this.type,
    required this.departement,
    required this.opening_hours
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _buildButton(Icons.call, telephone),
          _buildButton(
            type == 'restaurant'
                ? Icons.restaurant
                : type == 'bar'
                ? Icons.local_bar
                : type == 'pub'
                ? Icons.sports_bar_rounded
                : type == 'ice_cream'
                ? Icons.icecream
                : type == "fast_food"
                ? Icons.fastfood
                : type == "cafe"
                ? Icons.coffee
                : Icons.help,
            type,
          ),
          _buildButton(Icons.map, departement),
          _buildOpeningHoursSection(Icons.access_time, opening_hours),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, String label) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: () {},
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }

  Widget _buildOpeningHoursSection(IconData icon, String openingHours) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: () {},
      icon: Icon(icon, size: 20),
      label: Text(openingHours),
    );
  }
}
