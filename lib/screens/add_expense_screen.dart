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

  // Không thay đổi phần import và phần class model

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm khoản chi tiêu'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Tiêu đề
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Tiêu đề khoản chi',
                          prefixIcon: const Icon(Icons.title),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Vui lòng nhập tiêu đề'
                            : null,
                        onSaved: (value) => _title = value ?? '',
                      ),
                      const SizedBox(height: 16),

                      // Số tiền
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Số tiền (VND)',
                          prefixIcon: const Icon(Icons.money),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
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

                      // Danh mục
                      DropdownButtonFormField<ExpenseCategory>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Danh mục',
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
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
                          if (val != null) {
                            setState(() => _selectedCategory = val);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Ngày
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ngày: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                                style: theme.textTheme.bodyLarge,
                              ),
                              const Icon(Icons.calendar_today, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Nút lưu
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.save),
                  label: const Text('Lưu giao dịch'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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
}
