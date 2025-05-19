import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpensePieChart extends StatefulWidget {
  final Map<String, double> categoryData;

  const ExpensePieChart({super.key, required this.categoryData});

  @override
  _ExpensePieChartState createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends State<ExpensePieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final categories = widget.categoryData.keys.toList();
    final values = widget.categoryData.values.toList();

    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          borderData: FlBorderData(show: false),
          sectionsSpace: 2,
          centerSpaceRadius: 50,
          pieTouchData: PieTouchData(
            touchCallback: (event, pieTouchResponse) {
              setState(() {
                touchedIndex = pieTouchResponse?.touchedSection?.touchedSectionIndex ?? -1;
              });
            },
          ),
          sections: List.generate(categories.length, (i) {
            final isTouched = i == touchedIndex;
            final double radius = isTouched ? 90 : 80;
            final category = categories[i];
            final value = values[i];
            final total = values.reduce((a, b) => a + b);
            final percentage = (value / total * 100).toStringAsFixed(1);

            return PieChartSectionData(
              color: _getColor(i),
              value: value,
              title: '$percentage%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: isTouched ? 18 : 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              titlePositionPercentageOffset: 0.6,
              badgeWidget: isTouched
                  ? Text(category, style: const TextStyle(fontWeight: FontWeight.bold))
                  : null,
              badgePositionPercentageOffset: 1.2,
            );
          }),
        ),
      ),
    );
  }

  Color _getColor(int index) {
    const colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.brown,
    ];
    return colors[index % colors.length];
  }
}
