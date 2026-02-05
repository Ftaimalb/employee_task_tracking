import 'package:flutter/material.dart';

import '../../widgets/UI_cards.dart';
import 'createUserPage.dart';

class AdminUsersTab extends StatelessWidget {
  const AdminUsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyUsers = [
      {"name": "Fatma Albader", "role": "Admin", "status": "Active"},
      {"name": "Sara Ahmed", "role": "Manager", "status": "Active"},
      {"name": "Ali Hassan", "role": "Employee", "status": "Active"},
      {"name": "Noor Saleh", "role": "Employee", "status": "Disabled"},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: AppSectionTitle(
                  title: "Users",
                  subtitle: "Dummy data for layout testing.",
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateUserPage()));
                },
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text("Create"),
              ),
            ],
          ),
          const SizedBox(height: 6),

          Expanded(
            child: ListView.separated(
              itemCount: dummyUsers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final u = dummyUsers[index];
                final isDisabled = u["status"] == "Disabled";

                return AppCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        child: Text((u["name"] ?? "U").toString()[0]),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(u["name"] ?? "", style: const TextStyle(fontWeight: FontWeight.w800)),
                            const SizedBox(height: 2),
                            Text(u["role"] ?? "", style: const TextStyle(fontSize: 12, color: Colors.black54)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDisabled ? const Color(0xFFFFE5E5) : const Color(0xFFE7F7EE),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          u["status"] ?? "",
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}