import 'package:auth_app/components/button.dart';
import 'package:auth_app/components/currency_textfield.dart';
import 'package:auth_app/service/add_member_trx.dart';
import 'package:auth_app/service/get_trx_type.dart';
import 'package:flutter/material.dart';

class AddMemberTrxPage extends StatefulWidget {
  final String memberId;

  const AddMemberTrxPage({super.key, required this.memberId});

  @override
  State<AddMemberTrxPage> createState() => _AddMemberTrxPageState();
}

class _AddMemberTrxPageState extends State<AddMemberTrxPage> {
  String? trxId;
  final TextEditingController trxNominal = TextEditingController();
  final _trxType = ValueNotifier<List<Map<String, dynamic>>>([]);

  @override
  void initState() {
    super.initState();
    _fetchTrxType();
  }

  Future<void> _fetchTrxType() async {
    final trxType = await getTrxType(context);
    _trxType.value = trxType;
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
                  'Tambah Transaksi',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      const Text(
                        'Jenis Transaksi',
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(width: 30),
                      ValueListenableBuilder<List<Map<String, dynamic>>>(
                        valueListenable: _trxType,
                        builder: (context, trxType, _) {
                          return DropdownButton<String>(
                            value: trxId,
                            items: trxType.map<DropdownMenuItem<String>>(
                                (Map<String, dynamic> item) {
                              return DropdownMenuItem<String>(
                                value: item['id'].toString(),
                                child: Text(item['trx_name']),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                trxId = newValue;
                              });
                            },
                            hint: const Text('Pilih Jenis Transaksi'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                CurrencyTextField(
                    hintText: 'Masukkan Nominal (Rp)',
                    obscureText: false,
                    controller: trxNominal),
                const SizedBox(height: 25),
                MyButton(
                  onTap: () => {
                    addMemberTrx(context, widget.memberId, trxId, trxNominal)
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
