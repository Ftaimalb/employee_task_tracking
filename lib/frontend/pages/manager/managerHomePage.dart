import 'package:flutter/material.dart';

import 'managerDashboard_tab.dart';
import 'managerTasks_tab.dart';
import 'managerProfile_tab.dart';

class ManagerHome extends StatefulWidget {
  const ManagerHome({super.key});

  @override
  State<ManagerHome> createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  int index = 0;

  final pages = const [
    ManagerDashboardTab(),
    ManagerTasksTab(),
    ManagerProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Manager"),
        centerTitle: true,
      ),
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: "Tasks"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}