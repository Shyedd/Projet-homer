import 'package:flutter/material.dart';

class Design {
  static InputDecoration inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  static ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: const TextStyle(fontSize: 16),
    );
  }

  static TextStyle textStyle() {
    return const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  }
}
