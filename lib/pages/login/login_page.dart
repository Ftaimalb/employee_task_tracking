import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../adminstration/adminDashboard.dart';
import '../employee/employeeDashboard.dart';
import '../manager/managerDashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _hidePassword = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _error = null;
      _loading = true;
    });

    try {
      if (!(_formKey.currentState?.validate() ?? false)) {
        setState(() => _loading = false);
        return;
      }

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final UserCredential =
          await _authService.signIn(email: email, password: password);
      final uid = UserCredential.user?.uid;

      if (uid == null) {
        throw FirebaseAuthException(
            code: 'no-uid', message: 'Login failed. Please try again.');
      }

      // Fetch user profile from Firestore: users/{uid}
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        await FirebaseAuth.instance.signOut();
        throw Exception("No user profile found. Please contact the admin.");
      }

      final data = userDoc.data()!;
      final role = (data['role'] ?? '').toString().toLowerCase();
      final isActive = (data['isActive'] ?? true) == true;

      if (!isActive) {
        await FirebaseAuth.instance.signOut();
        throw Exception("Your account is disabled. Please contact the admin.");
      }

      if (!context.mounted) return;

      // Route based on role
      if (role == 'admin') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const AdminDashboard()));
      } else if (role == 'manager') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const ManagerDashboard()));
      } else if (role == 'employee') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const EmployeeDashboard()));
      } else {
        await FirebaseAuth.instance.signOut();
        throw Exception("Account role not found. Contact the administrator.");
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = _AuthError(e);
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  String _AuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "No account found with that email.";
      case 'wrong-password':
        return "Incorrect password. Please try again.";
      case 'invalid-email':
        return "Please enter a valid email address.";
      case 'too-many-requests':
        return "Too many attempts. Try again later.";
      default:
        return e.message ?? "Login failed. Please try again.";
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() =>
          _error = "Enter your email first, then click 'Forgot password?'.");
      return;
    }

    try {
      await _authService.resetPassword(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset email sent.")),
      );
    } catch (_) {
      setState(() => _error =
          "Could not send reset email. Check the email and try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // simple soft background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 164, 227, 217),
              Color.fromARGB(255, 232, 226, 226)
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        const Icon(Icons.task_alt, size: 44),
                        const SizedBox(height: 12),
                        const Text(
                          "Employee Task Tracking",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Sign in to continue",
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 18),
                        if (_error != null) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color.fromARGB(255, 164, 227, 217),
                            ),
                            child: Text(
                              _error!,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          validator: (v) {
                            final value = (v ?? "").trim();
                            if (value.isEmpty) return "Email is required.";
                            if (!value.contains("@") || !value.contains("."))
                              return "Enter a valid email.";
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _hidePassword,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14)),
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                  () => _hidePassword = !_hidePassword),
                              icon: Icon(_hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                          validator: (v) {
                            if ((v ?? "").isEmpty)
                              return "Password is required.";
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _loading ? null : _forgotPassword,
                            child: const Text("Forgot password?"),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            child: _loading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Text("Login"),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
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
