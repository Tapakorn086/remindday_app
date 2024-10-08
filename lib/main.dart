import 'package:flutter/material.dart';
import 'package:remindday_app/calendar/screens/calendar_screen.dart';
import 'login/services/auth_service.dart';
import 'todolist/screens/todolist_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main()async {
    await initializeDateFormatting('th', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // เก็บสถานะของแท็บที่ถูกเลือก
  final AuthService _authService = AuthService();
  
  final List<Widget> _screens = [
    TodoDayListScreen(),
    CalendarScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], 
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        selectedFontSize: 16,
        unselectedFontSize: 14,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าแรก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'ปฏิทิน',
          ),
        ],
        currentIndex: _selectedIndex, 
        onTap: _onItemTapped, 
      ),
    );
  }
}
