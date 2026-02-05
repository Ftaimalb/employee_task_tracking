import 'package:flutter/material.dart';

import '../../widgets/UI_cards.dart';

class AdminDashboardTab extends StatelessWidget {
  const AdminDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy stats
    const totalUsers = 18;
    const activeUsers = 16;
    const disabledUsers = 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionTitle(
            title: "Hi, Admin",
            subtitle: "Manage accounts and  system activity.",
          ),

          Row(
            children: const [
              StatMiniCard(label: "Total users", value: "$totalUsers", icon: Icons.group_outlined),
              SizedBox(width: 12),
              StatMiniCard(label: "Active", value: "$activeUsers", icon: Icons.verified_outlined),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: const [
              StatMiniCard(label: "Disabled", value: "$disabledUsers", icon: Icons.block_outlined),
              SizedBox(width: 12),
              StatMiniCard(label: "Roles", value: "3", icon: Icons.manage_accounts_outlined),
            ],
          ),

          const SizedBox(height: 18),
          const AppSectionTitle(title: "Quick actions"),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("• Create new user accounts (Admin / Manager / Employee)."),
                SizedBox(height: 6),
                Text("• Disable accounts if a user leaves the company."),
                SizedBox(height: 6),
                Text("• Check users tab for a full list."),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const AppSectionTitle(title: "Notes"),
          const AppCard(
            child: Text(
              " dummy statistics.",
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}