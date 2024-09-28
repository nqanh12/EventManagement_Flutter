import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  NotificationsScreenState createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> notifications = [
    NotificationItem(
        title: "Sự kiện A đã bắt đầu",
        isRead: false,
        timestamp: "10:30 AM, 30/08/2024"),
    NotificationItem(
        title: "Cập nhật hệ thống mới",
        isRead: true,
        timestamp: "09:15 AM, 29/08/2024"),
    NotificationItem(
        title: "Sự kiện B đã kết thúc",
        isRead: false,
        timestamp: "08:00 AM, 28/08/2024"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông báo",style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: () {
              setState(() {
                for (var notification in notifications) {
                  notification.isRead = true;
                }
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFC5D8EC), Color(0xFF1975D7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 16),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  setState(() {
                    notifications.removeAt(index);
                  });
                },
                background: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: notifications[index].isRead
                          ? Colors.grey
                          : Colors.blueAccent,
                      child: Icon(
                        notifications[index].isRead
                            ? Icons.notifications_none
                            : Icons.notifications_active,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      notifications[index].title,
                      style: TextStyle(
                        fontWeight: notifications[index].isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      notifications[index].timestamp,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Đánh dấu là đã đọc') {
                          setState(() {
                            notifications[index].isRead = true;
                          });
                        } else if (value == 'Xoá thông báo') {
                          setState(() {
                            notifications.removeAt(index);
                          });
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return {'Đánh dấu là đã đọc', 'Xoá thông báo'}
                            .map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class NotificationItem {
  String title;
  bool isRead;
  String timestamp;

  NotificationItem(
      {required this.title, required this.isRead, required this.timestamp});
}
