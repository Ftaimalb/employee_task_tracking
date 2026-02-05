import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/UI_cards.dart';
import '../login/login_page.dart';

class EmployeeProfileTab extends StatelessWidget {
  const EmployeeProfileTab({super.key});

  Future<void> logout(BuildContext context) async {
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
    final email = FirebaseAuth.instance.currentUser?.email ?? "employee@email.com";

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionTitle(
            title: "Profile",
            subtitle: "Basic profile details for the prototype.",
          ),

          AppCard(
            child: Row(
              children: [
                const CircleAvatar(radius: 26, child: Icon(Icons.person_outline)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Employee User", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    const Text("Employee", style: TextStyle(fontSize: 12, color: Colors.black54)),
                    const SizedBox(height: 2),
                    Text(email, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const AppCard(
            child: Text(
              "Profile later",
              style: TextStyle(fontSize: 13),
            ),
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => logout(context),
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
            ),
          ),
        ],
      ),
    );
  }
}