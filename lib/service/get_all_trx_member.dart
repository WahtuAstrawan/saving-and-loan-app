import 'package:auth_app/components/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

Future<List<Map<String, dynamic>>> getAllTrxMember(
    BuildContext context, String memberId) async {
  final localStorage = GetStorage();
  final dio = Dio();
  const baseUrl = 'https://mobileapis.manpits.xyz/api';
  List<Map<String, dynamic>> trxHistories = [];

  try {
    final response = await dio.get(
      '$baseUrl/tabungan/$memberId',
      options: Options(
        headers: {'Authorization': 'Bearer ${localStorage.read('token')}'},
      ),
    );

    trxHistories =
        List<Map<String, dynamic>>.from(response.data['data']['tabungan']);
    return trxHistories;
  } on DioException catch (e) {
    if (e.response != null && e.response!.statusCode! == 406) {
      showAlertDialog(
          context, "Error", "Sesi login Anda telah habis, coba login ulang");
      localStorage.erase();
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, '/login');
    } else if (e.response!.statusCode! < 500) {
      showAlertDialog(context, "Error",
          "Terjadi kesalahan saat mendapatkan histori transaksi member, coba ulang");
    } else {
      showAlertDialog(context, "Error", "Internal Server Error");
    }
  }

  return trxHistories;
}
