import 'package:flutter/material.dart';
import 'package:pfa_parkinson/pages/conseil_page.dart';
import 'package:pfa_parkinson/pages/profile_page.dart';
import 'package:pfa_parkinson/pages/test_page.dart';
import 'package:pfa_parkinson/pages/notification.dart';
import 'package:pfa_parkinson/pages/settings.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> tabs = <Widget>[
    const ConseilPage(),
    const TestPage(),
    const ProfilePage(),
    const NotificationsPage(),
    const SettingsPage(), // Ajout de la page Settings
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'Conseil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Test',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
                    BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 8,
      ),
    );
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }
}
