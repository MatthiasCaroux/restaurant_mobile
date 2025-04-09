import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantContactButtons extends StatelessWidget {
  final String telephone;
  final String type;
  final String departement;
  final String openingHours;
  final String webSite;

  const RestaurantContactButtons({
    super.key,
    required this.telephone,
    required this.type,
    required this.departement,
    required this.openingHours,
    required this.webSite,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contact buttons section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildButton(Icons.call, telephone, () {}),
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
                () {},
              ),
              _buildButton(Icons.map, departement, () {}),

              if (webSite != '')
                _buildButton(Icons.web, webSite, () => _launchURL(webSite)),
            ],
          ),
        ),

        if (openingHours.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: _buildOpeningHoursSection(),
          ),
      ],
    );
  }

  Widget _buildButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }

  Widget _buildOpeningHoursSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: const [
              Icon(Icons.access_time, size: 18, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                'Horaires d\'ouverture',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 8),

          Text(
            openingHours,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}