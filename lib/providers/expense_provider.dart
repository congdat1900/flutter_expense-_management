import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../services/prefs_service.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expenses => [..._expenses];

  double get totalAmount => _expenses.fold(0, (sum, item) => sum + item.amount);

  Future<void> loadExpenses() async {
    _expenses = await PrefsService.loadExpenses();
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    _expenses.add(expense);
    notifyListeners();
    await PrefsService.saveExpenses(_expenses);
  }

  Future<void> removeExpense(String id) async {
    _expenses.removeWhere((exp) => exp.id == id);
    notifyListeners();
    await PrefsService.saveExpenses(_expenses);
  }
}
