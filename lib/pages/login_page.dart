import 'package:flutter/material.dart';
import 'package:auth_app/components/textfield.dart';
import 'package:auth_app/components/button.dart';
import 'package:auth_app/components/show_alert_dialog.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get_storage/get_storage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final localStorage = GetStorage();
  final dio = Dio();
  final baseUrl = 'https://mobileapis.manpits.xyz/api';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signInUser(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showAlertDialog(context, "Error", "Harap mengisi semua kolom data");
      return;
    }

    final String email = emailController.text;

    if (!EmailValidator.validate(email)) {
      showAlertDialog(
          context, "Error", "Format email yang Anda masukkan salah");
      return;
    }

    try {
      final response = await dio.post('$baseUrl/login', data: {
        'email': emailController.text,
        'password': passwordController.text
      });

      if (!response.data['success']) {
        showAlertDialog(
            context, "Error", "Terjadi kesalahan saat login akun, coba ulang");
        return;
      }

      localStorage.write('token', response.data['data']['token']);

      emailController.clear();
      passwordController.clear();
      Navigator.pushNamed(context, '/dashboard');
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

  void signUpUser(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 50),
            const Icon(
              Icons.beach_access,
              size: 110,
            ),
            const SizedBox(height: 40),
            const Text(
              'Halaman Login',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Lupa Password?',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            MyButton(onTap: () => signInUser(context), buttonText: 'Masuk'),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Belum punya akun?',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  child: const Text(
                    'Daftar sekarang',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => signUpUser(context),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
