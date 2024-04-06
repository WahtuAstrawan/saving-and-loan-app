import 'package:flutter/material.dart';
import 'package:auth_app/components/textfield.dart';
import 'package:auth_app/components/button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void signInUser(BuildContext context) {
    Navigator.pushNamed(context, '/dashboard');
  }

  void signUpUser(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
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
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            const SizedBox(height: 40),
            const MyTextField(
              hintText: 'Username',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            const MyTextField(
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
            MySignInButton(
              onTap: () => signInUser(context),
            ),
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
