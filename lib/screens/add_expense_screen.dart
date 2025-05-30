import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _amountStr = '';
  DateTime _selectedDate = DateTime.now();
  ExpenseCategory _selectedCategory = ExpenseCategory.food;

  void _submit() {
    final isValid = _formKey.currentState?.validate();
    if (isValid == null || !isValid) return;

    _formKey.currentState?.save();

    final amount = double.tryParse(_amountStr);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Số tiền không hợp lệ')));
      return;
    }

    final newExpense = Expense(
      id: const Uuid().v4(),
      title: _title,
      amount: amount,
      date: _selectedDate,
      category: _selectedCategory,
    );

    Provider.of<ExpenseProvider>(context, listen: false).addExpense(newExpense);
    Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Thêm khoản chi tiêu')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Card Title
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Tiêu đề khoản chi',
                          prefixIcon: Icon(Icons.title),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Vui lòng nhập tiêu đề'
                            : null,
                        onSaved: (value) => _title = value ?? '',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Số tiền (VND)',
                          prefixIcon: Icon(Icons.money),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Vui lòng nhập số tiền'
                            : null,
                        onChanged: (value) {
                          _amountStr = value
                              .replaceAll('.', '')
                              .replaceAll(',', '')
                              .trim();
                        },
                        onSaved: (value) =>
                            _amountStr = value?.replaceAll('.', '') ?? '',
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<ExpenseCategory>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Danh mục',
                          border: OutlineInputBorder(),
                        ),
                        items: ExpenseCategory.values.map((cat) {
                          return DropdownMenuItem(
                            value: cat,
                            child: Row(
                              children: [
                                Image.asset(
                                  _getCategoryIconPath(cat),
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(_getCategoryName(cat)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null)
                            setState(() => _selectedCategory = val);
                        },
                      ),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ngày: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                            style: theme.textTheme.bodyLarge,
                          ),
                          TextButton.icon(
                            onPressed: _pickDate,
                            icon: const Icon(Icons.calendar_today),
                            label: const Text('Chọn ngày'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  onPressed: _submit,
                  label: const Text('Lưu giao dịch'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryName(ExpenseCategory cat) {
    switch (cat) {
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

  String _getCategoryIconPath(ExpenseCategory cat) {
    switch (cat) {
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
