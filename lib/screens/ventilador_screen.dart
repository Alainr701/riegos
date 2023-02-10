import 'package:flutter/material.dart';
import 'package:irregation_proyect/controller/app_controller.dart';
import 'package:irregation_proyect/services/irregation_methods.dart';
import 'package:provider/provider.dart';

class VentiladorScreen extends StatefulWidget {
  final int temperature;

  const VentiladorScreen({super.key, required this.temperature});

  @override
  State<VentiladorScreen> createState() => _VentiladorScreenState();
}

class _VentiladorScreenState extends State<VentiladorScreen> {
  RangeValues _values = const RangeValues(0, 50);
  double isTemperature = 0;
  @override
  void initState() {
    isTemperature = widget.temperature.toDouble();
    _values = RangeValues(0, isTemperature);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ventilador'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 7, 139, 11),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ventilador encendido a: ${isTemperature.round()} °C',
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
                  isTemperature = _values.end;
                });
              },
            ),
            const SizedBox(height: 5),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            IrregatiobMethods.updateTemperature(isTemperature.round());
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
