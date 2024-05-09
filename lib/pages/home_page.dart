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
    _fetchData();
  }

  Future<void> _fetchData() async {
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
            ? CircularProgressIndicator()
            : Column(
                children: [
                  Expanded(
                    child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                      valueListenable: _members,
                      builder: (context, members, _) {
                        return ListView.builder(
                          itemCount: members.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 50,
                              color: Colors.redAccent,
                              child: Center(
                                child: Text('Name: ${members[index]['nama']}'),
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
