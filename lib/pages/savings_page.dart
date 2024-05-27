import 'package:auth_app/pages/add_member_trx_page.dart';
import 'package:auth_app/pages/trx_history_page.dart';
import 'package:auth_app/service/get_member_balance.dart';
import 'package:auth_app/service/get_all_members.dart';
import "package:flutter/material.dart";

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  final _members = ValueNotifier<List<Map<String, dynamic>>>([]);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final members = await getAllMembers(context);
      _members.value = members;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  Expanded(
                    child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                      valueListenable: _members,
                      builder: (context, members, _) {
                        return ListView.builder(
                          itemCount: members.length,
                          itemBuilder: (context, index) {
                            final member = members[index];
                            return Container(
                              margin: const EdgeInsets.all(2.5),
                              color: Colors.grey[100],
                              height: 65.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('${member['nama']}'),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.addchart),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddMemberTrxPage(
                                                        memberId: member['id']
                                                            .toString(),
                                                      )));
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.history),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TrxHistoryPage(
                                                        memberId: member['id']
                                                            .toString(),
                                                      )));
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.account_balance_wallet),
                                        onPressed: () {
                                          showBalanceDialog(
                                              context, member['id'].toString());
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
