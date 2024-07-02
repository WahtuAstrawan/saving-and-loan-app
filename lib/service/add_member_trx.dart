import "package:auth_app/pages/trx_history_page.dart";
import 'package:flutter/material.dart';
import "package:auth_app/components/show_alert_dialog.dart";
import "package:dio/dio.dart";
import "package:get_storage/get_storage.dart";

String removeCurrencyFormat(String text) {
  return text.replaceAll('Rp. ', '').replaceAll('.', '');
}

Future<void> addMemberTrx(BuildContext context, String memberId, String? trxId,
    TextEditingController formTrxNominal) async {
  final localStorage = GetStorage();
  final dio = Dio();
  const baseUrl = 'https://mobileapis.manpits.xyz/api';

  if (formTrxNominal.text.isEmpty || (trxId == null || trxId == "")) {
    showAlertDialog(context, "Error", "Harap mengisi semua kolom data");
    return;
  }

  formTrxNominal.text = removeCurrencyFormat(formTrxNominal.text);

  final onlyNumbers = RegExp(r'^[0-9]+$');
  if (!onlyNumbers.hasMatch(formTrxNominal.text)) {
    showAlertDialog(context, "Error",
        "Masukkan nominal dengan benar (Hanya angka dalam bentuk rupiah)");
    formTrxNominal.clear();
    return;
  }

  try {
    final response = await dio.post('$baseUrl/tabungan',
        data: {
          'anggota_id': memberId,
          'trx_id': trxId,
          'trx_nominal': formTrxNominal.text
        },
        options: Options(
          headers: {'Authorization': 'Bearer ${localStorage.read('token')}'},
        ));

    if (!response.data['success']) {
      showAlertDialog(context, "Error", response.data['message']);
      return;
    }

    showAlertDialog(
        context, "Success", "Transaksi member berhasil ditambahkan");

    formTrxNominal.clear();

    await Future.delayed(const Duration(seconds: 3));
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TrxHistoryPage(
                  memberId: memberId,
                )));
    return;
  } on DioException catch (e) {
    if (e.response != null && e.response!.statusCode! < 500) {
      if (e.response!.statusCode! == 406) {
        showAlertDialog(
            context, "Error", "Sesi login Anda telah habis, coba login ulang");
        localStorage.erase();
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }
      showAlertDialog(context, "Error", "Terjadi kesalahan, coba ulangi");
    } else {
      showAlertDialog(context, "Error", "Internal Server Error");
    }
    return;
  }
}
