import 'package:flutter/material.dart';
import 'package:irregation_proyect/controller/app_controller.dart';
import 'package:irregation_proyect/services/irregation_methods.dart';
import 'package:irregation_proyect/widgets/custom_chart.dart';
import 'package:provider/provider.dart';

class StadisticScreen extends StatefulWidget {
  @override
  State<StadisticScreen> createState() => _StadisticScreenState();
}

class _StadisticScreenState extends State<StadisticScreen> {
  late List<int> valve1DayX = [];
  late List<int> valve1DayY = [];
  late List<int> valve2DayX = [];
  late List<int> valve2DayY = [];
  late List<int> valve3DayX = [];
  late List<int> valve3DayY = [];
  late List<int> valve4DayX = [];
  late List<int> valve4DayY = [];
  int? dateINT;
  late AppController appController;
  bool isLoad = false;

  DateTime? date = DateTime.now();
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appController = Provider.of<AppController>(context, listen: true);

    print('dateStr: $dateINT');
    if (dateINT != null) {
      valve1(dateINT!);
    }
  }

  void valve1(int date) async {
    isLoad = true;
    valve1DayX = await IrregatiobMethods.getDays('valve1/daysRegation/$date/x');
    valve1DayY = await IrregatiobMethods.getDays('valve1/daysRegation/$date/y');
    valve2DayX = await IrregatiobMethods.getDays('valve2/daysRegation/$date/x');
    valve2DayY = await IrregatiobMethods.getDays('valve2/daysRegation/$date/y');
    valve3DayX = await IrregatiobMethods.getDays('valve3/daysRegation/$date/x');
    valve3DayY = await IrregatiobMethods.getDays('valve3/daysRegation/$date/y');
    valve4DayX = await IrregatiobMethods.getDays('valve4/daysRegation/$date/x');
    valve4DayY = await IrregatiobMethods.getDays('valve4/daysRegation/$date/y');
    isLoad = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 10),
              _buildContainers(
                  Icons.date_range, 'Fecha', '22/03/2023', Colors.blue, 20,
                  () async {
                //create showDatePicker
                date = await showDatePicker(
                  context: context,
                  initialDate: date ?? DateTime.now(),
                  firstDate: DateTime(2021),
                  lastDate: DateTime(2025),
                  // locale: const Locale('es', 'ES'),
                );
                if (date == null) return;
                //combeertir la fecha a stringcon un formato
                dateINT = int.parse(
                    '${date!.day.toString()}${date!.month.toString()}${date!.year.toString()}');
                appController.update();
              }),
              const SizedBox(width: 10),
              // const SizedBox(width: 10),
              // _buildContainers(
              //     Icons.access_time, 'Hora', '10:30', Colors.blue, 20),
              // const SizedBox(width: 10),
              // _buildContainers(
              //     Icons.hourglass_empty, 'Minutos', '10min', Colors.blue, 20),
              // const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: PageView(
                children: [
                  valve1DayX.isEmpty
                      ? isLoad
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.green))
                          : const Center(
                              child: Text('No hay datos para mostrar'))
                      : CustomChart(
                          title: 'Valvula 1',
                          dataX: valve1DayX,
                          dataY: valve1DayY,
                        ),
                  valve2DayX.isEmpty
                      ? isLoad
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.green))
                          : const Center(
                              child: Text('No hay datos para mostrar'))
                      : CustomChart(
                          title: 'Valvula 2',
                          dataX: valve2DayX,
                          dataY: valve2DayY,
                        ),
                  valve3DayX.isEmpty
                      ? isLoad
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.green))
                          : const Center(
                              child: Text('No hay datos para mostrar'))
                      : CustomChart(
                          title: 'Valvula 3',
                          dataX: valve3DayX,
                          dataY: valve3DayY,
                        ),
                  valve4DayX.isEmpty
                      ? isLoad
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.green))
                          : const Center(
                              child: Text('No hay datos para mostrar'))
                      : CustomChart(
                          title: 'Valvula 4',
                          dataX: valve4DayX,
                          dataY: valve4DayY,
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildContainers(IconData icon, String text, String data,
      Color colorIcon, double size, VoidCallback? onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: size, color: colorIcon),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(text,
                        style: TextStyle(
                            fontSize: size / 2, color: Colors.black))),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    data,
                    style: TextStyle(fontSize: size / 1.8),
                  ),
                )
              ],
            )
          ]),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colorIcon, width: 2)),
        ),
      ),
    );
  }
}
