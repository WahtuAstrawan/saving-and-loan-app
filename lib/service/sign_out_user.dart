import 'package:auth_app/components/show_alert_dialog.dart';
import 'package:auth_app/components/show_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

Future<void> signOutUser(BuildContext context) async {
  final localStorage = GetStorage();
  final dio = Dio();
  const baseUrl = 'https://mobileapis.manpits.xyz/api';

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
        showAlertDialog(
            context, "Error", "Sesi login Anda telah habis, coba login ulang");
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
