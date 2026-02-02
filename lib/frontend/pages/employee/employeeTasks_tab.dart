import 'package:flutter/material.dart';

import '../sharedPages/taskDetailsPage.dart';

class EmployeeTasksTab extends StatefulWidget {
  const EmployeeTasksTab({super.key});

  @override
  State<EmployeeTasksTab> createState() => _EmployeeTasksTabState();
}

class _EmployeeTasksTabState extends State<EmployeeTasksTab> {
  String filter = "All";

  final myTasks = [
    {
      "title": "Prepare weekly report",
      "assignee": "You",
      "due": "Fri",
      "priority": "High",
      "status": "In Progress",
    },
    {
      "title": "Upload attendance sheet",
      "assignee": "You",
      "due": "Today",
      "priority": "Medium",
      "status": "To Do",
    },
    {
      "title": "Complete training module",
      "assignee": "You",
      "due": "Next week",
      "priority": "Low",
      "status": "Done",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = myTasks.where((t) {
      if (filter == "All") return true;
      return (t["status"] ?? "") == filter;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              _Chip(label: "All", selected: filter == "All", onTap: () => setState(() => filter = "All")),
              const SizedBox(width: 8),
              _Chip(label: "To Do", selected: filter == "To Do", onTap: () => setState(() => filter = "To Do")),
              const SizedBox(width: 8),
              _Chip(label: "In Progress", selected: filter == "In Progress", onTap: () => setState(() => filter = "In Progress")),
              const SizedBox(width: 8),
              _Chip(label: "Done", selected: filter == "Done", onTap: () => setState(() => filter = "Done")),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskDetailsScreen(task: t),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(blurRadius: 10, offset: Offset(0, 4), color: Color(0x14000000))],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.checklist_outlined),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t["title"] ?? "", style: const TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text("Due: ${t["due"]} • Priority: ${t["priority"]}", style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        _Tag(text: t["status"] ?? ""),
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
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}