import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Bottom_Navigation_Bar extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const Bottom_Navigation_Bar({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/favoris');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/home');
        break;
      case 3:
        context.go('/avis');
        break;
      case 4:
        context.go('/compte');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoris'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.comment), label: 'Avis'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Compte'),
        ],
        onTap: (index) => _onTap(context, index),
      ),
    );
  }
}
