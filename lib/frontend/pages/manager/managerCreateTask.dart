import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/UI_cards.dart';
import '../../../backend/services/tasks_service.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final taskService = TaskService();
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool saving = false;

  String priority = "Medium";
  DateTime? dueDate;

  // employees loaded from Firestore
  List<Map<String, dynamic>> employees = [];
  Map<String, dynamic>? selectedEmployee;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadEmployees() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'employee')
          .where('isActive', isEqualTo: true)
          .get();

      final list = snap.docs.map((d) {
        final data = d.data();
        data["uid"] = d.id; // doc id = Firebase Auth UID
        return data;
      }).toList();

      setState(() {
        employees = list;
        selectedEmployee = employees.isNotEmpty ? employees.first : null;
      });
    } catch (e) {
      setState(() {
        employees = [];
        selectedEmployee = null;
      });
    }
  }

  Future<void> _pickDueDate() async {
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

  Future<void> _createTask() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (selectedEmployee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No employee selected.")),
      );
      return;
    }

    setState(() => saving = true);

    try {
      final assigneeUid = selectedEmployee!["uid"].toString();
      final assigneeName =
          (selectedEmployee!["username"] ?? selectedEmployee!["email"] ?? "Employee")
              .toString();

      final taskId = await taskService.createTask(
        title: titleCtrl.text,
        description: descCtrl.text,
        priority: priority,
        assigneeUid: assigneeUid,
        assigneeName: assigneeName,
        dueDate: dueDate,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Task created (ID: $taskId)")),
      );

      titleCtrl.clear();
      descCtrl.clear();
      setState(() {
        priority = "Medium";
        dueDate = null;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Could not create task: ${e.toString().replaceFirst('Exception: ', '')}",
          ),
        ),
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
      appBar: AppBar(
        title: const Text("Create Task"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSectionTitle(
              title: "New task",
              subtitle: "Fill in the details and assign it to an employee.",
            ),
            AppCard(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleCtrl,
                      decoration: InputDecoration(
                        labelText: "Task title",
                        prefixIcon: const Icon(Icons.title),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      validator: (v) {
                        if ((v ?? "").trim().isEmpty) return "Title is required.";
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: descCtrl,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: "Description (optional)",
                        alignLabelWithHint: true,
                        prefixIcon: const Icon(Icons.description_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: priority,
                      decoration: InputDecoration(
                        labelText: "Priority",
                        prefixIcon: const Icon(Icons.flag_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: "Low", child: Text("Low")),
                        DropdownMenuItem(value: "Medium", child: Text("Medium")),
                        DropdownMenuItem(value: "High", child: Text("High")),
                      ],
                      onChanged: (v) => setState(() => priority = v ?? "Medium"),
                    ),
                    const SizedBox(height: 12),

                    if (employees.isEmpty) ...[
                      const AppCard(
                        child: Text(
                          "No employees found. Ask the admin to create employee accounts.",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ] else ...[
                      DropdownButtonFormField<Map<String, dynamic>>(
                        value: selectedEmployee,
                        decoration: InputDecoration(
                          labelText: "Assign to",
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        items: employees.map((e) {
                          final name =
                              (e["username"] ?? e["email"] ?? "Employee").toString();
                          return DropdownMenuItem(value: e, child: Text(name));
                        }).toList(),
                        onChanged: (v) => setState(() => selectedEmployee = v),
                      ),
                    ],

                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _pickDueDate,
                        icon: const Icon(Icons.calendar_today_outlined),
                        label: Text(dueLabel),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: saving ? null : _createTask,
                        child: saving
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text("Create task"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}