
import 'package:flutter/material.dart';

class BaseInputDecoration {
  InputDecoration getDecoration() {
    return InputDecoration(
      fillColor: const Color.fromARGB(255, 233, 201, 213),
      filled: true,
      counterText: "",
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
