import 'package:auth_app/components/button.dart';
import 'package:auth_app/components/textfield.dart';
import 'package:auth_app/service/edit_member.dart';
import 'package:flutter/material.dart';

class EditMemberPage extends StatefulWidget {
  final Map<String, dynamic> memberData;

  const EditMemberPage({super.key, required this.memberData});

  @override
  State<EditMemberPage> createState() => _EditMemberPageState();
}

class _EditMemberPageState extends State<EditMemberPage> {
  final TextEditingController registerNumController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController phoneNumController = TextEditingController();
  String _memberStatus = "";

  @override
  void initState() {
    super.initState();
    registerNumController.text = widget.memberData['nomor_induk'].toString();
    nameController.text = widget.memberData['nama'];
    addressController.text = widget.memberData['alamat'];
    birthdayController.text = widget.memberData['tgl_lahir'];
    phoneNumController.text = widget.memberData['telepon'];
    _memberStatus = widget.memberData['status_aktif'].toString();
  }

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
                  'Edit Anggota',
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
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Text(
                        'Status Keaktifan',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(width: 30),
                      DropdownButton<String>(
                        value: _memberStatus,
                        items: [
                          DropdownMenuItem<String>(
                            value: '1',
                            child: Text('Aktif'),
                          ),
                          DropdownMenuItem<String>(
                            value: '0',
                            child: Text('Tidak Aktif'),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => _memberStatus = value!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                MyButton(
                  onTap: () => {
                    editMember(
                        context,
                        registerNumController,
                        nameController,
                        addressController,
                        birthdayController,
                        phoneNumController,
                        _memberStatus,
                        widget.memberData['id'])
                  },
                  buttonText: 'Edit',
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
