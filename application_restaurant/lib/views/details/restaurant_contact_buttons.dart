import 'package:flutter/material.dart';

class RestaurantContactButtons extends StatelessWidget {
  final String telephone;
  final String type;
  final String departement;

  const RestaurantContactButtons({
    super.key,
    required this.telephone,
    required this.type,
    required this.departement,
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
                ? Icons.local_bar
                : type == 'ice cream'
                  ? Icons.icecream
                  : Icons.help,
            type,
            ),
          _buildButton(Icons.map, departement),
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
}
