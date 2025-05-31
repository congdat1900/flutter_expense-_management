enum ExpenseCategory {
  food,
  tech,
  shopping,
  entertainment,
  home,
  travel,
  pet,
  other,
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category.name,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    ExpenseCategory category;
    try {
      category = ExpenseCategory.values.byName(map['category']);
    } catch (_) {
      category = ExpenseCategory.other;
    }

    return Expense(
      id: map['id'],
      title: map['title'],
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date']),
      category: category,
    );
  }
}
