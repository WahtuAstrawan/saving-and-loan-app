import 'package:flutter/material.dart';
import 'package:auth_app/components/show_alert_dialog.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

Future<String> getActiveInterest(BuildContext context) async {
  final localStorage = GetStorage();
  final dio = Dio();
  const baseUrl = 'https://mobileapis.manpits.xyz/api';

  try {
    final response = await dio.get(
      '$baseUrl/settingbunga',
      options: Options(
        headers: {'Authorization': 'Bearer ${localStorage.read('token')}'},
      ),
    );

    if (response.data['data']['activebunga'] == null) {
      return "";
    }

    return response.data['data']['activebunga']['persen'].toString();
  } on DioException catch (e) {
    if (e.response != null && e.response!.statusCode! == 406) {
      showAlertDialog(
          context, "Error", "Sesi login Anda telah habis, coba login ulang");
      localStorage.erase();
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, '/login');
    } else if (e.response!.statusCode! < 500) {
      showAlertDialog(context, "Error",
          "Terjadi kesalahan saat mendapatkan data bunga, coba ulang");
    } else {
      showAlertDialog(context, "Error", "Internal Server Error");
    }
    return "";
  }
}
