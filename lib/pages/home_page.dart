import 'package:auth_app/components/show_info_member.dart';
import 'package:auth_app/pages/detail_member_page.dart';
import 'package:auth_app/pages/edit_member_page.dart';
import 'package:auth_app/service/delete_member.dart';
import 'package:auth_app/service/get_all_members.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailMemberPage(
                                            memberData: member)));
                              },
                              child: Container(
                                margin: const EdgeInsets.all(2.5),
                                color: Colors.grey[100],
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, top: 10.0),
                                          child: Text(
                                            '${member['nama']}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                              member['status_aktif'] == 1
                                                  ? '--- Aktif ---'
                                                  : '--- Tidak Aktif ---'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 10.0),
                                          child: Text('${member['alamat']}'),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            deleteMember(context,
                                                member['nama'], member['id']);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/member/add');
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.grey[700],
                            elevation: 0.0,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
