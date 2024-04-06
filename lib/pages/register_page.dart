import "package:auth_app/components/button.dart";
import "package:auth_app/components/textfield.dart";
import "package:flutter/material.dart";

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  void signUpUser(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Icon(Icons.beach_access, size: 110),
              const SizedBox(height: 40),
              const Text('Halaman Register',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              const MyTextField(hintText: 'Nama Lengkap', obscureText: false),
              const SizedBox(height: 10),
              const MyTextField(hintText: 'Username', obscureText: false),
              const SizedBox(height: 10),
              const MyTextField(hintText: 'Password', obscureText: true),
              const SizedBox(height: 10),
              const MyTextField(
                  hintText: 'Konfirmasi Password', obscureText: true),
              const SizedBox(height: 25),
              MyButton(onTap: () => signUpUser(context), buttonText: 'Daftar'),
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
                    onTap: () => signUpUser(context),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
