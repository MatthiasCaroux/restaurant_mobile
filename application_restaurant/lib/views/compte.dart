import 'package:flutter/material.dart';
import 'package:sae_mobile/views/bottom_navigation_bar.dart';

class ComptePage extends StatelessWidget {
  const ComptePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Bottom_Navigation_Bar(
      currentIndex: 4, // 4 = Compte
      child: Center(
        child: Text(
          'Compte',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
