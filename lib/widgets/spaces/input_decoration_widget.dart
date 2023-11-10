
import 'package:flutter/material.dart';

class BaseInputDecoration {
  InputDecoration getDecoration() {
    return InputDecoration(
      fillColor: const Color(0xFFECDFE4),
      filled: true,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
