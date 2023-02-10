import 'package:flutter/material.dart';
import 'package:irregation_proyect/controller/app_controller.dart';
import 'package:irregation_proyect/models/irregation.dart';
import 'package:irregation_proyect/screens/home_screen.dart';
import 'package:irregation_proyect/services/irregation_methods.dart';
import 'package:provider/provider.dart';

class ProgrammingScreen extends StatefulWidget {
  final Valve valve;
  final String valveId;

  const ProgrammingScreen(
      {super.key, required this.valve, required this.valveId});

  @override
  State<ProgrammingScreen> createState() => _ProgrammingScreenState();
}

class _ProgrammingScreenState extends State<ProgrammingScreen> {
  final _controllerTitle = TextEditingController();
  final _controllerMinute = TextEditingController();
  final _controllerturnOnEvery = TextEditingController();
  ProgrammingType _programmingType = ProgrammingType.automatic;

  @override
  void initState() {
    super.initState();
    _controllerTitle.text = widget.valve.title;
    _controllerMinute.text = widget.valve.time.toString();
    _controllerturnOnEvery.text = widget.valve.turnOnEvery.toString();

    if (widget.valve.type == 'Horario') {
      _programmingType = ProgrammingType.automatic;
    } else {
      _programmingType = ProgrammingType.manual;
    }
  }

  @override
  void didChangeDependencies() {
    Provider.of<AppController>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(229, 229, 229, 1),
      appBar: AppBar(
        title: const Text("Programacion de valvulas"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 7, 139, 11),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextFormField(
                controller: _controllerTitle,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Nombre de la programacion",
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: ListTile(
                title: const Text(
                  "Estado",
                  style: TextStyle(fontSize: 20),
                ),
                trailing: Switch(
                  value: widget.valve.state,
                  onChanged: (value) {
                    setState(() {
                      widget.valve.state = value;
                      IrregatiobMethods.updateState(
                          widget.valve.state, widget.valveId);
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Dias de la semana",
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(height: 10),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  dayss.length,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.valve.days[index] =
                            widget.valve.days[index] == index ? 9 : index;
                      });
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: widget.valve.days[index] == index
                            ? Colors.green
                            : Colors.red,
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
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Minuto activo",
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  height: 40,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _controllerMinute,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (int.parse(value) > 59) {
                          _controllerMinute.text = "59";
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: ListTile(
                title: const Text("Encender cada (Horario):"),
                leading: Radio(
                  value: ProgrammingType.automatic,
                  groupValue: _programmingType,
                  onChanged: (ProgrammingType? value) {
                    _programmingType = value!;
                    setState(() {});
                  },
                ),
              ),
            ),
            Visibility(
              visible: _programmingType == ProgrammingType.automatic,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controllerturnOnEvery,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Tiempo en minutos",
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            if (int.parse(value) > 1440) {
                              _controllerturnOnEvery.text = "1440";
                            }
                          }
                        },
                      ),
                    ),
                    //minute or hour
                    Container(
                      height: 40,
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Minutos",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: ListTile(
                title: const Text("Programado:"),
                leading: Radio(
                  value: ProgrammingType.manual,
                  groupValue: _programmingType,
                  onChanged: (ProgrammingType? value) {
                    _programmingType = value!;
                    setState(() {});
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.add_circle_rounded, size: 30),
                  onPressed: () async {
                    if (_programmingType == ProgrammingType.automatic) {
                      return;
                    }
                    int? result = await showDialog(
                        context: context,
                        builder: (context) {
                          final hourController = TextEditingController();
                          final minuteController = TextEditingController();
                          return AlertDialog(
                            backgroundColor: const Color(0xffF2F2F2),
                            title: const Text("Agregar hora"),
                            content: SizedBox(
                              height: 100,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Hora"),
                                      Container(
                                        height: 40,
                                        width: 100,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: TextFormField(
                                          controller: hourController,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Minuto"),
                                      Container(
                                        height: 40,
                                        width: 100,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: TextFormField(
                                          controller: minuteController,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, null);
                                },
                                child: const Text("Cancelar"),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (hourController.text.isEmpty ||
                                      minuteController.text.isEmpty) {
                                    return;
                                  }
                                  //navigator pop response 10 20 => 1020 o 11 40 =>1140 ahora con hourController.text y minuteController.text
                                  Navigator.pop(
                                      context,
                                      int.parse(hourController.text) * 100 +
                                          int.parse(minuteController.text));
                                },
                                child: const Text("Aceptar"),
                              ),
                            ],
                          );
                        });
                    if (result != null) {
                      int index = widget.valve.times.indexWhere((element) {
                        return element == 0;
                      });
                      if (index == -1) {
                        widget.valve.times.add(result);
                      } else {
                        widget.valve.times[index] = result;
                      }
                      setState(() {});
                    }
                    setState(() {});
                  },
                ),
              ),
            ),
            Visibility(
              visible: _programmingType == ProgrammingType.manual,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: Column(
                  children: widget.valve.times.map((e) {
                    //mostrar si e es diferente de 0
                    if (e == 0) return const SizedBox();
                    return ListTile(
                      //el title debe parecerse a 10:20
                      title: Text(
                        "${e ~/ 100}:${e % 100}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          widget.valve.times[widget.valve.times.indexOf(e)] = 0;
                          setState(() {});
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          IrregatiobMethods.updateValve(
              Valve(
                  title: _controllerTitle.text.trim(),
                  type: _programmingType == ProgrammingType.manual
                      ? 'Programado'
                      : 'Horario',
                  turnOnEvery: int.parse(_controllerturnOnEvery.text.trim()),
                  state: widget.valve.state,
                  time: int.parse(_controllerMinute.text.trim()),
                  times: widget.valve.times,
                  days: widget.valve.days),
              widget.valveId);
          Provider.of<AppController>(context, listen: false).update();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Se ha guardado correctamente"),
            ),
          );
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class FormAdd extends StatelessWidget {
  final String hour;
  final String minute;
  final VoidCallback onPressed;

  const FormAdd(
      {super.key,
      required this.hour,
      required this.minute,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$hour:$minute",
              style: const TextStyle(fontSize: 20),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onPressed(),
          ),
        ],
      ),
    );
  }
}

enum ProgrammingType { manual, automatic }
