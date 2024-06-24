import 'package:flutter/material.dart';
import "package:auth_app/components/show_alert_dialog.dart";
import "package:dio/dio.dart";
import "package:get_storage/get_storage.dart";

Future<void> addActiveInterest(BuildContext context, String percent) async {
  final localStorage = GetStorage();
  final dio = Dio();
  const baseUrl = 'https://mobileapis.manpits.xyz/api';

  if (percent == "") {
    showAlertDialog(context, "Error", "Harap mengisi semua kolom data");
    return;
  }

  final onlyNumbers = RegExp(r'^\d+(\.\d+)?$');
  if (!onlyNumbers.hasMatch(percent)) {
    showAlertDialog(
        context, "Error", "Pastikan data persen hanya angka atau desimal");
    return;
  }

  try {
    final response = await dio.post('$baseUrl/addsettingbunga',
        data: {'persen': percent, 'isaktif': '1'},
        options: Options(
          headers: {'Authorization': 'Bearer ${localStorage.read('token')}'},
        ));

    if (!response.data['success']) {
      showAlertDialog(context, "Error", response.data['message']);
      return;
    }

    showAlertDialog(context, "Success", "Bunga aktif berhasil diupdate");

    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, '/dashboard');
    return;
  } on DioException catch (e) {
    if (e.response != null && e.response!.statusCode! < 500) {
      showAlertDialog(context, "Error", "Terjadi kesalahan, coba ulangi");
    } else {
      showAlertDialog(context, "Error", "Internal Server Error");
    }
    return;
  }
}
