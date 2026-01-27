import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _tempPassword = TextEditingController();

  String _role = "employee";
  bool _isActive = true;

  bool _loading = false;
  String? _error;
  String? _success;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _tempPassword.dispose();
    super.dispose();
  }

  Future<void> _createUser() async {
    setState(() {
      _error = null;
      _success = null;
      _loading = true;
    });

    try {
      if (!(_formKey.currentState?.validate() ?? false)) {
        setState(() => _loading = false);
        return;
      }

      final callable = FirebaseFunctions.instance.httpsCallable('createUser');
      final result = await callable.call({
        "fullName": _name.text.trim(),
        "email": _email.text.trim(),
        "tempPassword": _tempPassword.text,
        "role": _role,
        "isActive": _isActive,
      });

      final uid = (result.data as Map?)?["uid"]?.toString();

      setState(() {
        _success = "User created successfully. UID: ${uid ?? "created"}";
      });

      _name.clear();
      _email.clear();
      _tempPassword.clear();
      _role = "employee";
      _isActive = true;
    } on FirebaseFunctionsException catch (e) {
      setState(() {
        _error = e.message ?? "Something went wrong while creating the user.";
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst("Exception: ", "");
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create User")),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Create a new account",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 10),

                      if (_error != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1F1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(_error!, style: const TextStyle(fontSize: 13)),
                        ),
                        const SizedBox(height: 10),
                      ],

                      if (_success != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1FFF3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(_success!, style: const TextStyle(fontSize: 13)),
                        ),
                        const SizedBox(height: 10),
                      ],

                      TextFormField(
                        controller: _name,
                        decoration: InputDecoration(
                          labelText: "Full name",
                          prefixIcon: const Icon(Icons.badge_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        validator: (v) => (v ?? "").trim().isEmpty ? "Full name is required." : null,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        validator: (v) {
                          final value = (v ?? "").trim();
                          if (value.isEmpty) return "Email is required.";
                          if (!value.contains("@") || !value.contains(".")) return "Enter a valid email.";
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _tempPassword,
                        decoration: InputDecoration(
                          labelText: "Temporary password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        validator: (v) {
                          final value = v ?? "";
                          if (value.isEmpty) return "Temporary password is required.";
                          if (value.length < 6) return "Password should be at least 6 characters.";
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: _role,
                        decoration: InputDecoration(
                          labelText: "Role",
                          prefixIcon: const Icon(Icons.manage_accounts_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        items: const [
                          DropdownMenuItem(value: "admin", child: Text("Admin")),
                          DropdownMenuItem(value: "manager", child: Text("Manager")),
                          DropdownMenuItem(value: "employee", child: Text("Employee")),
                        ],
                        onChanged: (v) => setState(() => _role = v ?? "employee"),
                      ),
                      const SizedBox(height: 10),

                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Account active"),
                        value: _isActive,
                        onChanged: (v) => setState(() => _isActive = v),
                      ),

                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _createUser,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text("Create user"),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Tip: give a temporary password and ask the user to change it after first login.",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}