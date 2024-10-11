import 'package:doan/Component/Admin/account_management.dart';
import 'package:doan/Component/Admin/event_list_management.dart';
import 'package:doan/Component/Admin/event_management.dart';
import 'package:doan/Component/Home/login.dart';
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
    const EventListManagementScreen(), // Manage Participants
    const ExportReportScreen(), // Export Report
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showLogoutDialog(BuildContext context, Widget screen) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Xác nhận đăng xuất",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: const Text("Bạn có chắc chắn muốn đăng xuất không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                "Không",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => screen),
                ); // Navigate to the login screen
              },
              child: const Text(
                "Có",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        automaticallyImplyLeading: false, // Remove the default back button
        leading: IconButton(
          icon: const Icon(Icons.logout_sharp),
          onPressed: () {
            _showLogoutDialog(context, const Login()); // Replace with your login screen
          },
        ),
        title: const Text(
          "Quản Trị",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 197, 216, 236),
              Color.fromARGB(255, 25, 117, 215),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _widgetOptions[_selectedIndex], // Display the selected screen
      ),
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
            icon: Icon(Icons.report),
            label: 'Xuất Báo Cáo',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures the bar does not shift
        backgroundColor: Colors.white,
      ),
    );
  }
}

// Example ParticipantListScreen, ExportReportScreen
// You can replace these with your actual widget implementations

class ExportReportScreen extends StatelessWidget {
  const ExportReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 197, 216, 236),
            Color.fromARGB(255, 25, 117, 215),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: const Center(child: Text('Export Report Screen')),
    );
  }
}