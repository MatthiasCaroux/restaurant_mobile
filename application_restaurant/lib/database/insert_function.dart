import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertFunction {
  static final supabase = Supabase.instance.client;

  static Future<void> insertAvis({
    required String text,
    required int note,
    required String titre,
  }) async {
    try {
      final response = await supabase.from('Avis').insert({
        'text': text,
        'note': note,
        'Titre': titre, 
      }).select(); 

      print(" Avis inséré avec succès: $response");
    } catch (e) {
      print(" Erreur lors de l'insertion de l'avis: $e");
      throw Exception("Erreur lors de l'insertion de l'avis: $e");
    }
  }

  /// Insère un utilisateur dans la table `Utilisateur`
  static Future<void> insertUtilisateur(
    String utilisateur,
    String password,
  ) async {
    try {
      final response = await supabase.from('Utilisateur').insert({
        'username': utilisateur,
        'password': password,
      }).select();

      print(" Utilisateur inséré avec succès: $response");
    } catch (e) {
      print(" Erreur lors de l'insertion de l'utilisateur: $e");
      throw Exception("Erreur lors de l'insertion de l'utilisateur: $e");
    }
  }

  /// Insère une relation `Deposer` entre un utilisateur, un restaurant et un avis
  static Future<void> insertDeposer(
    int idUtilisateur,
    int idRestaurant,
    int idAvis,
  ) async {
    try {
      final response = await supabase.from('Deposer').insert({
        'id_Utilisateur': idUtilisateur,
        'id_Restaurant': idRestaurant,
        'id_Avis': idAvis,
      }).select();

      print(" Dépôt inséré avec succès: $response");
    } catch (e) {
      print(" Erreur lors de l'insertion du dépôt: $e");
      throw Exception("Erreur lors de l'insertion du dépôt: $e");
    }
  }
}
