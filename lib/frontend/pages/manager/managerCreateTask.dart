import 'package:flutter/material.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final formKey = GlobalKey<FormState>();

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  String priority = "Medium";
  String assignee = "Ali Hassan";
  DateTime? dueDate;

  final dummyEmployees = ["Ali Hassan", "Noor Saleh", "Sara Ahmed"];

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  Future<void> pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDate: dueDate ?? now,
    );
    if (picked != null) {
      setState(() => dueDate = picked);
    }
  }

  void submit() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    // UI-only: show what would be saved
    final dueText = dueDate == null
        ? "No date"
        : "${dueDate!.day}/${dueDate!.month}/${dueDate!.year}";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Task created (UI only) • $assignee • $priority • $dueText"),
      ),
    );

    // clear form
    titleCtrl.clear();
    descCtrl.clear();
    setState(() {
      priority = "Medium";
      assignee = dummyEmployees.first;
      dueDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dueLabel = dueDate == null
        ? "Select due date"
        : "Due: ${dueDate!.day}/${dueDate!.month}/${dueDate!.year}";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(title: const Text("Create Task")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(blurRadius: 10, offset: Offset(0, 4), color: Color(0x14000000)),
              ],
            ),
            child: Column(
              children: [
                TextFormField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: "Task title",
                    prefixIcon: const Icon(Icons.title),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (v) => (v ?? "").trim().isEmpty ? "Title is required." : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: descCtrl,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Description",
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(Icons.description_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: priority,
                  decoration: InputDecoration(
                    labelText: "Priority",
                    prefixIcon: const Icon(Icons.flag_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  items: const [
                    DropdownMenuItem(value: "Low", child: Text("Low")),
                    DropdownMenuItem(value: "Medium", child: Text("Medium")),
                    DropdownMenuItem(value: "High", child: Text("High")),
                  ],
                  onChanged: (v) => setState(() => priority = v ?? "Medium"),
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: assignee,
                  decoration: InputDecoration(
                    labelText: "Assign to",
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  items: dummyEmployees
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => assignee = v ?? dummyEmployees.first),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: pickDueDate,
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text(dueLabel),
                  ),
                ),

                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: submit,
                    child: const Text("Create task"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}