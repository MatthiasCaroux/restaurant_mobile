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
}
