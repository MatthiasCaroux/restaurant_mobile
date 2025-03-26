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
  )
  async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('Utilisateur').insert({
      'username': Utilisateur,
      'password': password,
    });

    if (response.error != null) {
      throw Exception("Erreur lors de l'insertion: ${response.error!.message}");
    }
  }
}