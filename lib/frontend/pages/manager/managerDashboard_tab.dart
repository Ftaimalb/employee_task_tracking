import 'package:flutter/material.dart';

class ManagerDashboardTab extends StatelessWidget {
  const ManagerDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy counts (replace later with Firestore)
    const total = 12;
    const overdue = 2;
    const done = 5;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Overview", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(child: _StatCard(title: "Total Tasks", value: "$total", icon: Icons.assignment_outlined)),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(title: "Overdue", value: "$overdue", icon: Icons.warning_amber_outlined)),
            ],
          ),
          const SizedBox(height: 12),
          _StatCard(title: "Completed", value: "$done", icon: Icons.check_circle_outline),

          const SizedBox(height: 18),
          const Text("Quick actions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ActionButton(
                icon: Icons.add_task,
                label: "Create task",
                onTap: () {
                },
              ),
              _ActionButton(
                icon: Icons.people_outline,
                label: "Team",
                onTap: () {
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 10, offset: Offset(0, 4), color: Color(0x14000000))],
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(blurRadius: 10, offset: Offset(0, 4), color: Color(0x14000000))],
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          ],
        ),
      ),
    );
  }
}