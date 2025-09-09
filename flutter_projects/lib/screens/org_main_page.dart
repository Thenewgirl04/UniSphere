import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'events_list.dart';
import 'org_dash_screen.dart';
import 'org_profile_screen.dart';

class OrgMainPage extends StatefulWidget {
  const OrgMainPage({super.key});

  @override
  State<OrgMainPage> createState() => _OrgMainPageState();
}

class _OrgMainPageState extends State<OrgMainPage> {
  int _selectedIndex = 0;

    List<Widget> get _pages => [
      OrgDashScreen(),
      OrgEventsScreen(),
      OrgProfileScreen(),
    ];

    void _onItemTapped(int index) {
      setState(() => _selectedIndex = index);

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
        BottomNavigationBarItem(icon: Icon(Icons.event), label:"Events"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
    );
  }
}
