import 'package:doan/Admin/account_management.dart';
import 'package:doan/Admin/event_list_management.dart';
import 'package:doan/Admin/event_management.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  AdminDashboardScreenState createState() => AdminDashboardScreenState();
}

class AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0; // Track the selected tab

  // Different screens corresponding to each tab in the bottom navigation bar
  static final List<Widget> _widgetOptions = <Widget>[
    const UserManagementScreen(), // Manage Users
    const EventManagementScreen(), // Manage Events
    EventListManagementScreen(), // Manage Participants
    const StatisticsScreen(), // View Statistics
    const ExportReportScreen(), // Export Report
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quản Trị",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Người dùng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Sự kiện',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Danh Sách',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Thống Kê',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Xuất Báo Cáo',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures the bar does not shift
        backgroundColor: Colors.white,
      ),
    );
  }
}

// Example ParticipantListScreen, StatisticsScreen, ExportReportScreen
// You can replace these with your actual widget implementations

class ParticipantListScreen extends StatelessWidget {
  const ParticipantListScreen({super.key, required eventId});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Participant List'));
  }
}

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Statistics Screen'));
  }
}

class ExportReportScreen extends StatelessWidget {
  const ExportReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Export Report Screen'));
  }
}
