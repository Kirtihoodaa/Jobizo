import 'package:flutter/material.dart';
import '../Design contraints/FontSizes.dart';
import 'Approval Screens/ApprovalsPage.dart';
import 'Histroy Pages/HistoryPage.dart';
import 'Home Screens/HomePage.dart';
import 'Settings pages/SettingPage.dart';

class NavBarLabour extends StatefulWidget {
  final int currentIndex;

  const NavBarLabour({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  State<NavBarLabour> createState() => _NavBarLabourState();
}

class _NavBarLabourState extends State<NavBarLabour> {
  static const _gold = Color(0xFFFAC015);
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

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

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
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
    );
  }
}