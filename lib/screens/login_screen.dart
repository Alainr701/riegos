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

  BoxDecoration _buildContainer() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: Colors.green,
        width: 2,
      ),
      borderRadius: BorderRadius.all(Radius.circular(20)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

// pppppppp
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: _buildContainer(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: const Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
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
          ),
        ],
      ),
    );
  }
}
