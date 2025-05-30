import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import '../widgets/balance_summary.dart';
import '../widgets/expenses_tile.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseProvider>(context, listen: false).loadExpenses().then((
      _,
    ) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final expenses = expenseProvider.expenses;

    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý chi tiêu'), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Tổng chi tiêu
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.tertiary,
                        ],
                        transform: const GradientRotation(pi / 4),
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.grey.withOpacity(0.3),
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: BalanceSummary(total: expenseProvider.totalAmount),
                  ),
                ),

                // Danh sách chi tiêu
                Expanded(
                  child: expenses.isEmpty
                      ? const Center(
                          child: Text(
                            'Chưa có khoản chi tiêu nào',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.separated(
                          itemCount: expenses.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 4),
                          itemBuilder: (context, index) {
                            final expense = expenses[index];
                            return ExpensesTile(
                              expense: expense,
                              onDelete: () =>
                                  expenseProvider.removeExpense(expense.id),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
