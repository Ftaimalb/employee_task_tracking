import 'package:flutter/material.dart';
import '../../../backend/services/tasks_service.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final taskService = TaskService();
  bool saving = false;

  final formKey = GlobalKey<FormState>();

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  String priority = "Medium";
  String assignee = "Ali Hassan";
  DateTime? dueDate;

  final dummyEmployees = ["Ali Hassan"];

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

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    setState(() => saving = true);

    try {
      final id = await taskService.createTask(
        title: titleCtrl.text,
        description: descCtrl.text,
        priority: priority,
        assigneeName: assignee,
        dueDate: dueDate,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Task created (ID: $id)")),
      );


      titleCtrl.clear();
      descCtrl.clear();
      setState(() {
        priority = "Medium";
        assignee = dummyEmployees.first;
        dueDate = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Could not create task: ${e.toString().replaceFirst('Exception: ', '')}")),
      );
    } finally {
      if (mounted) setState(() => saving = false);
    }
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
                BoxShadow(
                    blurRadius: 10,
                    offset: Offset(0, 4),
                    color: Color(0x14000000)),
              ],
            ),
            child: Column(
              children: [
                TextFormField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: "Task title",
                    prefixIcon: const Icon(Icons.title),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (v) =>
                      (v ?? "").trim().isEmpty ? "Title is required." : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descCtrl,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Description",
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(Icons.description_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: priority,
                  decoration: InputDecoration(
                    labelText: "Priority",
                    prefixIcon: const Icon(Icons.flag_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
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
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  items: dummyEmployees
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => assignee = v ?? dummyEmployees.first),
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
                    onPressed: saving ? null : submit,
                    child: saving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text("Create task"),
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
