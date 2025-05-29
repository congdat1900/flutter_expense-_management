import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/expense.dart';

class PrefsService {
  static const String expensesKey = 'expenses';

  // Lưu list expense dưới dạng json string
  static Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = expenses
        .map((e) => json.encode(e.toMap()))
        .toList();
    await prefs.setStringList(expensesKey, jsonList);
  }

  // Đọc list expense từ SharedPreferences
  static Future<List<Expense>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(expensesKey);
    if (jsonList == null) return [];
    return jsonList
        .map((jsonStr) => Expense.fromMap(json.decode(jsonStr)))
        .toList();
  }
}
