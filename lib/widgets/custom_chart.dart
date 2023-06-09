import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomChart extends StatelessWidget {
  final List<int?> dataY;
  final List<int?> dataX;
  final String title;

  const CustomChart(
      {Key? key, required this.dataY, required this.dataX, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];

    int maxLength = dataX.length > dataY.length ? dataX.length : dataY.length;

    for (int i = 0; i < maxLength; i++) {
      int? x = i < dataX.length ? dataX[i] : null;
      int? y = i < dataY.length ? dataY[i] : null;
      if (x != null && y != null) {
        spots.add(
            FlSpot(double.parse(x.toString()), double.parse(y.toString())));
      }
    }

    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 20)),
        const SizedBox(height: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 10, bottom: 30),
            child: LineChart(
              LineChartData(
                minX: 1,
                maxX: dataX.length.toDouble(),
                minY: 1,
                maxY: dataY.reduce((value, element) =>
                        value! > element! ? value : element)! +
                    1,
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(),
                  leftTitles: AxisTitles(
                    axisNameWidget: Text('Actividad'),
                    sideTitles: SideTitles(showTitles: true, interval: 1),
                  ),
                  topTitles: AxisTitles(),
                  bottomTitles: AxisTitles(
                    axisNameWidget: Text('Días del mes'),
                    sideTitles: SideTitles(showTitles: true, interval: 2),
                  ),
                ),
                backgroundColor: Color.fromARGB(255, 210, 242, 211),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    barWidth: 1,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
