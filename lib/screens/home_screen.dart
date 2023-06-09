import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:irregation_proyect/controller/app_controller.dart';
import 'package:irregation_proyect/screens/calefactor_screen.dart';
import 'package:irregation_proyect/screens/stadistics_screen.dart';
import 'package:irregation_proyect/screens/user_screen.dart';
import 'package:irregation_proyect/screens/ventilador_screen.dart';
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
  int temperature = 0;
  List<Color> colors(int temp) {
    if (temp < 10) {
      return [Colors.blue, const Color.fromARGB(255, 0, 0, 255)];
    } else if (temp < 20) {
      return [
        const Color.fromARGB(255, 0, 255, 0),
        const Color.fromARGB(255, 7, 165, 7)
      ];
    } else if (temp < 30) {
      return [
        const Color.fromARGB(255, 255, 255, 0),
        const Color.fromARGB(255, 172, 172, 39)
      ];
    } else {
      return [
        const Color.fromARGB(255, 255, 0, 0),
        const Color.fromARGB(255, 224, 92, 92)
      ];
    }
  }

  late DatabaseReference starCountRef;
  bool isActive = false;
  int index = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    try {
      starCountRef = FirebaseDatabase.instance
          .ref('${auth.currentUser?.uid}/data/temperature');
      starCountRef.onValue.listen((DatabaseEvent event) {
        temperature = int.parse(event.snapshot.value.toString());
        setState(() {});
      });
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  @override
  void dispose() {
    starCountRef.onDisconnect();
    super.dispose();
  }

  int _selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //color casi blanco
      backgroundColor: const Color.fromRGBO(229, 229, 229, 1),
      appBar: AppBar(
        title: const Text("SISTEMA DE RIEGO CALANGACHI"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 12, 100, 59),
      ),
      drawer: _buildDrawer(),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: _buildContainer(),
        child: Column(
          children: [
            SizedBox(width: double.infinity),
            const SizedBox(height: 10),
            if (_selectedIndex == 0)
              Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: _buildTemperature(temperature)),
            const SizedBox(height: 5),
            if (_selectedIndex == 0) const Body(),
            if (_selectedIndex == 1) StadisticScreen(),
            if (_selectedIndex == 2) UserScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Control',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Usuarios',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildTemperature(int temp) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isActive = !isActive;
          IrregatiobMethods.updateActive(isActive);
        });
      },
      child: Container(
        height: 160,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2),
          //celeste claro degradado
          // gradient: LinearGradient(
          //   //color medio negro
          //   // colors: colors(temp),
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomLeft,
          // ),
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
                    color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(WeatherIcons.thermometer,
                    size: 40, color: Colors.black),
                const SizedBox(width: 10),
                Text(
                  '$temp °C',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
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
              "SISTEMA DE RIEGO",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              "COMUNIDAD CALANGACHI",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage("assets/icon_proyect.png"),
            ),
          ),
          const AboutListTile(
            icon: Icon(
              Icons.info,
            ),
            applicationIcon: Icon(Icons.local_play),
            applicationName: 'SISTEMA DE RIEGO',
            applicationVersion: 'version: 1.0.0',
            applicationLegalese: '© 2023 proyect',
            aboutBoxChildren: [],
            child: Text('Acerca de la aplicacion'),
          ),
          ListTile(
            leading: const Icon(Icons.power_settings_new_outlined),
            title: const Text('Salir'),
            onTap: () {
              AuthMethods().signOut();
            },
          ),
        ],
      ),
    );
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
}

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void didChangeDependencies() {
    Provider.of<AppController>(context, listen: true);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: FutureBuilder(
            future: IrregatiobMethods.getIrrigation(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.green));
              }
              if (snapshot.hasError) {
                return const Center(child: Text("Error"));
              }
              return Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
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
                                valve: snapshot.data!.valve1,
                                valveId: "valve1"),
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
                                valve: snapshot.data!.valve2,
                                valveId: "valve2"),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    //programar calefactor
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "Programar Calefactor",
                            style: TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CalefactorScreen(
                                    header: snapshot.data!.isHeater,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "Programar Extractor",
                            style: TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VentiladorScreen(
                                    temperature: snapshot.data!.isTemperature,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
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

  const BuildBox({
    super.key,
    required this.title,
    required this.type,
    required this.minutes,
    required this.status,
    required this.days,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(31, 212, 212, 212),
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
