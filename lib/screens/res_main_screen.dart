import 'package:book_n_eat_senior_project/screens/fav_screen.dart';
import 'package:book_n_eat_senior_project/screens/history_screen.dart';
import 'package:book_n_eat_senior_project/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/res_main_body.dart';
import '../widgets/screen_app_bar.dart';

class ResMainScreen extends StatefulWidget {
  const ResMainScreen({super.key});

  @override
  State<ResMainScreen> createState() => _ResMainScreen();
}

class _ResMainScreen extends State<ResMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ResBody(),
    FavScreen(),
    HistoryScreen(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: screenAppBar(context),
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
