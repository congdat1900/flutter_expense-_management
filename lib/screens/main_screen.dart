import 'package:budget/screens/add_expense_screen.dart';
import 'package:budget/screens/chart_screen.dart';
import 'package:budget/screens/home_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    const HomeScreen(),
    const SizedBox.shrink(), // placeholder cho nút thêm
    const ChartScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      // Mở màn thêm chi tiêu
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const AddExpenseScreen()));
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Biểu đồ',
          ),
        ],
      ),
    );
  }
}
