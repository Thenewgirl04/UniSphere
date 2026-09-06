import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import '../theme/theme.dart';
import 'profile_screen.dart';

class MainPage extends StatefulWidget {
  final String firstName;
  final String lastName;

  const MainPage({
    super.key,
    this.firstName = '',
    this.lastName = '',
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardScreen(firstName: widget.firstName, lastName: widget.lastName),
      ProfileScreen(
        displayName: '${widget.firstName} ${widget.lastName}'.trim(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: lightColorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
