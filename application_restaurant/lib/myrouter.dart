import 'package:go_router/go_router.dart';
import './views/home.dart';
import './database/db.dart';
import './views/avis.dart';
import './views/favoris.dart';
import './views/compte.dart';
import './views/search.dart';
import './views/searchCategorie.dart';

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
    GoRoute(
      name: "avis",
      path: "/avis",
      builder: (context, state) => AvisPage(),
    ),
    GoRoute(
      name: "favoris",
      path: "/favoris",
      builder: (context, state) => FavorisPage(),
    ),
    GoRoute(
      name: "compte",
      path: "/compte",
      builder: (context, state) => ComptePage(),
    ),
    GoRoute(
        name: "search",
        path: "/search",
        builder: (context, state) => SearchPage(),
        routes: [
          GoRoute(
            name: "searchCategories",
            path: "categories",
            builder: (context, state) => SearchCategoriesPage(),
          )
        ]),
  ],
);
