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
    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 164, 227, 217),
                Color.fromARGB(255, 232, 226, 226),
              ],
            ),
          ),
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("Employee"),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: pages[index],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            currentIndex: index,
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
        ),
      ],
    );
  }
}
