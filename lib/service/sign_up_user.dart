import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import "package:auth_app/components/show_alert_dialog.dart";
import "package:dio/dio.dart";

Future<void> signUpUser(
    BuildContext context,
    TextEditingController formName,
    TextEditingController formEmail,
    TextEditingController formPassword,
    TextEditingController formConfirmPassword) async {
  final dio = Dio();
  const baseUrl = 'https://mobileapis.manpits.xyz/api';

  if (formName.text.isEmpty ||
      formEmail.text.isEmpty ||
      formPassword.text.isEmpty ||
      formConfirmPassword.text.isEmpty) {
    showAlertDialog(context, "Error", "Harap mengisi semua kolom data");
    return;
  }

  final String email = formEmail.text;

  if (!EmailValidator.validate(email)) {
    showAlertDialog(context, "Error", "Format email yang Anda masukkan salah");
    return;
  }

  if (formPassword.text != formConfirmPassword.text) {
    showAlertDialog(context, "Error", "Password yang Anda masukkan tidak sama");
    return;
  }

  if (formPassword.text.length < 6 || formConfirmPassword.text.length < 6) {
    showAlertDialog(context, "Error",
        "Password yang Anda masukkan tidak boleh kurang dari 6 karakter");
    return;
  }

  try {
    final response = await dio.post('$baseUrl/register', data: {
      'name': formName.text,
      'email': formEmail.text,
      'password': formPassword.text
    });

    if (!response.data['success']) {
      showAlertDialog(context, "Error",
          "Terjadi kesalahan saat mendaftar akun, coba ulang");
      return;
    }

    showAlertDialog(context, "Success", "Akun Anda berhasil terdaftar");

    formName.clear();
    formEmail.clear();
    formPassword.clear();
    formConfirmPassword.clear();
    return;
  } on DioException catch (e) {
    if (e.response != null && e.response!.statusCode! < 500) {
      String errorMessage = "";
      if (e.response!.data != null && e.response!.data['message'] != null) {
        var message = e.response!.data['message'];
        if (message is Map && message.isNotEmpty) {
          var firstMessage = message.values.first;
          if (firstMessage is List && firstMessage.isNotEmpty) {
            errorMessage = firstMessage[0];
          }
        }
      }
      showAlertDialog(context, "Error", errorMessage);
    } else {
      showAlertDialog(context, "Error", "Internal Server Error");
    }
    return;
  }
}
