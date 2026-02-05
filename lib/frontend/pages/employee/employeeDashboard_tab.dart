import 'package:flutter/material.dart';
import '../../widgets/UI_cards.dart';

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
          const AppSectionTitle(
            title: "Hi, Employee",
            subtitle: "Here is a quick summary of your tasks.",
          ),
          Row(
            children: const [
              StatMiniCard(
                  label: "Assigned",
                  value: "$assigned",
                  icon: Icons.assignment_outlined),
              SizedBox(width: 12),
              StatMiniCard(
                  label: "Due soon",
                  value: "$dueSoon",
                  icon: Icons.schedule_outlined),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              StatMiniCard(
                  label: "Completed",
                  value: "$completed",
                  icon: Icons.check_circle_outline),
              SizedBox(width: 12),
              StatMiniCard(
                  label: "Overdue",
                  value: "1",
                  icon: Icons.warning_amber_outlined),
            ],
          ),
          const SizedBox(height: 18),
          const AppSectionTitle(title: "Today"),
          const AppCard(
            child: Text(
              "You have 2 tasks due soon. Open 'My Tasks' to update progress or upload attachments.",
              style: TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(height: 12),
          const AppSectionTitle(title: "Quick tips"),
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("• Update task status regularly."),
                SizedBox(height: 6),
                Text("• Add comments if you need help."),
                SizedBox(height: 6),
                Text("• Upload files to keep evidence of work."),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
