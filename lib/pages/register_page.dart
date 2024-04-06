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
              SizedBox(height: 50),
              Icon(Icons.beach_access, size: 110),
              SizedBox(height: 40),
              Text('Halaman Register',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 40),
              MyTextField(hintText: 'Nama Lengkap', obscureText: false),
              SizedBox(height: 10),
              MyTextField(hintText: 'Username', obscureText: false),
              SizedBox(height: 10),
              MyTextField(hintText: 'Password', obscureText: true),
              SizedBox(height: 10),
              MyTextField(hintText: 'Konfirmasi Password', obscureText: true),
              SizedBox(height: 25),
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
