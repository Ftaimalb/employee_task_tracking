import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login/login_page.dart';
import '../../widgets/UI_cards.dart';

class AdminSettingsTab extends StatelessWidget {
  const AdminSettingsTab({super.key});

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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionTitle(
            title: "Settings",
            subtitle: "Basic settings for the prototype.",
          ),

          const AppCard(
            child: Text(
              "More settings later ( notification rules, role permissions). "
              ,
              style: TextStyle(fontSize: 13),
            ),
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
            ),
          ),
        ],
      ),
    );
  }
}