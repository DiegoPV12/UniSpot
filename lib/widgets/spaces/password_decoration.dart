
import 'package:flutter/material.dart';
import 'input_decoration_widget.dart';

class PasswordInputDecoration extends BaseInputDecoration {
  @override
  InputDecoration getDecoration({String? hintText, bool isPasswordVisible = false, VoidCallback? onToggleVisibility}) {
    final baseDecoration = super.getDecoration();
    return baseDecoration.copyWith(
      suffixIcon: IconButton(
        icon: Icon(
          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: onToggleVisibility,
      ),
    );
  }
}
