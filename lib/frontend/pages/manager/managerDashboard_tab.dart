import 'package:flutter/material.dart';
import '../../widgets/UI_cards.dart';
import 'managerCreateTask.dart';

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
          const AppSectionTitle(
            title: "Hi, Manager",
            subtitle: "Track your team’s tasks and assign work.",
          ),

          Row(
            children: const [
              StatMiniCard(label: "Total", value: "$total", icon: Icons.assignment_outlined),
              SizedBox(width: 12),
              StatMiniCard(label: "Overdue", value: "$overdue", icon: Icons.warning_amber_outlined),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: const [
              StatMiniCard(label: "Completed", value: "$done", icon: Icons.check_circle_outline),
              SizedBox(width: 12),
              StatMiniCard(label: "In progress", value: "4", icon: Icons.timelapse_outlined),
            ],
          ),

          const SizedBox(height: 18),
          const AppSectionTitle(title: "Quick actions"),

          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CreateTaskScreen()),
                      );
                    },
                    icon: const Icon(Icons.add_task),
                    label: const Text("Create task"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("UI only: Team screen later.")),
                      );
                    },
                    icon: const Icon(Icons.people_outline),
                    label: const Text("Team"),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const AppSectionTitle(title: "Note"),
          const AppCard(
            child: Text(
              "uses dummy numbers ",
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}