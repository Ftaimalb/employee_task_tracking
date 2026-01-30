import 'package:flutter/material.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Map task;
  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final title = task["title"] ?? "Task";
    final status = task["status"] ?? "To Do";
    final priority = task["priority"] ?? "Medium";
    final assignee = task["assignee"] ?? "Unknown";
    final due = task["due"] ?? "-";

    // Dummy comments + attachments
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
          children: [
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text("Assignee: $assignee"),
                  Text("Due: $due"),
                  Text("Priority: $priority"),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("Status: ", style: TextStyle(fontWeight: FontWeight.w700)),
                      _Pill(status),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Comments", style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  ...comments.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(radius: 14, child: Text((c["name"] ?? "U")[0])),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F4F7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text("${c["name"]}: ${c["text"]}"),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Add a comment (UI only)",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Attachments", style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  ...attachments.map((a) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.attach_file),
                        title: Text(a["name"] ?? ""),
                        subtitle: const Text("UI only"),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 10, offset: Offset(0, 4), color: Color(0x14000000))],
      ),
      child: child,
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill(this.text);

  @override
  Widget build(BuildContext context) {
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