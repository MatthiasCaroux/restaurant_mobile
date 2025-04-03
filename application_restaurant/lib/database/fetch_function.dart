import 'package:supabase_flutter/supabase_flutter.dart';

class FetchFunction {
  static Future<List<Map<String, dynamic>>> fetchAvis() async {
    try {
      final response = await Supabase.instance.client.from('Avis').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Erreur lors de la récupération des avis : $e');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchRestaurant() async {
    try {
      final response =
          await Supabase.instance.client.from('Restaurant').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Erreur lors de la récupération des restaurants : $e');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchUtilisateur() async {
    try {
      final response =
          await Supabase.instance.client.from('Utilisateur').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Erreur lors de la récupération des utilisateurs : $e');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchTypeCuisine() async {
    try {
      final response =
          await Supabase.instance.client.from('Type_cuisine').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception(
          'Erreur lors de la récupération des types de cuisine : $e');
    }
  }

  // Récupérer les catégories de restaurant par exemple fast-food, restaurant gastronomique, etc.
  static Future<List<Map<String, dynamic>>> fetchCategorie() async {
    try {
      final response = await Supabase.instance.client
          .from('Restaurant')
          .select('type_restaurant')
          .order('type_restaurant', ascending: true);

      // Supabase ne gère pas directement le DISTINCT sur les .select()
      // Donc on le fait côté Dart
      final seen = <String>{};
      final distinct = response
          .where((e) => seen.add(e['type_restaurant'] as String))
          .toList();

      return distinct;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des catégories : $e');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchNomTypeCuisineById(id) async {
    try {
      final response = await Supabase.instance.client
          .from('Type_cuisine')
          .select()
          .eq('id_type_cuisine', id);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception(
          'Erreur lors de la récupération des types de cuisine : $e');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchFavoriteRestaurants() async {
    final supabase = Supabase.instance.client;
    final idUtilisateur = 1; // à rendre dynamique plus tard

    try {
      final response = await supabase
          .from('Appreciation')
          .select('id_restaurant')
          .eq('id_utilisateur', idUtilisateur)
          .eq('Favoris', true);

      final ids = response.map((e) => e['id_restaurant']).toList();

      if (ids.isEmpty) return [];

      final idsString = '(${ids.join(',')})';

      final restaurants = await supabase
          .from('Restaurant')
          .select()
          .filter('id_restaurant', 'in', idsString);

      return List<Map<String, dynamic>>.from(restaurants);
    } catch (e) {
      throw Exception('Erreur lors de la récupération des favoris : $e');
    }
  }
}
