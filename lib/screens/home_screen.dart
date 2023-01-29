import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:irregation_proyect/controller/app_controller.dart';
import 'package:irregation_proyect/services/auth_methods.dart';
import 'package:irregation_proyect/screens/programming_screen.dart';
import 'package:irregation_proyect/services/irregation_methods.dart';
import 'package:provider/provider.dart';
import 'package:weather_icons/weather_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double temperature = 0;
  @override
  void initState() {
    DatabaseReference starCountRef = FirebaseDatabase.instance
        .ref('${auth.currentUser?.uid}/data/temperature');
    starCountRef.onValue.listen((DatabaseEvent event) {
      temperature = event.snapshot.value as double;
      setState(() {});
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Provider.of<AppController>(context, listen: true);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //color casi blanco
      backgroundColor: const Color.fromRGBO(229, 229, 229, 1),
      appBar: AppBar(
        title: const Text("CRUZ VERDE"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 7, 139, 11),
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildTemperature(temperature),
          const SizedBox(height: 5),
          const Body(),
        ],
      ),
    );
  }

  Container _buildTemperature(double temp) {
    return Container(
      height: 160,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        //celeste claro degradado
        gradient: const LinearGradient(
          //color medio negro
          colors: [
            Color.fromARGB(255, 235, 161, 3),
            Color.fromARGB(255, 196, 94, 10),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Temperatura actual : ",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(WeatherIcons.thermometer,
                  size: 40, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                '$temp °C',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(255, 12, 100, 59)),
            accountName: Text(
              "Sistema Cruz Verde",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              "a701e3127@gmail.com",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            currentAccountPicture: FlutterLogo(size: 50),
          ),
          const AboutListTile(
            icon: Icon(
              Icons.info,
            ),
            applicationIcon: Icon(Icons.local_play),
            applicationName: 'Sistema de riego Cruz Verde',
            applicationVersion: 'version: 1.0.0',
            applicationLegalese: '© 2023 proyect',
            aboutBoxChildren: [],
            child: Text('Acerca de la aplicacion'),
          ),
          ListTile(
            leading: const Icon(Icons.power_settings_new_outlined),
            title: const Text('Salir'),
            onTap: () => AuthMethods().signOut(),
          ),
        ],
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: FutureBuilder(
            future: IrregatiobMethods.getIrrigation(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text("Error"));
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  //subtitle Programacion de riego
                  const Text(
                    "Programacion de riego",
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 10),
                  BuildBox(
                    title: snapshot.data!.valve1.title,
                    type: snapshot.data!.valve1.type,
                    minutes: snapshot.data!.valve1.time,
                    status: snapshot.data!.valve1.state,
                    days: snapshot.data!.valve1.days,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProgrammingScreen(
                              valve: snapshot.data!.valve1, valveId: "valve1"),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  BuildBox(
                    title: snapshot.data!.valve2.title,
                    type: snapshot.data!.valve2.type,
                    minutes: snapshot.data!.valve2.time,
                    status: snapshot.data!.valve2.state,
                    days: snapshot.data!.valve2.days,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProgrammingScreen(
                              valve: snapshot.data!.valve2, valveId: "valve2"),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  BuildBox(
                    title: snapshot.data!.valve3.title,
                    type: snapshot.data!.valve3.type,
                    minutes: snapshot.data!.valve3.time,
                    status: snapshot.data!.valve3.state,
                    days: snapshot.data!.valve3.days,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProgrammingScreen(
                              valve: snapshot.data!.valve3, valveId: "valve3"),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  BuildBox(
                    title: snapshot.data!.valve4.title,
                    type: snapshot.data!.valve4.type,
                    minutes: snapshot.data!.valve4.time,
                    status: snapshot.data!.valve4.state,
                    days: snapshot.data!.valve4.days,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProgrammingScreen(
                                valve: snapshot.data!.valve4,
                                valveId: "valve4")),
                      );
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              );
            }),
      ),
    );
  }
}

const List<String> dayss = ["L", "M", "M", "J", "V", "S", "D"];

class BuildBox extends StatelessWidget {
  final String title;
  final String type;
  final int minutes;
  final bool status;
  final List<int> days;
  final VoidCallback onTap;

  const BuildBox(
      {super.key,
      required this.title,
      required this.type,
      required this.minutes,
      required this.status,
      required this.days,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Row(children: [
                    const Icon(Icons.timer, color: Colors.white),
                    Text(
                      "$minutes min",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.play_circle_fill_outlined),
                        const SizedBox(width: 10),
                        Text(
                          status ? "Estado : Encendido" : "Estado : Apagado",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.timer),
                        const SizedBox(width: 10),
                        Text(
                          "Tipo : $type",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ]),
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: const [
                  //icono de calendar
                  Icon(Icons.calendar_today),
                  SizedBox(width: 10),
                  Text(
                    "Dias de la semana :",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  days.length,
                  (index) => Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: days[index] == index ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      dayss[index],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
