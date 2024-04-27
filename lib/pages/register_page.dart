import "package:auth_app/components/button.dart";
import "package:auth_app/components/show_alert_dialog.dart";
import "package:auth_app/components/textfield.dart";
import 'package:email_validator/email_validator.dart';
import "package:flutter/material.dart";
import "package:dio/dio.dart";

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final dio = Dio();
  final baseUrl = 'https://mobileapis.manpits.xyz/api';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void signUpUser(BuildContext context) async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showAlertDialog(context, "Error", "Harap mengisi semua kolom data");
      return;
    }

    final String email = emailController.text;

    if (!EmailValidator.validate(email)) {
      showAlertDialog(
          context, "Error", "Format email yang Anda masukkan salah");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      showAlertDialog(
          context, "Error", "Password yang Anda masukkan tidak sama");
      return;
    }

    if (passwordController.text.length < 6 ||
        confirmPasswordController.text.length < 6) {
      showAlertDialog(context, "Error",
          "Password yang Anda masukkan tidak boleh kurang dari 6 karakter");
      return;
    }

    try {
      final response = await dio.post('$baseUrl/register', data: {
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text
      });

      if (!response.data['success']) {
        showAlertDialog(context, "Error",
            "Terjadi kesalahan saat mendaftar akun, coba ulang");
        return;
      }

      showAlertDialog(context, "Success", "Akun Anda berhasil terdaftar");

      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(Icons.beach_access, size: 110),
                const SizedBox(height: 40),
                const Text(
                  'Halaman Register',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                MyTextField(
                  controller: nameController,
                  hintText: 'Nama Lengkap',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Konfirmasi Password',
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                MyButton(
                  onTap: () => signUpUser(context),
                  buttonText: 'Daftar',
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      child: const Text(
                        'Login sekarang',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => Navigator.pushNamed(context, '/login'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
