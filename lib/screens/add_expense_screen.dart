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
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm khoản chi tiêu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề khoản chi',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Vui lòng nhập tiêu đề'
                    : null,
                onSaved: (value) => _title = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Số tiền (VND)'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Vui lòng nhập số tiền'
                    : null,
                onChanged: (value) {
                  // Tự động xoá dấu chấm và khoảng trắng nếu người dùng dán vào
                  _amountStr = value.replaceAll('.', '').replaceAll(',', '');
                },
                onSaved: (value) =>
                    _amountStr = value?.replaceAll('.', '') ?? '',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Ngày: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: const Text('Chọn ngày'),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
