import 'package:flutter/material.dart';
import 'package:irregation_proyect/controller/app_controller.dart';
import 'package:irregation_proyect/services/irregation_methods.dart';
import 'package:provider/provider.dart';

class CalefactorScreen extends StatefulWidget {
  final int header;

  const CalefactorScreen({super.key, required this.header});

  @override
  State<CalefactorScreen> createState() => _CalefactorScreenState();
}

class _CalefactorScreenState extends State<CalefactorScreen> {
  RangeValues _values = const RangeValues(0, 50);
  double isHeader = 0;
  @override
  void initState() {
    isHeader = widget.header.toDouble();
    _values = RangeValues(0, isHeader);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calefactor'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 12, 100, 59),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Calefactor se enciende a: ${isHeader.round()} °C',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            RangeSlider(
              activeColor: Colors.green,
              values: _values,
              min: 0.0,
              max: 50.0,
              divisions: 50,
              labels: RangeLabels(
                _values.start.round().toString(),
                _values.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _values = values;
                  isHeader = _values.end;
                });
              },
            ),
            const SizedBox(height: 5),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            IrregatiobMethods.updateHeater(isHeader.round());
            Provider.of<AppController>(context, listen: false).update();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Se actualizo la temperatura'),
              ),
            );
            Navigator.pop(context);
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
