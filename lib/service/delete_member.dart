import 'package:auth_app/components/show_alert_dialog.dart';
import 'package:auth_app/components/show_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

Future<void> deleteMember(
    BuildContext context, String memberName, int memberId) async {
  final localStorage = GetStorage();
  final dio = Dio();
  const baseUrl = 'https://mobileapis.manpits.xyz/api';

  showConfirmDialog(context, "Warning",
      "Apakah Anda yakin ingin menghapus anggota dengan nama $memberName?",
      () async {
    try {
      final response = await dio.delete(
        '$baseUrl/anggota/$memberId',
        options: Options(
          headers: {'Authorization': 'Bearer ${localStorage.read('token')}'},
        ),
      );

      if (!response.data['success']) {
        showAlertDialog(context, "Error",
            "Terjadi kesalahan saat menghapus anggota, coba ulang");
        return;
      }

      showAlertDialog(context, "Success",
          "Anggota dengan nama $memberName berhasil dihapus");

      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushNamed(context, '/dashboard');
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
