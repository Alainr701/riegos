import 'package:flutter/material.dart';
import 'package:irregation_proyect/models/user.dart';
import 'package:irregation_proyect/screens/register_screen.dart';
import 'package:irregation_proyect/screens/users_screen.dart';
import 'package:irregation_proyect/services/irregation_methods.dart';
import 'package:irregation_proyect/widgets/custom_text_field.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  bool state = true;
  late User? user;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getUser();
      setState(() {});
    });
    super.initState();
  }

  void getUser() async {
    user = await IrregatiobMethods.getUser();
    _nameController.text = user!.name;
    _emailController.text = user!.email;
    _phoneController.text = user!.phone.toString();
    _ageController.text = user!.age.toString();
    state = user!.state;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Icon(
              Icons.person_pin,
              size: 120,
              color: Color.fromARGB(255, 12, 100, 59),
            ),
            const SizedBox(height: 10),
            CustomTextField(
                controller: _nameController,
                hintText: 'Nombre',
                icon: Icons.person),
            const SizedBox(height: 10),
            CustomTextField(
                enabled: false,
                controller: _emailController,
                hintText: 'Correo Electrónico',
                icon: Icons.email),
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
            _buildButttonSave(context),
            const SizedBox(height: 10),
            _buildButtonRegister(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRegister() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //TITLE MODO ADMINISTRADOR
        const Text(
          'Modo Administrador',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        FutureBuilder(
          future: IrregatiobMethods.getUser(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            }
            if (snapshot.data.type == 'Administrador') {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UsersScreen()));
                    },
                    child: const Text('Ver Usuarios'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      minimumSize: const Size(double.infinity, 40),
                      backgroundColor: Color.fromARGB(255, 62, 137, 72),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                    },
                    child: const Text('Registrar Usuario'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      minimumSize: const Size(double.infinity, 40),
                      backgroundColor: Color.fromARGB(255, 62, 137, 72),
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    );
  }

  ElevatedButton _buildButttonSave(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final user = User(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            state: state,
            phone: int.parse(_phoneController.text.trim()),
            age: int.parse(_ageController.text.trim()),
            type: 'Usuario');
        IrregatiobMethods.updateUser(user);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Guardado'),
          ),
        );
      },
      child: const Text('GUARDAR'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 12, 100, 59),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 50),
        minimumSize: const Size(double.infinity, 40),
      ),
    );
  }
}
