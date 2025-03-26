import 'package:flutter/material.dart';
import 'package:sae_mobile/views/bottom_navigation_bar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Bottom_Navigation_Bar(
      currentIndex: 1, // 1 = Search
      child: Center(
        child: Text(
          'Search',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
