import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertFunction {
  static Future<void> insertAvis({
    required String text,
    required int note,
    required String titre,
  }) async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('avis').insert({
      'text': text,
      'note': note,
      'titre': titre,
    });

    if (response.error != null) {
      throw Exception("Erreur lors de l'insertion: ${response.error!.message}");
    }
  }

  static Future<void> insertUtilisateur(
    String Utilisateur,
    String password,
  ) async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('Utilisateur').insert({
      'username': Utilisateur,
      'password': password,
    });

    if (response.error != null) {
      throw Exception("Erreur lors de l'insertion: ${response.error!.message}");
    }
  }

  static Future<void> insertAppreciation(
    int idUtilisateur,
    int idRestaurant,
  ) async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('Appreciation').insert({
      'id_utilisateur': idUtilisateur,
      'id_restaurant': idRestaurant,
      'Favoris': true,
      'Aimer': null,
    });

    if (response.error != null) {
      throw Exception("Erreur lors de l'insertion: ${response.error!.message}");
    }
  }

  static Future<void> toggleFavori({
    required int idUtilisateur,
    required int idRestaurant,
    required bool isFavorite,
  }) async {
    final supabase = Supabase.instance.client;

    // permet de verif si déjà dans la table
    final existing = await supabase
        .from('Appreciation')
        .select()
        .eq('id_utilisateur', idUtilisateur)
        .eq('id_restaurant', idRestaurant)
        .maybeSingle();

    if (existing != null) {
      final response = await supabase
          .from('Appreciation')
          .update({'Favoris': isFavorite}).match({
        'id_utilisateur': idUtilisateur,
        'id_restaurant': idRestaurant,
      });

      if (response.error != null) {
        throw Exception("Erreur update: ${response.error!.message}");
      }
    } else {
      final response = await supabase.from('Appreciation').insert({
        'id_utilisateur': idUtilisateur,
        'id_restaurant': idRestaurant,
        'Favoris': true,
        'Aimer': null,
      });

      if (response.error != null) {
        throw Exception("Erreur insert: ${response.error!.message}");
      }
    }
  }

  static Future<bool> isRestaurantFavori({
    required int idUtilisateur,
    required int idRestaurant,
  }) async {
    final supabase = Supabase.instance.client;

    final data = await supabase
        .from('Appreciation')
        .select('Favoris')
        .eq('id_utilisateur', idUtilisateur)
        .eq('id_restaurant', idRestaurant)
        .maybeSingle();

    if (data != null && data['Favoris'] == true) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> removeFavori({
    required int idUtilisateur,
    required int idRestaurant,
  }) async {
    final supabase = Supabase.instance.client;

    final response =
        await supabase.from('Appreciation').update({'Favoris': false}).match({
      'id_utilisateur': idUtilisateur,
      'id_restaurant': idRestaurant,
    });

    if (response.error != null) {
      throw Exception(
          "Erreur suppression favoris : ${response.error!.message}");
    }
  }
}
