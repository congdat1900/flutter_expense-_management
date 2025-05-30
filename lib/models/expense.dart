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
      'category': category.name, // Lưu dưới dạng tên string
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    // Đảm bảo category là chuỗi và thuộc các giá trị hợp lệ
    ExpenseCategory category;
    try {
      category = ExpenseCategory.values.byName(map['category']);
    } catch (_) {
      // Nếu không tìm thấy tên category, mặc định là 'other'
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
