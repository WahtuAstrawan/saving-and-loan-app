import 'package:auth_app/service/get_all_trx_member.dart';
import 'package:auth_app/components/show_info_trx_member.dart';
import 'package:auth_app/service/get_member_balance.dart';
import 'package:auth_app/service/get_trx_type.dart';
import 'package:flutter/material.dart';

class TrxHistoryPage extends StatefulWidget {
  final String memberId;
  const TrxHistoryPage({super.key, required this.memberId});

  @override
  State<TrxHistoryPage> createState() => _TrxHistoryPageState();
}

class _TrxHistoryPageState extends State<TrxHistoryPage> {
  final _trxHistories = ValueNotifier<List<Map<String, dynamic>>>([]);
  final _trxType = ValueNotifier<List<Map<String, dynamic>>>([]);
  String _balance = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchBalance();
    _fetchTrxHistories();
    _fetchTrxType();
  }

  Future<void> _fetchBalance() async {
    String balance = await getMemberBalance(context, widget.memberId);
    setState(() {
      _balance = balance;
    });
  }  

  Future<void> _fetchTrxType() async {
    final trxType = await getTrxType(context);
    _trxType.value = trxType;
  }

  Future<void> _fetchTrxHistories() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final trxHistories = await getAllTrxMember(context, widget.memberId);
      _trxHistories.value = trxHistories;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getTrxTypeName(int id) {
    List<Map<String, dynamic>> trxTypeList = _trxType.value;
    if (trxTypeList.isNotEmpty && id >= 1 && id <= trxTypeList.length) {
      return trxTypeList[id - 1]['trx_name'];
    } else {
      return 'Transaksi';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Histori Transaksi'),

      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable: _trxHistories,
                builder: (context, trxHistories, _) {
                  if (trxHistories.isEmpty) {
                    return const Center(
                      child: Text(
                        'Tidak ada riwayat transaksi',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: trxHistories.length + 1,
                      itemBuilder: (context, index) {
                        if(index == 0) {
                          return Container(
                            margin: const EdgeInsets.all(2.5),
                            color: Colors.grey[200],
                            height: 65.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Sisa Saldo: Rp. ${_balance}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          final trxHistory = trxHistories[index - 1];
                          return InkWell(
                            onTap: () {
                              showInfoTrxMember(
                                  context,
                                  "Detail Transaksi",
                                  trxHistory,
                                  _getTrxTypeName(trxHistory['trx_id']));
                            },
                            child: Container(
                              margin: const EdgeInsets.all(2.5),
                              color: Colors.grey[100],
                              height: 65.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(_getTrxTypeName(
                                            trxHistory['trx_id'])),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child:
                                            Text('${trxHistory['trx_tanggal']}'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }
                },
              ),
            
      ),
    );
  }
}
