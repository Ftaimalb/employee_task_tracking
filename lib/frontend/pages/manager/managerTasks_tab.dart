import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/UI_cards.dart';
import '../sharedPages/taskDetailsPage.dart';

class ManagerTasksTab extends StatefulWidget {
  const ManagerTasksTab({super.key});

  @override
  State<ManagerTasksTab> createState() => _ManagerTasksTabState();
}

class _ManagerTasksTabState extends State<ManagerTasksTab> {
  // used to filter tasks by status
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    // get all tasks created, newest first
    final taskStream = FirebaseFirestore.instance
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionTitle(
            title: "Tasks",
            subtitle: "Tasks created by managers (live data).",
          ),

          // filter buttons
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
                  return const Center(
                    child: Text("Failed to load tasks."),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // convert Firestore docs to list of maps
                final docs = snapshot.data?.docs ?? [];
                List<Map<String, dynamic>> tasks = [];

                for (var doc in docs) {
                  final data = doc.data() as Map<String, dynamic>;
                  data["id"] = doc.id; // keep id for later use
                  tasks.add(data);
                }

                // apply filter 
                final visibleTasks = tasks.where((task) {
                  if (selectedFilter == "All") return true;
                  return task["status"] == selectedFilter;
                }).toList();

                if (visibleTasks.isEmpty) {
                  return AppCard(
                    child: Text(
                      selectedFilter == "All"
                          ? "No tasks have been created yet."
                          : "No tasks with status '$selectedFilter'.",
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
                    final assignee = task["assigneeName"] ?? "Not assigned";
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
                            const Icon(Icons.assignment_outlined),
                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Assignee: $assignee • Due: $due • Priority: $priority",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
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

  // filter chip used at the top
  Widget _filterChip(String label) {
    final bool isSelected = selectedFilter == label;

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

  // small pill showing task status
  Widget _statusPill(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // format Firestore timestamp safely
  String _formatDueDate(dynamic dueDate) {
    if (dueDate == null) return "-";

    if (dueDate is Timestamp) {
      final d = dueDate.toDate();
      return "${d.day}/${d.month}/${d.year}";
    }

    return dueDate.toString();
  }
}