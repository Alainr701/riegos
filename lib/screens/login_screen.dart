import 'package:flutter/material.dart';
import 'package:irregation_proyect/services/auth_methods.dart';
import 'package:irregation_proyect/widgets/custom_elevated_button.dart';
import 'package:irregation_proyect/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Image.asset('assets/icon_proyect.png', scale: 2),
              const SizedBox(height: 10),
              CustomTextField(
                  controller: _emailController,
                  hintText: 'Correo Electrónico',
                  icon: Icons.email),
              const SizedBox(height: 10),
              CustomTextField(
                  obscureText: true,
                  controller: _passwordController,
                  hintText: 'Contraseña',
                  icon: Icons.lock),
              const SizedBox(height: 20),
              CustomElevatedButton(
                text: 'Iniciar Sesión',
                onPressed: () async {
                  bool result = await AuthMethods().loginUser(
                      email: _emailController.text,
                      password: _passwordController.text);
                  if (!result) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('El usuario no existe'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
