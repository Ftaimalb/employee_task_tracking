import 'package:flutter/material.dart';

class AppSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const AppSectionTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          ],
        ],
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  final Widget child;

  const AppCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 12,
            offset: Offset(0, 5),
            color: Color(0x14000000),
          )
        ],
      ),
      child: child,
    );
  }
}

class StatMiniCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const StatMiniCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppCard(
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}