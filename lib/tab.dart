import 'package:flutter/material.dart';
import 'package:invoseg_security/home.dart';
import 'package:invoseg_security/log.dart';

class TabsScreen extends StatefulWidget {
  static const route = 'tabsScreen';

  TabsScreen({super.key, required this.index});
  int index = 0;
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late List<Map<String, Object>> _pages;
  @override
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        // 'Pages': Plots(),

        'Pages': const Home(),
        'title': 'Home',
      },
      {
        'Pages': const Log(),
        'title': 'Grocery',
      },
      // {
      //   // 'Pages': const Emergency(),
      //   'title': 'Emergency',
      // },
    ];
    super.initState();
    // getAllIsReadStatus();
    setState(() {
      _selectedPageIndex = widget.index;

      // widget.index;
    });
  }

  //changing this from 0 to 1

  void _selectPage(int index) {
    setState(() {
      // _selectedPageIndex = 3;
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex]['Pages'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Log',
          ),
        ],
      ),
    );
  }
}
