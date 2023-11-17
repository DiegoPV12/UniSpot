import 'package:flutter/material.dart';
import 'input_decoration_widget.dart';

class ReservationInputDecoration extends BaseInputDecoration {
  @override
  InputDecoration getDecoration({String? hintText}) {
    final baseDecoration = super.getDecoration().copyWith(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        );

    return baseDecoration;
  }
}
