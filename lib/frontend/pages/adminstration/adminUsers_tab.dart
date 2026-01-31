import 'package:flutter/material.dart';

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
        children: [
          Row(
            children: [
              const Expanded(
                child: Text("Users", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateUserPage()),
                  );
                },
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text("Create"),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Expanded(
            child: ListView.separated(
              itemCount: dummyUsers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final u = dummyUsers[index];
                final isDisabled = u["status"] == "Disabled";

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(blurRadius: 10, offset: Offset(0, 4), color: Color(0x14000000))],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        child: Text((u["name"] ?? "U")[0]),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(u["name"] ?? "", style: const TextStyle(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 2),
                            Text(u["role"] ?? "", style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                      _StatusPill(text: u["status"] ?? "", disabled: isDisabled),
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

class _StatusPill extends StatelessWidget {
  final String text;
  final bool disabled;

  const _StatusPill({required this.text, required this.disabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: disabled ? const Color(0xFFFFE5E5) : const Color.fromARGB(255, 164, 227, 217),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}