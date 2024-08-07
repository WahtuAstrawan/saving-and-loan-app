import 'package:auth_app/components/button.dart';
import 'package:auth_app/components/number_textfield.dart';
import 'package:auth_app/components/textfield.dart';
import 'package:auth_app/pages/trx_history_page.dart';
import 'package:auth_app/service/edit_member.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailMemberPage extends StatefulWidget {
  final Map<String, dynamic> memberData;
  const DetailMemberPage({super.key, required this.memberData});

  @override
  State<DetailMemberPage> createState() => _DetailMemberPageState();
}

class _DetailMemberPageState extends State<DetailMemberPage> {
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

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate =
        DateTime.tryParse(birthdayController.text) ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != initialDate) {
      setState(() {
        birthdayController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Detail Anggota',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                NumberTextField(
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: birthdayController,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Lahir (YYYY-MM-DD)',
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                NumberTextField(
                  controller: phoneNumController,
                  hintText: 'No Telepon',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      const Text(
                        'Status Keaktifan',
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(width: 30),
                      DropdownButton<String>(
                        value: _memberStatus,
                        items: const [
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
                  buttonText: 'Edit Anggota',
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TrxHistoryPage(
                                  memberId: widget.memberData['id'].toString(),
                                )))
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Center(
                      child: Text(
                        'Transaksi Anggota',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
