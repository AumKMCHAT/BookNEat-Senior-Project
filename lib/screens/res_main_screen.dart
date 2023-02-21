import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';
import '../widgets/res_main_body.dart';

class ResMainScreen extends StatefulWidget {
  const ResMainScreen({super.key});

  @override
  State<ResMainScreen> createState() => _ResMainScreen();
}

class _ResMainScreen extends State<ResMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [Body()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(context),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'หน้าหลัก',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: Colors.black,
            ),
            label: 'ถูกใจ',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
              color: Colors.black,
            ),
            label: 'ประวัติการจอง',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: 'โปรไฟล์',
            backgroundColor: Colors.white,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
