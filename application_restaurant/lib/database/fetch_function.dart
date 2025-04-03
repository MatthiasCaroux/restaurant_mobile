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
  static Future<List<Map<String, dynamic>>> fetchAvisParRestaurant(int idRestaurant) async {
  final response = await Supabase.instance.client
      .from('Deposer')
      .select('id_Avis')
      .eq('id_Restaurant', idRestaurant);

  if (response is List && response.isNotEmpty) {
    List<int> idsAvis = response.map((item) => item['id_Avis'] as int).toList();

    // Récupération des avis en fonction des IDs trouvés
    final avisResponse = await Supabase.instance.client
        .from('Avis')
        .select('id, note, text')
        .contains('id', idsAvis);

    return avisResponse as List<Map<String, dynamic>>;
  }

  return [];
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
  static Future<int> fetchLastAvisId() async {
    try {
      final response = await Supabase.instance.client
          .from('Avis')
          .select('id')
          .order('id', ascending: false)
          .limit(1)
          .single();
      return response['id'] as int;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'ID max : $e');
    }
  }
  static Future<Map<String, dynamic>?> fetchUtilisateurByEmail(String username) async {
  if (username.isEmpty) {
    print("fetchUtilisateurByEmail : username est vide !");
    return null;
  }

  try {
    final response = await Supabase.instance.client
        .from('Utilisateur')
        .select()
        .eq('username', username)
        .maybeSingle(); // Utilisation de maybeSingle() pour éviter les erreurs

    if (response == null) {
      print("Aucun utilisateur trouvé avec le username : $username");
      return null;
    }

    return Map<String, dynamic>.from(response);
  } catch (e) {
    print("Erreur lors de la récupération de l'utilisateur : $e");
    return null; // On retourne null pour éviter de crasher l'application
  }
}

}
