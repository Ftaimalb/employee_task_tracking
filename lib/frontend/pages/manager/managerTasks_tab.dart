import 'package:flutter/material.dart';
import '../../widgets/UI_cards.dart';
import '../sharedPages/taskDetailsPage.dart';

class ManagerTasksTab extends StatefulWidget {
  const ManagerTasksTab({super.key});

  @override
  State<ManagerTasksTab> createState() => _ManagerTasksTabState();
}

class _ManagerTasksTabState extends State<ManagerTasksTab> {
  String filter = "All";

final tasks = [
    {"title": "Prepare weekly report", "assignee": "Ali Hassan", "due": "Fri", "priority": "High", "status": "In Progress"},
    {"title": "Update client spreadsheet", "assignee": "Noor Saleh", "due": "Mon", "priority": "Medium", "status": "To Do"},
    {"title": "Review meeting notes", "assignee": "Sara Ahmed", "due": "Today", "priority": "Low", "status": "Done"},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = tasks.where((t) {
      if (filter == "All") return true;
      return (t["status"] ?? "") == filter;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionTitle(
            title: "Tasks",
            subtitle: "Filter and open a task to view details.",
          ),
          Row(
            children: [
              _chip("All"),
              const SizedBox(width: 8),
              _chip("To Do"),
              const SizedBox(width: 8),
              _chip("In Progress"),
              const SizedBox(width: 8),
              _chip("Done"),
            ],
          ),
          const SizedBox(height: 12),

          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final t = filtered[i];

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailsScreen(task: t)));
                  },
                  child: AppCard(
                    child: Row(
                      children: [
                        const Icon(Icons.assignment_outlined),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t["title"] ?? "", style: const TextStyle(fontWeight: FontWeight.w800)),
                              const SizedBox(height: 4),
                              Text(
                                "Assignee: ${t["assignee"]} • Due: ${t["due"]} • Priority: ${t["priority"]}",
                                style: const TextStyle(fontSize: 12, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        _pill(t["status"] ?? ""),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label) {
    final selected = filter == label;
    return InkWell(
      onTap: () => setState(() => filter = label),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Text(label, style: TextStyle(color: selected ? Colors.white : Colors.black, fontSize: 12)),
      ),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}