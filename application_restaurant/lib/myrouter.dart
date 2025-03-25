import 'package:go_router/go_router.dart';
import './views/home.dart';
import './database/db.dart';

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      name: "home",
      path: "/",
      builder: (context, state) => Home(),
    ),
    GoRoute(
      name: "database",
      path: "/database",
      builder: (context, state) => DatabaseView(),
    ),
  ],
);
