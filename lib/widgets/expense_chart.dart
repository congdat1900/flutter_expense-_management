import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense.dart';

class ExpenseChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseChart({super.key, required this.expenses});

  Map<ExpenseCategory, double> get categoryTotals {
    final Map<ExpenseCategory, double> totals = {};
    for (final e in expenses) {
      totals[e.category] = (totals[e.category] ?? 0) + e.amount;
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final totals = categoryTotals;
    final totalAmount = totals.values.fold(0.0, (sum, value) => sum + value);
    final pieSections = totals.entries.map((entry) {
      final percent = (entry.value / totalAmount) * 100;
      return PieChartSectionData(
        value: entry.value,
        title: '${entry.key.name}\n${percent.toStringAsFixed(1)}%',
        radius: 50,
        color: _getCategoryColor(entry.key),
        titleStyle: const TextStyle(fontSize: 12),
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: pieSections,
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }

  Color _getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Colors.redAccent;
      case ExpenseCategory.pet:
        return Colors.blueAccent;
      case ExpenseCategory.entertainment:
        return Colors.orange;
      case ExpenseCategory.shopping:
        return Colors.green;
      case ExpenseCategory.tech:
        return Colors.purple;
      case ExpenseCategory.home:
        return Colors.grey;
      case ExpenseCategory.travel:
        return Colors.black;
      case ExpenseCategory.other:
        return Colors.pinkAccent;
    }
  }
}
