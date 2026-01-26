import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login/login_page.dart';
import 'createUserPage.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 164, 227, 217),
      appBar: AppBar(title: const Text("Admin Dashboard")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.admin_panel_settings, size: 36),
                  SizedBox(height: 12),
                  Text("Admin Menu",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  SizedBox(height: 4),
                  Text("Manage users and settings"),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt_1),
              title: const Text("Create User"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateUserPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          "Welcome, Admin",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
