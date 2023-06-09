import 'package:flutter/material.dart';
import 'package:irregation_proyect/models/user.dart' as model;
import 'package:irregation_proyect/services/auth_methods.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 12, 100, 59),
      ),
      body: FutureBuilder<List<model.User>>(
          future: AuthMethods.getUsers(),
          builder: (context, snapshot) {
            //if loading
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  subtitle: Text(snapshot.data![index].email),
                  leading: Icon(
                    snapshot.data![index].state
                        ? Icons.check_circle
                        : Icons.cancel,
                    color:
                        snapshot.data![index].state ? Colors.green : Colors.red,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Informacion del usuario'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('UID: ${snapshot.data![index].uid}'),
                              Text('Nombre: ${snapshot.data![index].name}'),
                              Text('Email: ${snapshot.data![index].email}'),
                              Text('Telefono: ${snapshot.data![index].phone}'),
                              Text('Edad: ${snapshot.data![index].age}'),
                              Text('Estado: ${snapshot.data![index].state}'),
                              Text('Rol: ${snapshot.data![index].type}'),
                              //change state
                              TextButton(
                                onPressed: () async {
                                  await AuthMethods.updateStateUser(
                                      uid: snapshot.data![index].uid!,
                                      state: !snapshot.data![index].state);
                                  setState(() {});
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                    snapshot.data![index].state
                                        ? 'Desactivar'
                                        : 'Activar',
                                    style: TextStyle(
                                      color: snapshot.data![index].state
                                          ? Colors.red
                                          : Colors.green,
                                    )),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cerrar',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          }),
    );
  }
}
