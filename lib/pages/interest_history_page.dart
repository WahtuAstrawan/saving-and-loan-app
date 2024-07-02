import 'package:auth_app/service/get_all_interest.dart';
import 'package:flutter/material.dart';

class InterestHistoryPage extends StatefulWidget {
  const InterestHistoryPage({super.key});

  @override
  State<InterestHistoryPage> createState() => _InterestHistoryPageState();
}

class _InterestHistoryPageState extends State<InterestHistoryPage> {
  bool _isLoading = false;
  final _interests = ValueNotifier<List<Map<String, dynamic>>>([]);

  @override
  void initState() {
    super.initState();
    _fetchInterests();
  }

  Future<void> _fetchInterests() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final interests = await getAllInterest(context);
      _interests.value = interests;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histori Bunga'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  Expanded(
                    child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                      valueListenable: _interests,
                      builder: (context, interests, _) {
                        if (interests.isEmpty) {
                          return const Center(
                            child: Text(
                              'Tidak ada histori bunga',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: interests.length,
                            itemBuilder: (context, index) {
                              final interest = interests[index];
                              return Container(
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
                                              'Bunga: ${interest['persen']} %'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 10.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                color: interest['isaktif'] == 1
                                                    ? Colors.green
                                                    : Colors.red,
                                                size: 6,
                                              ),
                                              const SizedBox(width: 4.0),
                                              Text(
                                                  interest['isaktif'] == 1
                                                      ? 'Aktif'
                                                      : 'Tidak Aktif',
                                                  style: TextStyle(
                                                    color:
                                                        interest['isaktif'] == 1
                                                            ? Colors.green
                                                            : Colors.red,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
