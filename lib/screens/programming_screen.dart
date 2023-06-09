import 'package:flutter/material.dart';
import 'package:irregation_proyect/controller/app_controller.dart';
import 'package:irregation_proyect/models/irregation.dart';
import 'package:irregation_proyect/screens/home_screen.dart';
import 'package:irregation_proyect/services/irregation_methods.dart';
import 'package:irregation_proyect/widgets/custom_string_down.dart';
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
  ProgrammingTypeManual _programmingType = ProgrammingTypeManual.automatic;
  ProgrammingIrrigationSelected _selected = ProgrammingIrrigationSelected.op1;

  @override
  void initState() {
    super.initState();
    _controllerTitle.text = widget.valve.title;
    _controllerMinute.text = widget.valve.time.toString();
    _controllerturnOnEvery.text = widget.valve.turnOnEvery.toString();

    if (widget.valve.type == 'Horario') {
      _programmingType = ProgrammingTypeManual.automatic;
    } else {
      _programmingType = ProgrammingTypeManual.manual;
    }
  }

  @override
  void didChangeDependencies() {
    Provider.of<AppController>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controllerTitle.dispose();
    _controllerMinute.dispose();
    _controllerturnOnEvery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(229, 229, 229, 1),
      appBar: AppBar(
        title: const Text("Programacion de valvulas"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 12, 100, 59),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: _buildContainer(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                      width: double.infinity,
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: TextFormField(
                                    controller: _controllerTitle,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Nombre de la programacion",
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                  ),
                                ),
                              ),
                              //save onlyu icon with button for save
                              IconButton(
                                onPressed: () {
                                  IrregatiobMethods.updateTitle(
                                      _controllerTitle.text, widget.valveId);
                                  Provider.of<AppController>(context,
                                          listen: false)
                                      .update();
                                },
                                icon: const Icon(
                                  Icons.save,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.black12,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                          RadioListTile(
                            title: const Text(
                              "Programacion automatica",
                              style: TextStyle(fontSize: 20),
                            ),
                            value: ProgrammingIrrigationSelected.op1,
                            groupValue: _selected,
                            onChanged: (value) {
                              setState(() {
                                _selected = ProgrammingIrrigationSelected.op1;
                              });
                            },
                          ),
                          if (_selected == ProgrammingIrrigationSelected.op1)
                            StringDropdown(
                              values: [''],
                              initialValue: '',
                              selectedColor: Colors.green,
                              onChanged: (value) {},
                            ),
                          const SizedBox(height: 10),
                          RadioListTile(
                            title: const Text(
                              "Programacion manual",
                              style: TextStyle(fontSize: 20),
                            ),
                            value: ProgrammingIrrigationSelected.op2,
                            groupValue: _selected,
                            onChanged: (value) {
                              setState(() {
                                _selected = ProgrammingIrrigationSelected.op2;
                              });
                            },
                          ),
                          if (_selected == ProgrammingIrrigationSelected.op2)
                            Column(
                              children: [
                                const SizedBox(height: 10),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: const BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: List.generate(
                                      dayss.length,
                                      (index) => GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            widget.valve.days[index] =
                                                widget.valve.days[index] ==
                                                        index
                                                    ? 9
                                                    : index;
                                          });
                                          IrregatiobMethods.updateWeeks(
                                              index,
                                              widget.valve.days[index] != index
                                                  ? 9
                                                  : index,
                                              widget.valveId);
                                          Provider.of<AppController>(context,
                                                  listen: false)
                                              .update();
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: widget.valve.days[index] ==
                                                    index
                                                ? Colors.green
                                                : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: _controllerMinute,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                              textAlign: TextAlign.center,
                                              onChanged: (value) {
                                                if (value.isNotEmpty) {
                                                  if (int.parse(value) > 59) {
                                                    _controllerMinute.text =
                                                        "59";
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                          //icon send
                                          GestureDetector(
                                            onTap: () {
                                              if (_controllerMinute
                                                  .text.isNotEmpty) {
                                                setState(() {
                                                  widget.valve.time = int.parse(
                                                      _controllerMinute.text);
                                                  IrregatiobMethods.updateTime(
                                                      widget.valve.time,
                                                      widget.valveId);
                                                });
                                                Provider.of<AppController>(
                                                        context,
                                                        listen: false)
                                                    .update();
                                              }
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.send,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: ListTile(
                                    title:
                                        const Text("Encender cada (Horario):"),
                                    leading: Radio(
                                      value: ProgrammingTypeManual.automatic,
                                      groupValue: _programmingType,
                                      onChanged:
                                          (ProgrammingTypeManual? value) {
                                        _programmingType = value!;
                                        IrregatiobMethods.updateType(
                                            _programmingType ==
                                                    ProgrammingTypeManual.manual
                                                ? 'Programado'
                                                : 'Horario',
                                            widget.valveId);

                                        setState(() {});
                                        Provider.of<AppController>(context,
                                                listen: false)
                                            .update();
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _programmingType ==
                                      ProgrammingTypeManual.automatic,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 10, left: 10, right: 10),
                                    decoration: const BoxDecoration(
                                      color: Colors.black12,
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
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10),
                                            ),
                                            onChanged: (value) {
                                              if (value.isNotEmpty) {
                                                if (int.parse(value) > 1440) {
                                                  _controllerturnOnEvery.text =
                                                      "1440";
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
                                            color: Colors.black12,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Text(
                                            "Minutos",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        //button save
                                        GestureDetector(
                                          onTap: () {
                                            if (_controllerturnOnEvery
                                                .text.isNotEmpty) {
                                              setState(() {
                                                widget.valve.turnOnEvery =
                                                    int.parse(
                                                        _controllerturnOnEvery
                                                            .text);
                                                IrregatiobMethods
                                                    .updateTurnOnEvery(
                                                        widget
                                                            .valve.turnOnEvery,
                                                        widget.valveId);
                                              });
                                              Provider.of<AppController>(
                                                      context,
                                                      listen: false)
                                                  .update();
                                            }
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10),
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.send,
                                              color: Colors.white,
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
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: ListTile(
                                    title: const Text("Programado:"),
                                    leading: Radio(
                                      value: ProgrammingTypeManual.manual,
                                      groupValue: _programmingType,
                                      onChanged:
                                          (ProgrammingTypeManual? value) {
                                        _programmingType = value!;
                                        IrregatiobMethods.updateType(
                                            _programmingType ==
                                                    ProgrammingTypeManual.manual
                                                ? 'Programado'
                                                : 'Horario',
                                            widget.valveId);
                                        Provider.of<AppController>(context,
                                                listen: false)
                                            .update();

                                        setState(() {});
                                      },
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.add_circle_rounded,
                                          size: 30),
                                      onPressed: () async {
                                        if (_programmingType ==
                                            ProgrammingTypeManual.automatic) {
                                          return;
                                        }
                                        int? result = await showDialog(
                                            context: context,
                                            builder: (context) {
                                              final hourController =
                                                  TextEditingController();
                                              final minuteController =
                                                  TextEditingController();
                                              return AlertDialog(
                                                backgroundColor:
                                                    const Color(0xffF2F2F2),
                                                title:
                                                    const Text("Agregar hora"),
                                                content: SizedBox(
                                                  height: 100,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text("Hora"),
                                                          Container(
                                                            height: 40,
                                                            width: 100,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .black12,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  hourController,
                                                              decoration:
                                                                  const InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              onChanged:
                                                                  (value) {
                                                                if (value
                                                                    .isNotEmpty) {
                                                                  if (int.parse(
                                                                          value) >
                                                                      23) {
                                                                    hourController
                                                                            .text =
                                                                        "23";
                                                                  }
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text("Minuto"),
                                                          Container(
                                                            height: 40,
                                                            width: 100,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .black12,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  minuteController,
                                                              decoration:
                                                                  const InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              onChanged:
                                                                  (value) {
                                                                if (value
                                                                    .isNotEmpty) {
                                                                  if (int.parse(
                                                                          value) >
                                                                      59) {
                                                                    minuteController
                                                                            .text =
                                                                        "59";
                                                                  }
                                                                }
                                                              },
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
                                                      Navigator.pop(
                                                          context, null);
                                                    },
                                                    child:
                                                        const Text("Cancelar"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      if (hourController
                                                              .text.isEmpty ||
                                                          minuteController
                                                              .text.isEmpty) {
                                                        return;
                                                      }
                                                      //navigator pop response 10 20 => 1020 o 11 40 =>1140 ahora con hourController.text y minuteController.text
                                                      Navigator.pop(
                                                          context,
                                                          int.parse(hourController
                                                                      .text) *
                                                                  100 +
                                                              int.parse(
                                                                  minuteController
                                                                      .text));
                                                    },
                                                    child:
                                                        const Text("Aceptar"),
                                                  ),
                                                ],
                                              );
                                            });
                                        if (result != null) {
                                          int index = widget.valve.times
                                              .indexWhere((element) {
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
                                  visible: _programmingType ==
                                      ProgrammingTypeManual.manual,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 10, left: 10, right: 10),
                                    decoration: const BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                    ),
                                    child: Column(
                                      children: [
                                        Column(
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
                                                  widget.valve.times[widget
                                                      .valve.times
                                                      .indexOf(e)] = 0;
                                                  for (int i = 0;
                                                      i <
                                                          widget.valve.times
                                                              .length;
                                                      i++) {
                                                    if (widget.valve.times[i] ==
                                                        0) {
                                                      IrregatiobMethods
                                                          .updateTimes(
                                                              i,
                                                              widget.valve
                                                                  .times[i],
                                                              widget.valveId);
                                                    }
                                                  }
                                                  setState(() {});
                                                  Provider.of<AppController>(
                                                          context,
                                                          listen: false)
                                                      .update();
                                                },
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        //button save
                                        Container(
                                          height: 40,
                                          width: 100,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              //recorrer la lista de times y guardar los que no sean 0
                                              for (int i = 0;
                                                  i < widget.valve.times.length;
                                                  i++) {
                                                if (widget.valve.times[i] !=
                                                    0) {
                                                  IrregatiobMethods.updateTimes(
                                                      i,
                                                      widget.valve.times[i],
                                                      widget.valveId);
                                                }
                                              }
                                              Provider.of<AppController>(
                                                      context,
                                                      listen: false)
                                                  .update();

                                              setState(() {});
                                            },
                                            child: const Text(
                                              "Guardar",
                                              style: TextStyle(
                                                color: Colors.black12,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 100),
                              ],
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     IrregatiobMethods.updateValve(
      //         Valve(
      //             title: _controllerTitle.text.trim(),
      //             type: _programmingType == ProgrammingType.manual
      //                 ? 'Programado'
      //                 : 'Horario',
      //             turnOnEvery: int.parse(_controllerturnOnEvery.text.trim()),
      //             state: widget.valve.state,
      //             time: int.parse(_controllerMinute.text.trim()),
      //             times: widget.valve.times,
      //             days: widget.valve.days),
      //         widget.valveId);
      //     Provider.of<AppController>(context, listen: false).update();
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(
      //         content: Text("Se ha guardado correctamente"),
      //       ),
      //     );
      //   },
      //   child: const Icon(Icons.save),
      // ),
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
        color: Colors.black12,
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

enum ProgrammingTypeManual { manual, automatic }

enum ProgrammingIrrigationSelected { op1, op2 }
