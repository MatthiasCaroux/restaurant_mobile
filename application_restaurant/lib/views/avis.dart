import 'package:flutter/material.dart';
import 'package:sae_mobile/views/bottom_navigation_bar.dart';

class AvisPage extends StatelessWidget {
  const AvisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Bottom_Navigation_Bar(
      currentIndex: 3, // 3 = Avis
      child: Center(
        child: Text(
          'Avis',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
