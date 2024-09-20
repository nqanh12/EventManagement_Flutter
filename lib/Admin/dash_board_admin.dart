import 'package:doan/Admin/account_management.dart';
import 'package:doan/Admin/event_management.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Trang Quản Trị",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2, // 2 items per row
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildDashboardCard(
                      icon: Icons.person,
                      label: "Quản Lý Người Dùng",
                      onTap: () {
                        // Navigate to User Management Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>const UserManagementScreen()),
                        );
                      },
                    ),
                    _buildDashboardCard(
                      icon: Icons.event,
                      label: "Quản Lý Sự Kiện",
                      onTap: () {
                        // Navigate to Event Management Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>const EventManagementScreen()),
                        );
                      },
                    ),
                    _buildDashboardCard(
                      icon: Icons.people,
                      label: "Danh Sách Người Tham Gia",
                      onTap: () {
                        // Navigate to Participant List Page
                        Navigator.pushNamed(context, '/participant-list');
                      },
                    ),
                    _buildDashboardCard(
                      icon: Icons.bar_chart,
                      label: "Thống Kê",
                      onTap: () {
                        // Navigate to Statistics Page
                        Navigator.pushNamed(context, '/statistics');
                      },
                    ),
                    _buildDashboardCard(
                      icon: Icons.report,
                      label: "Xuất Báo Cáo",
                      onTap: () {
                        // Navigate to Report Export Page
                        Navigator.pushNamed(context, '/export-report');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.8),
                Colors.blueAccent.withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue[900]),
              const SizedBox(height: 20),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
