import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import './views/home.dart';
import './database/db.dart';
import './views/Register.dart';
final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      name : "home",
      path : "/",
      builder: (context, state) => Home(),
    ),
    GoRoute(
      name: "database",
      path: "/database",
      builder: (context, state) => DatabaseView(),
    ),
    GoRoute(
      name: "register",
      path: "/register",
      builder: (context, state) => RegisterView(),
    )
  ],

);