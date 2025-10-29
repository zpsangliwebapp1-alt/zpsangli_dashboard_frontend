import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // Dummy notifications
  final List<Map<String, dynamic>> dummyNotifications = const [
    {
      'title': 'Monthly Report Submission Reminder',
      'description': 'All Taluka offices must submit monthly reports by 31st Oct.',
      'type': 'Reminder',
      'date': '23 Oct, 08:00 AM',
      'status': 'Read',
    },
    {
      'title': 'New Panchayat Meeting Scheduled',
      'description': 'Meeting for Sanitation Scheme review at 10 AM on 28th Oct.',
      'type': 'Meeting',
      'date': '28 Oct, 10:00 AM',
      'status': 'Unread',
    },
    {
      'title': 'Scheme Approval Pending',
      'description':
      'Approval required for “Rural Road Construction” scheme submitted by Taluka Office.',
      'type': 'Scheme',
      'date': '27 Oct, 03:15 PM',
      'status': 'Unread',
    },
    {
      'title': 'Fund Allocation Notice',
      'description':
      'Funds allocated for Water Supply project in Sangli block. Check report.',
      'type': 'Finance',
      'date': '26 Oct, 11:45 AM',
      'status': 'Read',
    },
    {
      'title': 'Community Health Camp',
      'description':
      'Notification for organizing Health Camp at village level on 30th Oct.',
      'type': 'Event',
      'date': '25 Oct, 09:00 AM',
      'status': 'Unread',
    },
    {
      'title': 'Emergency Advisory: Monsoon Flood Alert',
      'description':
      'Alert for low-lying areas. Immediate action required by Panchayat members.',
      'type': 'Alert',
      'date': '24 Oct, 05:30 PM',
      'status': 'Unread',
    },

    {
      'title': 'New Policy Update',
      'description':
      'Revised guidelines for Sanitation Scheme implementation circulated.',
      'type': 'Policy',
      'date': '22 Oct, 02:20 PM',
      'status': 'Read',
    },
  ];

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'Meeting':
        return Colors.blueAccent;
      case 'Scheme':
        return Colors.orangeAccent;
      case 'Finance':
        return Colors.green;
      case 'Event':
        return Colors.purple;
      case 'Alert':
        return Colors.redAccent;
      case 'Reminder':
        return Colors.teal;
      case 'Policy':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'Meeting':
        return Icons.meeting_room;
      case 'Scheme':
        return Icons.assignment;
      case 'Finance':
        return Icons.account_balance_wallet;
      case 'Event':
        return Icons.event;
      case 'Alert':
        return Icons.warning;
      case 'Reminder':
        return Icons.alarm;
      case 'Policy':
        return Icons.policy;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CEO Notifications',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyNotifications.length,
        itemBuilder: (context, index) {
          final notification = dummyNotifications[index];
          return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Avatar
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: _getNotificationColor(notification['type']),
                    child: Icon(
                      _getNotificationIcon(notification['type']),
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Notification Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification['title'],
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          notification['description'],
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black87, height: 1.4),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              notification['date'],
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.grey),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: notification['status'] == 'Unread'
                                    ? Colors.redAccent
                                    : Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                notification['status'],
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
