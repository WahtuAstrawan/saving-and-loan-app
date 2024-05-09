import 'package:auth_app/components/button.dart';
import 'package:auth_app/components/textfield.dart';
import 'package:auth_app/service/add_member.dart';
import 'package:flutter/material.dart';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({super.key});

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final TextEditingController registerNumController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController phoneNumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Tambah Anggota',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                MyTextField(
                  controller: registerNumController,
                  hintText: 'No Induk',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: nameController,
                  hintText: 'Nama',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: addressController,
                  hintText: 'Alamat',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: birthdayController,
                  hintText: 'Tanggal Lahir (YYYY-MM-DD)',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: phoneNumController,
                  hintText: 'No Telepon',
                  obscureText: false,
                ),
                const SizedBox(height: 25),
                MyButton(
                  onTap: () => {
                    addMember(
                        context,
                        registerNumController,
                        nameController,
                        addressController,
                        birthdayController,
                        phoneNumController)
                  },
                  buttonText: 'Tambah',
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
