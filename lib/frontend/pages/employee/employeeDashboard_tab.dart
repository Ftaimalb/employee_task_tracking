import 'package:flutter/material.dart';

class EmployeeDashboardTab extends StatelessWidget {
  const EmployeeDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy stats
    const assigned = 6;
    const dueSoon = 2;
    const completed = 3;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("My Overview", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          Row(
            children: const [
              Expanded(child: _StatCard(title: "Assigned", value: "$assigned", icon: Icons.assignment_outlined)),
              SizedBox(width: 12),
              Expanded(child: _StatCard(title: "Due Soon", value: "$dueSoon", icon: Icons.schedule_outlined)),
            ],
          ),
          const SizedBox(height: 12),
          const _StatCard(title: "Completed", value: "$completed", icon: Icons.check_circle_outline),

          const SizedBox(height: 18),
          const Text("Today", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(blurRadius: 10, offset: Offset(0, 4), color: Color(0x14000000))],
            ),
            child: const Text(
              "You have 2 tasks due soon. Check the My Tasks tab to update progress.",
              style: TextStyle(fontSize: 13),
            ),
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
        color: const Color.fromARGB(255, 247, 248, 248),
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