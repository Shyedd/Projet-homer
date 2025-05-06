import 'package:flutter/material.dart';

// Classe utilitaire pour la conception UI
class Design {
  // Style des champs de saisie
  static InputDecoration inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  // Style des boutons
  static ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: const TextStyle(fontSize: 16),
    );
  }

  // Style de texte par défaut
  static TextStyle textStyle() {
    return const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  }
}
