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
            title: const Text("Manager"),
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
                icon: Icon(Icons.dashboard_outlined),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_outlined),
                label: "Tasks",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: "Profile",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
