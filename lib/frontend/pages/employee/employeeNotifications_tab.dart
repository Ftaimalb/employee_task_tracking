import 'package:flutter/material.dart';
import '../../widgets/UI_cards.dart';


class EmployeeNotificationsTab extends StatelessWidget {
  const EmployeeNotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = [
      {"title": "New task assigned", "detail": "Upload attendance sheet", "time": "10 mins ago"},
      {"title": "Task updated", "detail": "Weekly report due date changed", "time": "Yesterday"},
      {"title": "Reminder", "detail": "2 tasks due soon", "time": "2 days ago"},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionTitle(
            title: "Alerts",
            subtitle: "Notifications about tasks and updates.",
          ),
          Expanded(
            child: ListView.separated(
              itemCount: alerts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final a = alerts[i];
                return AppCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.notifications_none),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a["title"] ?? "", style: const TextStyle(fontWeight: FontWeight.w800)),
                            const SizedBox(height: 4),
                            Text(a["detail"] ?? "", style: const TextStyle(fontSize: 12, color: Colors.black54)),
                            const SizedBox(height: 6),
                            Text(a["time"] ?? "", style: const TextStyle(fontSize: 11, color: Colors.black45)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}