import 'package:flutter/material.dart';
import 'package:irregation_proyect/services/auth_methods.dart';
import 'package:irregation_proyect/widgets/custom_elevated_button.dart';
import 'package:irregation_proyect/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  bool state = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 7, 139, 11),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              CustomTextField(
                  controller: _nameController,
                  hintText: 'Nombre',
                  icon: Icons.person),
              const SizedBox(height: 10),
              CustomTextField(
                  controller: _emailController,
                  hintText: 'Correo Electrónico',
                  icon: Icons.email),
              const SizedBox(height: 10),
              CustomTextField(
                  controller: _passwordController,
                  hintText: 'Contraseña',
                  icon: Icons.lock),
              const SizedBox(height: 10),
              CustomTextField(
                  controller: _phoneController,
                  hintText: 'Telefono',
                  icon: Icons.phone),
              const SizedBox(height: 10),

              CustomTextField(
                  controller: _ageController,
                  hintText: 'Edad',
                  icon: Icons.person_search_rounded),
              const SizedBox(height: 10),
              //STATE WITH SWITCH
              SwitchListTile(
                title: const Text('Estado'),
                value: state,
                onChanged: (value) {
                  setState(() {
                    state = value;
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),

              const SizedBox(height: 20),
              CustomElevatedButton(
                text: 'Registrarse',
                onPressed: () async {
                  bool result = await AuthMethods.registerUser(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                      name: _nameController.text.trim(),
                      state: state,
                      phone: _phoneController.text.trim(),
                      age: int.parse(_ageController.text.trim()));
                  if (!result) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('El usuario se creo correctamente'),
                      ),
                    );
                  }
                  //clear text fields
                  _emailController.clear();
                  _passwordController.clear();
                  _nameController.clear();
                  _phoneController.clear();
                  _ageController.clear();
                  setState(() {
                    state = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
