import 'package:auth_app/components/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get_storage/get_storage.dart';

void signInUser(BuildContext context, TextEditingController formEmail,
    TextEditingController formPassword) async {
  final localStorage = GetStorage();
  final dio = Dio();
  const baseUrl = 'https://mobileapis.manpits.xyz/api';

  if (formEmail.text.isEmpty || formPassword.text.isEmpty) {
    showAlertDialog(context, "Error", "Harap mengisi semua kolom data");
    return;
  }

  String email = formEmail.text;

  if (!EmailValidator.validate(email)) {
    showAlertDialog(context, "Error", "Format email yang Anda masukkan salah");
    return;
  }

  try {
    final response = await dio.post('$baseUrl/login',
        data: {'email': formEmail.text, 'password': formPassword.text});

    if (!response.data['success']) {
      showAlertDialog(
          context, "Error", "Terjadi kesalahan saat login akun, coba ulang");
      return;
    }

    localStorage.write('token', response.data['data']['token']);

    formEmail.clear();
    formPassword.clear();
    Navigator.pushReplacementNamed(context, '/dashboard');
    return;
  } on DioException catch (e) {
    if (e.response != null && e.response!.statusCode! < 500) {
      showAlertDialog(
          context, "Error", "Email atau Password yang Anda masukkan salah");
    } else {
      showAlertDialog(context, "Error", "Internal Server Error");
    }
    return;
  }
}
