import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../backend/services/auth_service.dart';
import '../adminstration/adminDashboard.dart';
import '../employee/employeeDashboard.dart';
import '../manager/managerHomePage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _hidePassword = true;
  bool isLoading = false;
  String? errorMessage;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      errorMessage = null;
      isLoading = true;
    });

    try {
      if (!(formKey.currentState?.validate() ?? false)) {
        setState(() => isLoading = false);
        return;
      }

      final email = emailController.text.trim();
      final password = passwordController.text;

      final userCredential =
          await authService.signIn(email: email, password: password);

      final uid = userCredential.user?.uid;
      if (uid == null) {
        throw Exception("Login failed. Try again.");
      }

      final userSnap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      // Fetch user profile from Firestore: users/{uid}

      if (!userSnap.exists) {
        await FirebaseAuth.instance.signOut();
        throw Exception("No user profile found. Please contact the admin.");
      }

      final userdata = userSnap.data()!;
      final role = (userdata['role'] ?? '').toString().toLowerCase();
      final isActive = (userdata['isActive'] ?? true) == true;

      if (isActive != true) {
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
            MaterialPageRoute(builder: (_) => const ManagerHome()));
      } else if (role == 'employee') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const EmployeeDashboard()));
      } else {
        await FirebaseAuth.instance.signOut();
        throw Exception("Account role not found. Contact the administrator.");
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = authErrorMessage(e);
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  String authErrorMessage(FirebaseAuthException e) {
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
    final email = emailController.text.trim();
    if (email.isEmpty) {
      setState(() => errorMessage =
          "Enter your email first, then click 'Forgot password?'.");
      return;
    }

    try {
      await authService.resetPassword(email: email);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset email sent.")),
      );
    } catch (_) {
      setState(() => errorMessage = "Could not send reset email.");
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
                    key: formKey,
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
                        if (errorMessage != null) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color.fromARGB(255, 164, 227, 217),
                            ),
                            child: Text(
                              errorMessage!,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        TextFormField(
                          controller: emailController,
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
                          controller: passwordController,
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
                            onPressed: isLoading ? null : _forgotPassword,
                            child: const Text("Forgot password?"),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            child: isLoading
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
