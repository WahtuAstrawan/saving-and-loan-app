import 'package:flutter/material.dart';
import 'package:auth_app/components/show_alert_dialog.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

Future<String> getMemberBalance(BuildContext context, String memberId) async {
  final localStorage = GetStorage();
  final dio = Dio();
  const baseUrl = 'https://mobileapis.manpits.xyz/api';

  try {
    final response = await dio.get(
      '$baseUrl/saldo/$memberId',
      options: Options(
        headers: {'Authorization': 'Bearer ${localStorage.read('token')}'},
      ),
    );

    return response.data['data']['saldo'].toString();
  } on DioException catch (e) {
    if (e.response != null && e.response!.statusCode! == 406) {
      showAlertDialog(
          context, "Error", "Sesi login Anda telah habis, coba login ulang");
      localStorage.erase();
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, '/login');
    } else if (e.response!.statusCode! < 500) {
      showAlertDialog(context, "Error",
          "Terjadi kesalahan saat mendapatkan data saldo member, coba ulang");
    } else {
      showAlertDialog(context, "Error", "Internal Server Error");
    }
    return "";
  }
}

void showBalanceDialog(BuildContext context, String memberId) async {
  String balance = await getMemberBalance(context, memberId);
  showAlertDialog(context, "Info Saldo", 'Rp. $balance');
}
