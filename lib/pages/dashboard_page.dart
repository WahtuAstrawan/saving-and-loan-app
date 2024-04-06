import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  void logoutUser(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child:
                const Text("Dashboard", style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const Icon(
          Icons.beach_access,
          color: Colors.white,
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => logoutUser(context),
            icon: const Icon(Icons.logout),
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
