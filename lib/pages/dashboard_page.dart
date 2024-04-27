import 'package:auth_app/pages/profile_page.dart';
import 'package:auth_app/pages/settings_page.dart';
import 'package:auth_app/pages/home_page.dart';
import 'package:auth_app/components/show_confirm_dialog.dart';
import 'package:auth_app/components/show_alert_dialog.dart';
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

  void logoutUser(BuildContext context) {
    showConfirmDialog(context, "Warning", "Apakah Anda yakin ingin logout?",
        () async {
      try {
        final response = await dio.get(
          '$baseUrl/logout',
          options: Options(
            headers: {'Authorization': 'Bearer ${localStorage.read('token')}'},
          ),
        );

        if (!response.data['success']) {
          showAlertDialog(context, "Error",
              "Terjadi kesalahan saat logout akun, coba ulang");
          return;
        }

        localStorage.remove('token');
        Navigator.pushReplacementNamed(context, '/login');
        return;
      } on DioException catch (e) {
        if (e.response != null && e.response!.statusCode! < 500) {
          showAlertDialog(context, "Error",
              "Terjadi kesalahan saat logout akun, coba ulang");
        } else {
          showAlertDialog(context, "Error", "Internal Server Error");
        }
        return;
      }
    });
    return;
  }

  int _selectedPages = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedPages = index;
    });
  }

  final List _pages = [
    const HomePage(),
    const ProfilePage(),
    const SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPages],
      appBar: AppBar(
        title: const Center(
            child: Text("Dashboard", style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const Icon(
          Icons.beach_access,
          color: Colors.black,
          size: 25,
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => logoutUser(context),
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
                size: 25,
              ))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPages,
        onTap: _navigateBottomBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}
