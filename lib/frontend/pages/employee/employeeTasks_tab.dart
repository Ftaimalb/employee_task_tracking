import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/ui_cards.dart';
import '../sharedPages/taskDetailsPage.dart';

class EmployeeTasksTab extends StatefulWidget {
  const EmployeeTasksTab({super.key});

  @override
  State<EmployeeTasksTab> createState() => _EmployeeTasksTabState();
}

class _EmployeeTasksTabState extends State<EmployeeTasksTab> {
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Center(child: Text("Not logged in."));
    }

    final taskStream = FirebaseFirestore.instance
        .collection('tasks')
        .where('assigneeUid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionTitle(
            title: "My tasks",
            subtitle: "Tasks assigned to you .",
          ),
          Row(
            children: [
              _filterChip("All"),
              const SizedBox(width: 8),
              _filterChip("To Do"),
              const SizedBox(width: 8),
              _filterChip("In Progress"),
              const SizedBox(width: 8),
              _filterChip("Done"),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: taskStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Failed to load tasks."));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];

                List<Map<String, dynamic>> tasks = [];
                for (var doc in docs) {
                  final data = doc.data() as Map<String, dynamic>;
                  data["id"] = doc.id;
                  tasks.add(data);
                }

                // Apply filter locally
                final visibleTasks = tasks.where((task) {
                  if (selectedFilter == "All") return true;
                  return task["status"] == selectedFilter;
                }).toList();

                if (visibleTasks.isEmpty) {
                  return AppCard(
                    child: Text(
                      selectedFilter == "All"
                          ? "No tasks assigned to you yet."
                          : "No tasks in '$selectedFilter' right now.",
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: visibleTasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final task = visibleTasks[index];

                    final title = task["title"] ?? "Untitled task";
                    final status = task["status"] ?? "To Do";
                    final priority = task["priority"] ?? "Medium";
                    final due = _formatDueDate(task["dueDate"]);

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskDetailsScreen(task: task),
                          ),
                        );
                      },
                      child: AppCard(
                        child: Row(
                          children: [
                            const Icon(Icons.checklist_outlined),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Due: $due • Priority: $priority",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            _statusPill(status),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final isSelected = selectedFilter == label;

    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _statusPill(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }

  String _formatDueDate(dynamic dueDate) {
    if (dueDate == null) return "-";

    if (dueDate is Timestamp) {
      final d = dueDate.toDate();
      return "${d.day}/${d.month}/${d.year}";
    }

    return dueDate.toString();
  }
}
