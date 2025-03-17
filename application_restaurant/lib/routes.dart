import 'package:flutter/material.dart';
import 'views/home_view.dart';
import 'views/auth_view.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const HomePage(),
  '/auth': (context) => const AuthPage(),
};
