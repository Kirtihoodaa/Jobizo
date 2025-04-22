import 'package:flutter/material.dart';
import '../../Design contraints/FontSizes.dart';
import 'HistoryPages/HistoryPage.dart';
import 'HomePages/HomePagess.dart';
import 'RequestPages/CustomerRequest.dart';
import 'SettingsPages/CustomerSetting.dart';

class Customernavbar extends StatefulWidget {
  /// Which tab to highlight on startup (0 = Home, 1 = Approvals, 2 = History, 3 = Settings)
  final int currentIndex;

  const Customernavbar({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  State<Customernavbar> createState() => _CustomernavbarState();
}

class _CustomernavbarState extends State<Customernavbar> {
  static const _gold = Color(0xFFFAC015);
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() => _selectedIndex = index);

    Widget page;
    switch (index) {
      case 0:
        page = Homepages();
        break;
      case 1:
        page = Customerrequest();
        break;
      case 2:
        page = Histotypagee();
        break;
      case 3:
        page = Customersetting();
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
            icon: Icon(Icons.sync),
            label: 'Request',
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
