import 'package:flutter/material.dart';

import '../Design contraints/FontSizes.dart';
import 'Approval Screens/ApprovalsPage.dart';
import 'Histroy Pages/HistoryPage.dart';
import 'Home Screens/HomePage.dart';
import 'Settings pages/SettingPage.dart';

class NavBarLabour extends StatefulWidget {
  @override
  _NavBarLabourState createState() => _NavBarLabourState();
}

class _NavBarLabourState extends State<NavBarLabour> {
  int _selectedIndex = 0;
  static const _gold = Color(0xFFFAC015);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Widget page;
    switch (index) {
      case 0:
        page = Homepage();
        break;
      case 1:
        page = ApprovalsPage();
        break;
      case 2:
        page = HistoryPage();
        break;
      case 3:
        page = SettingsPage();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text('Select a tab below')),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: _gold,
          unselectedItemColor: Colors.black,
          selectedFontSize: secondary(),
          unselectedFontSize: tertiary(),
          iconSize: 25,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle),
              label: 'Approvals',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
