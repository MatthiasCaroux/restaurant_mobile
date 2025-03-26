import 'package:flutter/material.dart';
import 'package:sae_mobile/views/bottom_navigation_bar.dart';

class FavorisPage extends StatelessWidget {
  const FavorisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Bottom_Navigation_Bar(
      currentIndex: 0,
      child: Center(
        child: Text(
          'Favoris',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
