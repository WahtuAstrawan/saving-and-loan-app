import 'package:auth_app/pages/profile_page.dart';
import 'package:auth_app/pages/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final localStorage = GetStorage();
  final dio = Dio();
  final baseUrl = 'https://mobileapis.manpits.xyz/api';

  int _selectedPages = 0;
  String _selectedPagesName = "Home";

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedPages = index;
      _selectedPagesName = index == 0 ? "Home" : "Profile";
    });
  }

  final List _pages = [HomePage(), const ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPages],
      appBar: AppBar(
        title: Center(
            child: Text(_selectedPagesName,
                style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPages,
        onTap: _navigateBottomBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
      ),
    );
  }
}
