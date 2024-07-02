import 'package:auth_app/components/button.dart';
import 'package:auth_app/components/textfield.dart';
import 'package:auth_app/service/get_active_interest.dart';
import 'package:auth_app/service/add_active_interest.dart';
import 'package:flutter/material.dart';

class InterestPage extends StatefulWidget {
  const InterestPage({super.key});

  @override
  State<InterestPage> createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
  final TextEditingController percentController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeInterest();
  }

  Future<void> _initializeInterest() async {
    setState(() {
      _isLoading = true;
    });

    String res = await getActiveInterest(context);
    if (res == "") {
      percentController.text = "None";
      setState(() {
        _isLoading = false;
      });
      return;
    }

    percentController.text = res;
    setState(() {
      _isLoading = false;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Bunga Anggota',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 80),
                      MyTextField(
                        controller: percentController,
                        hintText: 'Persentase Bunga Aktif (%)',
                        obscureText: false,
                      ),
                      const SizedBox(height: 25),
                      MyButton(
                        onTap: () => {
                          addActiveInterest(context, percentController.text)
                        },
                        buttonText: 'Update Bunga Aktif',
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
