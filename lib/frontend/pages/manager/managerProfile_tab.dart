import 'package:flutter/material.dart';

class ManagerProfileTab extends StatelessWidget {
  const ManagerProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Profile ",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}