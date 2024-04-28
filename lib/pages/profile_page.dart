import 'package:auth_app/components/costum_button.dart';
import 'package:auth_app/components/show_alert_dialog.dart';
import 'package:auth_app/components/show_confirm_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final localStorage = GetStorage();
  final dio = Dio();
  final baseUrl = 'https://mobileapis.manpits.xyz/api';

  void getUserProfile() async {
    try {
      if (localStorage.read('id') != null ||
          localStorage.read('name') != null ||
          localStorage.read('email') != null) {
        return;
      }

      final response = await dio.get(
        '$baseUrl/user',
        options: Options(
          headers: {'Authorization': 'Bearer ${localStorage.read('token')}'},
        ),
      );

      localStorage.write('id', response.data['data']['user']['id']);
      localStorage.write('name', response.data['data']['user']['name']);
      localStorage.write('email', response.data['data']['user']['email']);
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode! == 406) {
        showAlertDialog(
            context, "Error", "Sesi login Anda telah habis, coba login ulang");
        localStorage.erase();
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacementNamed(context, '/login');
      } else if (e.response!.statusCode! < 500) {
        showAlertDialog(context, "Error",
            "Terjadi kesalahan saat mendapatkan data profile, coba ulang");
      } else {
        showAlertDialog(context, "Error", "Internal Server Error");
      }
      return;
    }
  }

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
              "Terjadi kesalahan saat melakukan logout, coba ulang");
          return;
        }

        localStorage.erase();
        Navigator.pushReplacementNamed(context, '/login');
        return;
      } on DioException catch (e) {
        if (e.response != null && e.response!.statusCode! < 500) {
          showAlertDialog(context, "Error",
              "Sesi login Anda telah habis, coba login ulang");
          localStorage.erase();
          await Future.delayed(const Duration(seconds: 2));
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          showAlertDialog(context, "Error", "Internal Server Error");
        }
        return;
      }
    });
    return;
  }

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(
              Icons.person,
              size: 150,
            ),
            const SizedBox(height: 50),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Nama',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    localStorage.read('name') != null
                        ? localStorage.read('name').toString()
                        : "Loading...",
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    localStorage.read('email') != null
                        ? localStorage.read('email').toString()
                        : "Loading...",
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CostumButton(
                    onTap: () => logoutUser(context),
                    buttonText: "Logout",
                    buttonColor: Colors.black,
                    textColor: Colors.white,
                    padding: 20,
                    margin: 7,
                    textSize: 16)
              ],
            ),
            const SizedBox(height: 50)
          ]),
        ),
      ),
    );
  }
}
