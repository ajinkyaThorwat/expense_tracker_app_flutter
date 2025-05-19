import '../widgets/expense_bar_chart.dart';
import '../widgets/expense_pie_chart.dart';
import 'package:flutter/material.dart';
// For the pie chart and bar chart
class InsightsTab extends StatefulWidget {
  final Map<String, double> expensesByCategory;

  const InsightsTab({super.key, required this.expensesByCategory});

  @override
  _InsightsTabState createState() => _InsightsTabState();
}

class _InsightsTabState extends State<InsightsTab> {
  bool showPieChart = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleButtons(
          isSelected: [showPieChart, !showPieChart],
          onPressed: (index) {
            setState(() {
              showPieChart = index == 0;
            });
          },
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Pie Chart"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Bar Chart"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: showPieChart
              ? ExpensePieChart(categoryData: widget.expensesByCategory)
              : ExpenseBarChart(expensesByCategory: widget.expensesByCategory),
        ),
      ],
    );
  }
}
