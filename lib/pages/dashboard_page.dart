import 'package:auth_app/pages/profile_page.dart';
import 'package:auth_app/pages/settings_page.dart';
import 'package:auth_app/pages/home_page.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  void logoutUser(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

  int _selectedPages = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedPages = index;
    });
  }

  final List _pages = [HomePage(), ProfilePage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPages],
      appBar: AppBar(
        title: Center(
            child:
                const Text("Dashboard", style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const Icon(
          Icons.beach_access,
          color: Colors.white,
          size: 35,
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => logoutUser(context),
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
                size: 35,
              ))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPages,
        onTap: _navigateBottomBar,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}
