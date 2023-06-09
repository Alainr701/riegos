import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.validator,
      this.obscureText = false,
      this.enabled = true,
      this.icon});

  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final bool obscureText;
  final bool enabled;

  final Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 12, 100, 59)),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 12, 100, 59)),
        ),
      ),
      validator: (val) => validator!(val),
    );
  }
}
