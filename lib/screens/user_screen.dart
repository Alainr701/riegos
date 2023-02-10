import 'package:flutter/material.dart';
import 'package:irregation_proyect/models/user.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuario'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 7, 139, 11),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Icon(
                Icons.person_pin,
                size: 120,
                color: Color.fromARGB(255, 7, 139, 11),
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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
        backgroundColor: Colors.green,
        child: const Icon(Icons.save),
      ),
    );
  }
}
