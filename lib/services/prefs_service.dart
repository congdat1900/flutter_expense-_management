import 'dart:convert';

import 'package:budget/models/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const String expensesKey = 'expenses';
  static const String lastUpdateKey = 'last_update';

  // Lưu list expense dưới dạng json string
  static Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = expenses
        .map((e) => json.encode(e.toMap()))
        .toList();
    await prefs.setStringList(expensesKey, jsonList);

    // Lưu thời điểm cập nhật cuối cùng
    await saveLastUpdate(DateTime.now());
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

  // Thời gian cập nhật cuối cùng
  static Future<void> saveLastUpdate(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(lastUpdateKey, time.toIso8601String());
  }

  static Future<DateTime?> getLastUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(lastUpdateKey);
    return str != null ? DateTime.tryParse(str) : null;
  }

  // (Tùy chọn) Xoá dữ liệu
  static Future<void> clearExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(expensesKey);
    await prefs.remove(lastUpdateKey);
  }
}
