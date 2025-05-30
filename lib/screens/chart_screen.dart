import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<ExpenseProvider>(context).expenses;

    // Tính tổng tiền theo từng category
    Map<ExpenseCategory, double> categoryTotals = {
      for (var category in ExpenseCategory.values) category: 0,
    };
    for (var exp in expenses) {
      categoryTotals[exp.category] =
          (categoryTotals[exp.category] ?? 0) + exp.amount;
    }

    // Lọc bỏ các category có tổng bằng 0
    final showingCategories = categoryTotals.entries
        .where((e) => e.value > 0)
        .toList();

    final categoryColors = {
      ExpenseCategory.food: Colors.redAccent,
      ExpenseCategory.pet: Colors.blueAccent,
      ExpenseCategory.shopping: Colors.green,
      ExpenseCategory.entertainment: Colors.orange,
      ExpenseCategory.tech: Colors.purple,
      ExpenseCategory.home: Colors.grey,
      ExpenseCategory.travel: Colors.black,
      ExpenseCategory.other: Colors.pinkAccent,
    };

    final totalAmount = categoryTotals.values.fold(0.0, (a, b) => a + b);

    // Formatter tiền Việt Nam
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      appBar: AppBar(title: const Text('Biểu đồ chi tiêu'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: showingCategories.isEmpty
            ? const Center(
                child: Text(
                  'Chưa có khoản chi tiêu nào để hiển thị biểu đồ',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                children: [
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: Colors.black45,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        height: 280,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 4,
                            centerSpaceRadius: 60,
                            sections: showingCategories.map((entry) {
                              final percent = entry.value / totalAmount * 100;
                              return PieChartSectionData(
                                color: categoryColors[entry.key],
                                value: entry.value,
                                title: '${percent.toStringAsFixed(1)}%',
                                radius: 90,
                                titleStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                badgeWidget: _Badge(
                                  label: describeCategory(entry.key),
                                ),
                                badgePositionPercentageOffset: .98,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Tổng chi tiêu: ${formatter.format(totalAmount)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 14,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: showingCategories.map((entry) {
                      return _LegendItem(
                        color: categoryColors[entry.key]!,
                        label: describeCategory(entry.key),
                        amount: entry.value,
                        formatter: formatter,
                      );
                    }).toList(),
                  ),
                ],
              ),
      ),
    );
  }

  String describeCategory(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return 'Ăn uống';
      case ExpenseCategory.pet:
        return 'pet';
      case ExpenseCategory.entertainment:
        return 'Giải trí';
      case ExpenseCategory.shopping:
        return 'Mua sắm';
      case ExpenseCategory.tech:
        return 'Công nghệ';
      case ExpenseCategory.travel:
        return 'Du lịch';
      case ExpenseCategory.home:
        return 'Nhà';
      case ExpenseCategory.other:
        return 'Khác';
    }
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final double amount;
  final NumberFormat formatter;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.amount,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.6),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ${formatter.format(amount)}',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
