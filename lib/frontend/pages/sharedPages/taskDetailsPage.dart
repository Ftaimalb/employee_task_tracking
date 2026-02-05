import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final title = (widget.task["title"] ?? "Task").toString();
    final priority = (widget.task["priority"] ?? "Medium").toString();
    final assignee = (widget.task["assignee"] ?? "Unknown").toString();
    final due = (widget.task["due"] ?? "-").toString();

    final comments = [
      {"name": "Manager", "text": "Please prioritise this today."},
      {"name": "Employee", "text": "Started working on it."},
    ];

    final attachments = [
      {"name": "requirements.pdf"},
      {"name": "screenshot.png"},
    ];

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

            // Summary card
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

                  Text("Assigned to: $assignee",
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),

                  const Text("Status",
                      style: TextStyle(fontWeight: FontWeight.w800)),
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
                    onChanged: (v) {
                      setState(() => status = v ?? status);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Status updated to '$status' (UI only)")),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            const AppSectionTitle(title: "Comments", subtitle: "Keep communication in one place."),

            // Comments card
            AppCard(
              child: Column(
                children: [
                  ...comments.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              child: Text((c["name"] ?? "U").toString()[0]),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F4F7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "${c["name"]}: ${c["text"]}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),

                  const Divider(height: 24),

                  TextField(
                    controller: commentCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "Write a comment (UI only)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (commentCtrl.text.trim().isEmpty) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Comment posted (UI only)")),
                        );
                        commentCtrl.clear();
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

            // Attachments card
            AppCard(
              child: Column(
                children: [
                  ...attachments.map((a) => ListTile(
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
                      )),

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

            const SizedBox(height: 14),
            const AppSectionTitle(title: "Progress note"),

            const AppCard(
              child: Text(
                "This screen uses dummy data and UI-only actions. In the next stage, "
                "status updates, comments and attachments will be connected to Firestore and Storage.",
                style: TextStyle(fontSize: 13),
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