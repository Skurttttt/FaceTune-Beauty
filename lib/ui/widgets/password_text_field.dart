import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool visible;
  final VoidCallback? onToggle;
  final String? Function(String?)? validator;
  final String label;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.visible,
    required this.onToggle,
    required this.validator,
    this.label = 'Password',
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !visible,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
        ),
      ),
      validator: validator,
    );
  }
}
