import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';



class ExpenseBarChart extends StatelessWidget {
  final Map<String, double> expensesByCategory;

  const ExpenseBarChart({super.key, required this.expensesByCategory});

  @override
  Widget build(BuildContext context) {
    final barData = expensesByCategory.entries
        .map((entry) => BarChartGroupData(
      x: expensesByCategory.keys.toList().indexOf(entry.key),
      barRods: [
        BarChartRodData(
          toY: entry.value,
          color: Colors.teal,
          width: 22,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    ))
        .toList();

    return Center(
        child: Container(
        height: 400, // reduce as needed
        padding: const EdgeInsets.symmetric(horizontal: 12),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          barGroups: barData,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false), // keep this if you want price on left
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true,reservedSize: 50), // hide price on right

              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    final keys = expensesByCategory.keys.toList();
                    if (index < keys.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          keys[index],
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    } else {
                      return const Text('');
                    }
                  },
                ),
              ),
            ),

          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
        ),
      ),
    )
    );
  }
}
