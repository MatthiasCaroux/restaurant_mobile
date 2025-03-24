import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../myrouter.dart';
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(onPressed:() => context.go('/database'), child: const Text('Database')),
      ),

    );
  }
}