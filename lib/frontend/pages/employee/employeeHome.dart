import 'package:flutter/material.dart';

import 'employeeDashboard_tab.dart';
import 'employeeTasks_tab.dart';
import 'employeeNotifications_tab.dart';
import 'employeeProfile_tab.dart';

class EmployeeHome extends StatefulWidget {
  const EmployeeHome({super.key});

  @override
  State<EmployeeHome> createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  int index = 0;

  final pages = const [
    EmployeeDashboardTab(),
    EmployeeTasksTab(),
    EmployeeNotificationsTab(),
    EmployeeProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 248, 250),
      appBar: AppBar(
        title: const Text("Employee"),
        centerTitle: true,
      ),
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        selectedItemColor: const Color.fromARGB(255, 25, 120, 110),
        unselectedItemColor: Colors.black54,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.checklist_outlined), label: "My Tasks"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none), label: "Alerts"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}
