import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import '../theme/theme.dart';
import 'explore_screen.dart';
import 'organizations_screen.dart';
import 'profile_screen.dart';

class MainPage extends StatefulWidget {
  final String firstName;
  final String lastName;

  const MainPage({
    super.key,
  this.firstName = '',
  this.lastName = ''
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

    List<Widget> get _pages => [
    DashboardScreen(firstName:  widget.firstName, lastName: widget.lastName,),
      const ExploreScreen(),
      const OrganizationsScreen(),
      const ProfileScreen(),

  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index) ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: lightColorScheme.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: "Orgs"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
