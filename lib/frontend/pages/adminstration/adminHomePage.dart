import 'package:flutter/material.dart';
import 'adminUsers_tab.dart';
import 'adminSettings_tab.dart';
import 'adminDashboard_tab.dart';


class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int index = 0;

  final pages = const [
    AdminDashboardTab(),
    AdminUsersTab(),
    AdminSettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 164, 227, 217),
      appBar: AppBar(
        title: const Text("Admin"),
        centerTitle: true,
      ),
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: "Users"),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "Settings"),
        ],
      ),
    );
  }
}