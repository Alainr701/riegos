import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.validator,
      this.icon});

  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 7, 139, 11)),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 7, 139, 11)),
        ),
      ),
      validator: (val) => validator!(val),
    );
  }
}
