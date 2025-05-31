import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/expense.dart';

class ExpensesTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;

  const ExpensesTile({
    super.key,
    required this.expense,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '',
      decimalDigits: 0,
    );

    final categoryColor = _getCategoryColor(expense.category);
    final iconPath = _getCategoryIconPath(expense.category);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(child: Image.asset(iconPath, width: 22, height: 22)),
          ),
          title: Text(
            expense.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            DateFormat('dd/MM/yyyy').format(expense.date),
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${formatter.format(expense.amount)} đ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: categoryColor,
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.delete, size: 20, color: Colors.red),
              ),
            ],
          ),
        ),
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

  String _getCategoryIconPath(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return 'assets/icons/food.png';
      case ExpenseCategory.pet:
        return 'assets/icons/pet.png';
      case ExpenseCategory.entertainment:
        return 'assets/icons/entertainment.png';
      case ExpenseCategory.shopping:
        return 'assets/icons/shopping.png';
      case ExpenseCategory.home:
        return 'assets/icons/home.png';
      case ExpenseCategory.tech:
        return 'assets/icons/tech.png';
      case ExpenseCategory.travel:
        return 'assets/icons/travel.png';
      case ExpenseCategory.other:
        return 'assets/icons/other.png';
    }
  }
}
