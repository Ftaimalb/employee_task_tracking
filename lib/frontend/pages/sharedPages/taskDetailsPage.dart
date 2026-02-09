import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/ui_cards.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Map task;
  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late String status;
  final commentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    status = (widget.task["status"] ?? "To Do").toString();
  }

  @override
  void dispose() {
    commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _updateStatus(String newStatus) async {
    try {
      final taskId = widget.task["id"];
      if (taskId == null) return;

      await FirebaseFirestore.instance
          .collection("tasks")
          .doc(taskId.toString())
          .update({"status": newStatus});

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Status updated to '$newStatus'")),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not update status.")),
      );
    }
  }

  String _formatDue(dynamic dueDate) {
    if (dueDate == null) return "-";
    if (dueDate is Timestamp) {
      final d = dueDate.toDate();
      return "${d.day}/${d.month}/${d.year}";
    }
    return dueDate.toString();
  }

  @override
  Widget build(BuildContext context) {
    final title = (widget.task["title"] ?? "Task").toString();
    final priority = (widget.task["priority"] ?? "Medium").toString();
    final assignee = (widget.task["assigneeName"] ?? "Unknown").toString();
    final due = _formatDue(widget.task["dueDate"]);

    final attachments = [
      {"name": "requirements.pdf"},
      {"name": "screenshot.png"},
    ];

    final taskId = widget.task["id"]?.toString();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(title: const Text("Task details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSectionTitle(
              title: title,
              subtitle: "View task information, update status, and add comments.",
            ),

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _Tag(label: "Priority: $priority"),
                      const SizedBox(width: 8),
                      _Tag(label: "Due: $due"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Assigned to: $assignee",
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  const Text("Status", style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: "To Do", child: Text("To Do")),
                      DropdownMenuItem(value: "In Progress", child: Text("In Progress")),
                      DropdownMenuItem(value: "Done", child: Text("Done")),
                    ],
                    onChanged: (v) async {
                      if (v == null) return;
                      setState(() => status = v);
                      await _updateStatus(v);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            const AppSectionTitle(
              title: "Comments",
              subtitle: "Keep communication in one place.",
            ),

            AppCard(
              child: Column(
                children: [
                  if (taskId == null)
                    const Text("Task ID missing - cannot load comments.")
                  else
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("tasks")
                          .doc(taskId)
                          .collection("comments")
                          .orderBy("createdAt", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Could not load comments.");
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final docs = snapshot.data?.docs ?? [];
                        if (docs.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Text("No comments yet. Be the first to comment."),
                          );
                        }

                        return Column(
                          children: docs.map((d) {
                            final data = d.data() as Map<String, dynamic>;
                            final name = (data["userName"] ?? "User").toString();
                            final text = (data["text"] ?? "").toString();

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(radius: 16, child: Text(name[0])),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF2F4F7),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        "$name: $text",
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),

                  const Divider(height: 24),

                  TextField(
                    controller: commentCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "Write a comment",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: taskId == null
                          ? null
                          : () async {
                              final text = commentCtrl.text.trim();
                              if (text.isEmpty) return;

                              final user = FirebaseAuth.instance.currentUser;
                              if (user == null) return;

                              try {
                                await FirebaseFirestore.instance
                                    .collection("tasks")
                                    .doc(taskId)
                                    .collection("comments")
                                    .add({
                                  "text": text,
                                  "userUid": user.uid,
                                  "userName": user.email ?? "User",
                                  "createdAt": Timestamp.now(),
                                });

                                commentCtrl.clear();
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Could not post comment: $e")),
                                );
                              }
                            },
                      icon: const Icon(Icons.send),
                      label: const Text("Post comment"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            const AppSectionTitle(title: "Attachments", subtitle: "Upload supporting files."),

            AppCard(
              child: Column(
                children: [
                  ...attachments.map(
                    (a) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.attach_file),
                      title: Text(a["name"] ?? ""),
                      subtitle: const Text("UI only"),
                      trailing: IconButton(
                        icon: const Icon(Icons.download_outlined),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Download (UI only)")),
                          );
                        },
                      ),
                    ),
                  ),
                  const Divider(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Upload attachment (UI only)")),
                        );
                      },
                      icon: const Icon(Icons.upload_file),
                      label: const Text("Upload file"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}